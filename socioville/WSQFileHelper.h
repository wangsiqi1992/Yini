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


/**
 @param 
 @return
 
 */
@protocol WSQFileHelperDelegate <NSObject>
-(void)loadedFile;

@optional
//-(void)changeInFileWithName:(DBMetadata *)metadata;
-(void)noChange;

-(void)loadedNewsList;


@end







@interface WSQFileHelper : NSObject<DBRestClientDelegate>
{
    
    DBRestClient *restClient;///< DBclient, [self restClient] is called to get this variable
    NSFileManager *manager;
    NSString *localCursor;///<set and save to a file automatically
    NSMutableDictionary *newsNames;///<used to load news and archieved to file auto.
//    BOOL loadingMetadata;
    
}


@property (nonatomic, strong) id delegate;

+(WSQFileHelper*)sharedHelper;
/**
 @return local path to the news list I saved...
 
 */
-(NSString*)newsListPath;

/**
 @return @"<documentsDirectory>/News"
 */
-(NSString*)localFileDirec;



/**
 Set local variables to nil.
 Set loacalCursor, newsNames to nil.
 
 */
-(void)selfDestory;

/**
 Need to be set at Init, or before use...
 @param     dbP PlayingGround set at initiallization 
 */
-(void)setDBRootPath:(NSString*)dbP;


#pragma mark - Helper function
/**
 @param     dbP     namePath, can be both media or sys namePath
 @return    string  full local directory to the news sys file
 
 */
-(NSString*)directoryForNewsSysFile:(NSString*)name;

/** Get the local directory for name
 @param     name    media name path
 @return    string  "<documentDirectory>/News/name"
 
 */
-(NSString*)directoryForNewsMediaFile:(NSString *)name;

/** Get the original db MEDIA metadata path, used for init a WSQNews.
 @param     name    can be both media or sys name path
 @return    string  full local path, ending plist
 */
-(NSString*)sysMetadataPathForNews:(NSString*)name;

/** Get the Original db SYS metadata path, userd for uploading rev
 @param     name    Can be both plist file("yini system file/....plist") or media file("...jpg")
 @return    string  full local path, ending plist("<DP>/News/metadata/yini system file")
 */
-(NSString*)mediaMetadataPathForNews:(NSString*)name;

/** assume the structure is not changed, convert db path to local path
 @param     path    dbPath, full path with root
 \warning          {returned mixed cases, may cause problem when using with dblowercasePath}
 @return    string  mixed case, no checking newsList is performed...
 @see               realNameFromLowerCase: to convert
 */
-(NSString*)pathNameFromDBPath:(NSString *)path;

/** Use pathNameFromDBPath: to convert and change extension to plist
 @param     path    db any file path
 @return    string  trimed the dbRoot, and changed extension to plist
 @see   
                    -sysFolderAnyFileDirectoryWithOriginalNamePath:
                    -pathNameFromDBPath:
 */
-(NSString*)sysPathNameFromDBPath:(NSString *)path;

/** Used when file other than plist is saved inside the sys folder
 @param     oNamePath   can be both sys or media name path
 \warning  {be careful on extensions}
 @return    string      "<DP>/News/systemFile/yini system file/....<extesion>" original extension
 */
-(NSString*)sysFolderAnyFileDirectoryWithOriginalNamePath:(NSString*)oNamePath;


/** Used when checking if we have got the news sys file locally.
    No DB check is performed, no media check is performed. 
 \warning          {check file within sys folder and with extension plist only}
 @param     np      can be both sys or media 
 @return    bool    yes or no
 */
-(BOOL)sysFileExistForNamePath:(NSString *)np;

/** Used when checking if a file in sys folder exist
 @see               
                    -sysFileExistForNamePath:
                    -sysFolderAnyFileDirectoryWithOriginalNamePath:
 @param     np      any extension friendly
 @return    bool    yes or no
 */
-(BOOL)fileExistInSysFolderWithNamePath:(NSString*)np;

/** Get thumbnail path, no checking for exist or not...
 @param     namePath    
 @return    string
 */
-(NSString*)thumbnailPathForNewsNamePath:(NSString*)namePath;


#pragma mark - Action

/**
 Ask Dropbox SDK to loade Delta.
 Will announce notifications.
 
 
 */
-(void)refresh;

/** Load a thumbnail for photo at DBPath
 @param     DBPath      passed in a db path found in the metadata
 */
-(void)loadThumbnailForDBPath:(NSString*)DBPath;

/** Load media file, 
 @param     dbPath      path found in the metadata
 */
-(void)loadMediaFileForDBPath:(NSString*)dbPath;

/** Load the sys file for a news
 \warnning              {nPath has to have "yini system file"!!!}
 @see                   
 @param     nPath       path contain "yini system file",
 */
-(void)loadSysFileForNamePath:(NSString*)nPath;//nPath contain yini system file...

































@end
