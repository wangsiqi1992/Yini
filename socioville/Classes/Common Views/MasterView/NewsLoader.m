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
        NSDictionary* dic = [NSKeyedUnarchiver unarchiveObjectWithFile:[manager newsListPath]];
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


-(void)refresh
{
    manager.delegate = self;
    [manager refresh];
}

-(void)loadThumbnailWithDBPath:(NSString*)path
{
    manager.delegate = self;
    
    [manager loadThumbnailForDBPath:path];
}

-(void)loadMediaFileForNews:(id)wsqNews
{
    //need to implement here!!
    if ([wsqNews isKindOfClass:[NewsObjectPhoto class]]) {
        NewsObjectPhoto *n = (NewsObjectPhoto*)wsqNews;
        [manager loadMediaFileForDBPath:n.dbpath];
    }
}

-(void)saveNewsObject:(id)newsObject
{
    if ([newsObject isKindOfClass:[NewsObjectPhoto class]]) {
        NewsObjectPhoto *n = (NewsObjectPhoto*)newsObject;
        NSString* localP = [uploader sysFileUploadingTempPathForNews:[manager sysPathNameFromDBPath:n.dbpath]];
        [NSKeyedArchiver archiveRootObject:n toFile:localP];
        NSString *name = [manager sysPathNameFromDBPath:n.dbpath];

        [uploader saveSysFileOfNews:name withOldName:name];
        uploader.delegate = self;
        
    }
}

-(void)refreshForNews:(id)wsqNews
{
    if ([wsqNews isKindOfClass:[WSQNews class]]) {
        WSQNews *wsqNews = (WSQNews*)wsqNews;
        [manager loadSysFileForNamePath:wsqNews.namePath];
        
    }
}

-(void)selfDestory
{
    list = nil;
    
    
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
    if ([manager sysFileExistForNamePath:namePath]) {
        WSQNews* n = (WSQNews*) [[WSQNews alloc]initWithSysFilePath:[manager directoryForNewsSysFile:namePath]];
        switch (n.newsType) {
                case WSQPhoto:
            {
                NewsObjectPhoto* n = (NewsObjectPhoto*) [[NewsObjectPhoto alloc] initWithSysFilePath:[manager directoryForNewsSysFile:namePath]];
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
        WSQNews* n = [[WSQNews alloc]initWithMetadataPath:[manager mediaMetadataPathForNews:namePath]];
        switch (n.newsType) {
            case WSQPhoto:
            {
                NewsObjectPhoto* n = (NewsObjectPhoto*) [[NewsObjectPhoto alloc] initWithMetadataPath:[manager mediaMetadataPathForNews:namePath]];
                
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:[manager thumbnailPathForNewsNamePath:namePath]]) {
                    [manager loadThumbnailForDBPath:n.dbpath];

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
    [[self delegate] newsLoaderDidLoadFile];
}



-(void)noChange
{
    [[self delegate] noChange];
}


-(void)fileUploadFinished:(BOOL)isSucceed
{
    if (isSucceed) {
        [self.delegate saveNewsObjectSucceed];

    }
    else
    {
        NSLog(@"NewsLoader: uploading file failed...");
    }
}




@end
