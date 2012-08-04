//
//  WSQFileHelper.h
//  WSQFileHelperTestProject
//
//  Created by siqi wang on 12-7-8.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>
#import "BWLord.h"

//#import "NewsObjectPhoto.h"
@protocol WSQFileHelperDelegate <NSObject>
@optional
-(void)loadedFile;
//-(void)changeInFileWithName:(DBMetadata *)metadata;
-(void)noChange;

-(void)loadedNewsList;

@end








@interface WSQFileHelper : NSObject<DBRestClientDelegate>
{
    DBRestClient *restClient;
    NSFileManager *manager;
    NSString *localCursor;
    NSMutableDictionary *newsNames;
//    BOOL loadingMetadata;
    
}

@property (nonatomic, strong) id delegate;


+(WSQFileHelper*)sharedHelper;
-(NSString*)newsListPath;
-(NSString*)localFileDirec;


-(void)refresh;
-(void)selfDestory;
-(void)setDBRootPath:(NSString*)dbP;

-(NSString*)directoryForNewsSysFile:(NSString*)name; //pass in any name(media namepath or plist name path...
-(NSString*)directoryForNewsMediaFile:(NSString *)name;
-(NSString*)sysMetadataPathForNews:(NSString*)name;
-(NSString*)mediaMetadataPathForNews:(NSString*)name;
-(NSString*)pathNameFromDBPath:(NSString *)path;//returned mixed cases... passed in with both case for root... can be used with db metadata lowercase string, or domestic uses...
-(NSString*)sysPathNameFromDBPath:(NSString *)path;
-(NSString*)sysFolderAnyFileDirectoryWithOriginalNamePath:(NSString*)oNamePath;//any name, but returned with original path extension...

-(NSString*)trimDBRoot:(NSString*)dbFullPath;

-(BOOL)sysFileExistForNamePath:(NSString *)np;//passed in with both media and sys namePath... and check if the file with plist extension exist
-(BOOL)fileExistInSysFolderWithNamePath:(NSString*)np;

-(NSString*)thumbnailPathForNewsNamePath:(NSString*)namePath;
-(void)loadThumbnailForDBPath:(NSString*)DBPath;
-(void)loadMediaFileForDBPath:(NSString*)dbPath;
-(void)loadSysFileForNamePath:(NSString*)nPath;//nPath contain yini system file...



@end
