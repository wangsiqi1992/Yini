//
//  BWNewsWriter.m
//  Yini
//
//  Created by siqi wang on 12-8-7.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWNewsWriter.h"
static BWNewsWriter *sharedWriter;


@implementation BWNewsWriter

+(BWNewsWriter*)sharedWriter
{
    if (nil != sharedWriter) {
        return sharedWriter;
    }
    else
    {
        sharedWriter = [[BWNewsWriter alloc] init];
    }
    return sharedWriter;
}

- (id)init
{
    self = [super init];
    if (self) {
        status = BWNewsWriterStatusFree;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsLoaderDidLoadFile:) name:[BWNotificationCenter playingGroundAllOurFilesNotificationName] object:nil];
    }
    return self;
}

-(BOOL)composePhotoNewsWithPhoto:(UIImage *)image attributes:(NSDictionary *)attributes
{
    if (status == BWNewsWriterStatusFree)
    {
        
        if (image && [attributes objectForKey:@"news name"])
        {
            task = BWNewsWriterTaskCompostNews;
            pendingAtrributes = attributes;
            
            WSQFileUploader *uploader = [WSQFileUploader sharedLoader];
            NSDate* now = [NSDate date];
            fileName = [[[NSString stringWithFormat:@"%@ %@", [BWLord myLord].displayName, [NSDateFormatter localizedStringFromDate:now dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle]] stringByReplacingOccurrencesOfString:@":" withString:@" "] stringByAppendingPathExtension:@"jpg"];
            
            
            NSString *saveP = [[WSQFileUploader sharedLoader] mediaFileUploadingTempPathForNews:fileName];
            
            NSError *e;
            
            NSData *d = UIImageJPEGRepresentation(image, 1);
            [d writeToFile:saveP options:NSDataWritingAtomic error:&e];
            NSLog(@"%@", [e localizedDescription]);
            
            [uploader saveMediaFileOfNews:fileName withOldName:nil];
            uploader.delegate = self;
            status = BWNewsWriterStatusUploadingMediaFile;
            
            
            [[BWNotificationCenter sharedCenter] loading:YES withProgress:0 uiDescription:@"saving news"];
            return YES;
        }
        return NO;
    }
    else
    {
        return NO;
    }

    
}

-(BOOL)saveNewsObject:(id)newsObject
{
    if (status == BWNewsWriterStatusFree)
    {
        if ([newsObject isKindOfClass:[WSQNews class]]) {
            news = (WSQNews*)newsObject;
            fileName = news.namePath;
            [[WSQFileHelper sharedHelper] refresh];
            waitingForFile = NO;
            status = BWNewsWriterStatusUploadingSystemFile;
            task = BWNewsWriterTaskSaveNews;
            return YES;

        }
        return NO;
    }
    else
    {
        return NO;
    }
}

-(void)uploadTheRightOne:(id)newsObject
{
    WSQFileHelper *helper = [WSQFileHelper sharedHelper];
    WSQFileUploader *uploader = [WSQFileUploader sharedLoader];
    
    if ([newsObject isKindOfClass:[NewsObjectPhoto class]])
    {
        NewsObjectPhoto *n = (NewsObjectPhoto*)newsObject;
        NSString* localP = [uploader sysFileUploadingTempPathForNews:[helper sysPathNameFromDBPath:n.dbpath]];
        [NSKeyedArchiver archiveRootObject:n toFile:localP];
        NSString *name = [helper sysPathNameFromDBPath:n.dbpath];
        
        [uploader saveSysFileOfNews:name withOldName:name];
        uploader.delegate = self;
        if (task == BWNewsWriterTaskSaveNews) {
            status = BWNewsWriterStatusUploadingActivity;///there is a problem... set it to avoid saving mutiple sys file when saveNewsObject: is called, but

        }
        else
        {
            status = BWNewsWriterStatusUploadingSystemFile;
        }
    }
    else
    {
        NSLog(@"file format not supported yet...");
    }

    
}














#pragma mark - delegate call backs...

/**
	tune in the uploader... getting message of media uploaded...
	@param isSucceed blah...
 */
-(void)fileUploadFinished:(BOOL)isSucceed
{
    
    if (isSucceed)
    {
        
        if (task == BWNewsWriterTaskCompostNews) {
            switch (status)
            {
                case BWNewsWriterStatusUploadingMediaFile:
                {
                    [[WSQFileHelper sharedHelper] refresh];
                    status = BWNewsWriterStatusUploadingSystemFile;
                }
                    
                    break;
                case BWNewsWriterStatusUploadingSystemFile:
                {
                    if (task == BWNewsWriterTaskCompostNews)
                    {
                        fileName = nil;
                        pendingAtrributes = nil;
                        [[BWNotificationCenter sharedCenter] loading:NO withProgress:0 uiDescription:@"finished loading"];
                        if ([self.delegate respondsToSelector:@selector(writingNewsSucceed)]) {
                            [self.delegate writingNewsSucceed];
                            
                        }
                        [[WSQFileUploader sharedLoader] setDelegate:Nil];
                        [[NewsLoader sharedLoader] setDelegate:Nil];
                        
                            ///@todo:   move this up a level, shouldn't been done here!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                        if ([news isKindOfClass:[WSQNews class]])
                        {
                            WSQNews *theNews = (WSQNews*)news;
                            BWActivityNews *acti = [[BWActivityNews alloc] initWithNewsSysNamePath:theNews.namePath];
                            [acti setUserDiscription:[NSString stringWithFormat:@"%@ shared a news:", acti.owner.displayName]];
                            [[BWMyLordActivityWriter sharedLordActiWriter] addNewActivity:acti];
                            
                            status = BWNewsWriterStatusUploadingActivity;
                        }
                        news = nil;
                    }
                    else if(task == BWNewsWriterTaskSaveNews)
                    {
                        if ([self.delegate respondsToSelector:@selector(writingNewsSucceed)]) {
                            [self.delegate writingNewsSucceed];
                            
                        }
                        fileName = nil;
                        news = nil;
                        status = BWNewsWriterStatusFree;
                        
                    }
                    
                }
                    break;
                case BWNewsWriterStatusUploadingActivity:
                {
                    status = BWNewsWriterStatusFree;
                }
                    break;
                case BWNewsWriterStatusFree:
                {
                    [WSQFileUploader sharedLoader].delegate = nil;
                }
                    break;
                    
                default:
                    break;
            }
        }
        else if (task == BWNewsWriterTaskSaveNews && status == BWNewsWriterStatusUploadingActivity)
        {
            status = BWNewsWriterStatusFree;
            if ([self.delegate respondsToSelector:@selector(writingNewsSucceed)]) {
                [self.delegate writingNewsSucceed];
            }
            
            
        }
        
        
    }
    else
    {
        NSLog(@"news writer failed to upload media file...");
    }
    
    
    
}


/**
	gethering all changes in our folder... listening the notification center
    only response when waiting
 */
-(void)newsLoaderDidLoadFile:(NSNotification *)note
{
    NSArray *paths = [note.userInfo objectForKey:@"changed paths"];
    BOOL changed = [[note.userInfo objectForKey:@"changed"] boolValue];
    NSString *changedPath = [note.userInfo objectForKey:@"name path"];

    if ((task == BWNewsWriterTaskCompostNews) && (status == BWNewsWriterStatusUploadingSystemFile) && paths)
    {
        for (NSString *np in paths)
        {
            if ([np rangeOfString:fileName].location != NSNotFound)
            {
                    ///this is what we are looking for!
                
                
                WSQFileHelper *helper = [WSQFileHelper sharedHelper];
                WSQNews *wsqNews = [[WSQNews alloc] initWithMetadataPath:[helper mediaMetadataPathForNews:fileName]];
                if (wsqNews.newsType == WSQPhoto)
                {
                    NewsObjectPhoto *newsOject = [[NewsObjectPhoto alloc] initWithMetadataPath:[helper mediaMetadataPathForNews:fileName]];
                    if (newsOject)
                    {
                        newsOject.author = [[BWLord myLord] myLordAsAUser];
                        newsOject.newsName = [pendingAtrributes objectForKey:@"news name"];
                        [self uploadTheRightOne:newsOject];
                        news = newsOject;
                    }
                }
            }
        }
    }
    
    if ((task == BWNewsWriterTaskSaveNews) && (status == BWNewsWriterStatusUploadingSystemFile))
    {
        BOOL ready = YES;
        if (!changed) {
                ///ready!
        }
        else
        {
            if (paths)
            {///if loaded delta and check if it got our file in it
                for (NSString *np in paths)
                {
                    if ([np rangeOfString:fileName].location != NSNotFound)
                    {
                            //[[WSQFileHelper sharedHelper] refresh];//refresh, and wait until there is no our file change happend...
                        waitingForFile = YES;
                        ready = NO;
                        break;
                    }
                }
            }
            else if(changedPath)
            {///if it is a loaded file...
                if ([changedPath rangeOfString:fileName].length != NSNotFound)
                {///if it is our news sys file...
                    news = [self.delegate reImplementNews];
                        ///ready!
                    waitingForFile = NO;
                }
                else
                {///if it is not our sys file... ours might be comming later....
                    ready = NO;
                }
            }
        }
        if (ready) {
            if (!waitingForFile) {
                [self uploadTheRightOne:news];
            }
        }
        else
        {
            [[WSQFileHelper sharedHelper] refresh];
        }
        
    }
}













- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



















@end
