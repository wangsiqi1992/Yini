//
//  NewsLoader.h
//  socioville
//
//  Created by Siqi Wang on 12-6-15.
//  Copyright (c) 2012年 Universitatea Babeș-Bolyai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>
#import "NewsObjectPhoto.h"
#import "WSQFileHelper.h"
#import "WSQFileUploader.h"
#import "BWNotificationCenter.h"

@protocol NewsLoaderDelegate <NSObject>
@optional
-(void)newsLoaderDidLoadNewsList;
-(void)newsLoaderDidLoadFile;
-(void)noChange;
-(void)saveNewsObjectSucceed;

@end


@interface NewsLoader: NSObject <WSQFileHelperDelegate, WSQFileUploaderDelegate>
{
    id<NewsLoaderDelegate> delegate;
    
    NSMutableArray *list;
        
    WSQFileHelper *manager;
    WSQFileUploader *uploader;
    
    DBRestClient *restClient;
    
//    BOOL loadingMetadata;
}

@property (nonatomic, strong) id delegate;


+(NewsLoader*)sharedLoader;

-(NSArray*)list;

-(void)refresh;

//-(void)getAllNews;

-(void)loadThumbnailWithDBPath:(NSString*)path;

//-(void)loadSystemFile;

-(void)loadMediaFileForNews:(id)wsqNews;

//-(void)saveNewsObject:(id)newsObject;

-(void)refreshForNews:(id)wsqNews;

-(void)selfDestory;

@end
