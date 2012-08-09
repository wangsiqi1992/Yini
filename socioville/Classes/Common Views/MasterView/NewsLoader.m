//
//  NewsLoader.m
//  socioville
//
//  Created by Siqi Wang on 12-6-15.
//  Copyright (c) 2012年 Universitatea Babeș-Bolyai. All rights reserved.
//

#import "NewsLoader.h"

@implementation NewsLoader

//static NSString *sysFileDirec;


static NewsLoader* _sharedLoader = nil;
@synthesize delegate;

+(NewsLoader*)sharedLoader
{
    
    @synchronized([NewsLoader class])
    {
        if (!_sharedLoader) {
            [[self alloc] init];
            
        }
        return _sharedLoader;

        
    }
    return nil;
    
}

+(id)alloc
{
    @synchronized([NewsLoader class])
    {
        NSAssert(_sharedLoader == nil, @"Attempt to allocate second singleton");
        _sharedLoader = [super alloc];
        return _sharedLoader;
    }
    return nil;
    
}

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        //init here
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selfDestory) name:@"clear catch" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selfDestory) name:@"log out" object:nil];


        
        manager = [WSQFileHelper sharedHelper];
        uploader = [WSQFileUploader sharedLoader];
    }
    return self;

}

#pragma mark - public methods

-(NSArray*)list
{
    if (!list) {

        
        list = [[NSMutableArray alloc]init];
        NSDictionary* dic = [NSKeyedUnarchiver unarchiveObjectWithFile:[[self manager] newsListPath]];
        NSArray *namePaths = [dic keysSortedByValueUsingSelector:@selector(compare:)];
        namePaths = [[namePaths reverseObjectEnumerator] allObjects];
        for (int i = 0; i<50; i++) {
            if ([namePaths count] > i) {
                [self addToNewsListFromNamePath:[namePaths objectAtIndex:i]];
                
            }
            else
            {
                break;
            }
        }
    }
    return list;

}
-(WSQFileHelper*)manager
{
    if (!manager) {
        manager = [WSQFileHelper sharedHelper];
    }
    return manager;
}


-(void)refresh
{
    [self manager].delegate = self;
    [[self manager] refresh];
}

-(void)loadThumbnailWithDBPath:(NSString*)path
{
    [self manager].delegate = self;
    
    [[self manager] loadThumbnailForDBPath:path];
}

-(void)loadMediaFileForNews:(id)wsqNews
{
    //need to implement here!!
    if ([wsqNews isKindOfClass:[NewsObjectPhoto class]]) {
        NewsObjectPhoto *n = (NewsObjectPhoto*)wsqNews;
        [[self manager] loadMediaFileForDBPath:n.dbpath];
    }
}

-(void)saveNewsObject:(id)newsObject
{
    if ([newsObject isKindOfClass:[NewsObjectPhoto class]]) {
        NewsObjectPhoto *n = (NewsObjectPhoto*)newsObject;
        NSString* localP = [uploader sysFileUploadingTempPathForNews:[[self manager] sysPathNameFromDBPath:n.dbpath]];
        [NSKeyedArchiver archiveRootObject:n toFile:localP];
        NSString *name = [[self manager] sysPathNameFromDBPath:n.dbpath];

        [uploader saveSysFileOfNews:name withOldName:name];
        uploader.delegate = self;
        
    }
}

-(void)refreshForNews:(id)wsqNews
{
    if ([wsqNews isKindOfClass:[WSQNews class]]) {
        WSQNews *wsqNews = (WSQNews*)wsqNews;
        [[self manager] loadSysFileForNamePath:wsqNews.namePath];
        
    }
}

-(void)selfDestory
{
    list = nil;
    manager = nil;
    uploader = nil;
    
    
}



#pragma mark - self methods, helpers...

-(BOOL)addToNewsListFromNamePath:(NSString*)namePath
{
    NSString *name = [[[namePath componentsSeparatedByString:@"/"] lastObject] stringByDeletingPathExtension];
    for (WSQNews *n in [self list]) {
        if ([n.filename isEqualToString:name]) {
            [list removeObject:n];
            break;
        }
    }
    //check any special folder here...
    
//    WSQNews *n;
    if ([[self manager] sysFileExistForNamePath:namePath]) {
        WSQNews* n = (WSQNews*) [[WSQNews alloc]initWithSysFilePath:[[self manager] directoryForNewsSysFile:namePath]];
        switch (n.newsType) {
                case WSQPhoto:
            {
                NewsObjectPhoto* n = (NewsObjectPhoto*) [[NewsObjectPhoto alloc] initWithSysFilePath:[[self manager] directoryForNewsSysFile:namePath]];
                [list addObject:n];

                break;
            }
                
                case WSQVideo:
            {
                NSLog(@"this news is a video, said news loader");
                break;
            }
                case WSQArticle:
            {
                NSLog(@"this news is a article, said news loader");
                break;

            }
            default:
                break;
        }
    }
    else
    {
        WSQNews* n = [[WSQNews alloc]initWithMetadataPath:[[self manager] mediaMetadataPathForNews:namePath]];
        switch (n.newsType) {
            case WSQPhoto:
            {
                NewsObjectPhoto* n = (NewsObjectPhoto*) [[NewsObjectPhoto alloc] initWithMetadataPath:[[self manager] mediaMetadataPathForNews:namePath]];
                
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:[manager thumbnailPathForNewsNamePath:namePath]]) {
                    [[self manager] loadThumbnailForDBPath:n.dbpath];

                }
                [list addObject:n];


                break;
            }
            default:
                break;
        }
    }
    
    return TRUE;
}










#pragma mark - WSQ Manager Delegate methods


-(void)loadedNewsList
{
//    [self reloadList];
//    [[self delegate] newsLoaderDidLoadFile];
    list = nil;
    if ([[self delegate] respondsToSelector:@selector(newsLoaderDidLoadNewsList)])
    {
        [[self delegate] newsLoaderDidLoadNewsList];
    }
    else
    {
        NSLog(@"news loader found that its delegate is not responding to load news list selector");
    }
}

-(void)loadedFile
{
    list = nil;
    NSLog(@"news loader got a delegate massage saying loaded a file");
    if ([self.delegate respondsToSelector:@selector(newsLoaderDidLoadFile)]) {
        [[self delegate] newsLoaderDidLoadFile];
    }
}



-(void)noChange
{
    if ([self.delegate respondsToSelector:@selector(noChange)]) {
        [[self delegate] noChange];

    }
}


-(void)fileUploadFinished:(BOOL)isSucceed
{
    if (isSucceed) {
        if ([self.delegate respondsToSelector:@selector(saveNewsObjectSucceed)]) {
            [self.delegate saveNewsObjectSucceed];
        }

    }
    else
    {
        NSLog(@"NewsLoader: uploading file failed...");
    }
}




@end
