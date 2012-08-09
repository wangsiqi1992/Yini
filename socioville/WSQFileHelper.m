//
//  WSQFileHelper.m
//  WSQFileHelperTestProject
//
//  Created by siqi wang on 12-7-8.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//



#import "WSQFileHelper.h"

@interface WSQFileHelper ()

-(DBRestClient *)restClient;

/** Getter for localCursor.
 if cusor is nil, archieve it before return...
 @return    localCursor
 */
-(NSString*)cursor;

/** Save the localCursor to the file
 */
-(void)saveCursor;

/** Going to have a better approach than this one...
 call db to load metadata of the root, and process metadata one by one
 */
-(void)implementFromScratch;

/** Put a DB metadata into newsNames dictionary
 @param     metadata    db metadata got from dropbox
 \warning{
 checked newsNames before adding object!}
 @return    sucess or not
 */
-(BOOL)putIntoNewsNames:(DBMetadata *)metadata;

/** Check everything in the newsNames dic, if found the metadata contain the same lowercaseString, the name path is returned...
 @param     name        lowercaseString got from metadata
 @return    string      true path name as it is on the desktop computer
 */
-(NSString*)realNameFromLowerCase:(NSString*)name;

/** Delete: sys file, media file, from newsNames, thumbnail, media metadata!
 @param     name        name path for the news you want to delete, as it is used for newsNames key
 */
-(void)deleteNewsMediaFileWithName:(NSString*)name;

/** Tries to delete: sys file, or any file located inside sys file folder, and sys metadata file...
 @param     name        sys name path, extension friendly
 */
-(void)deleteNewsSysFileWithName:(NSString*)name;

/** Getter for private variable, unarchieve from file if nil, and init it if nil again
 */
-(NSMutableDictionary*)newsNames;

/** save newsNames once it is modified, archieve it to file
 @warning       should be called before announcing new newsList
 */
-(void)saveNewsNames;

/** called at init, make local directories
 */
-(void)makeDirectories;


@end




@implementation WSQFileHelper
static WSQFileHelper* _sharedHelper = nil;
static NSString *newsSysFilePath;
static NSString *cursorPath;
static NSString *sysFileDirec;
static NSArray *photoExtensions = nil;
static NSArray *videoExtensions = nil;
static NSArray *textExtensions = nil;
static NSString *thumbnailSavePath = nil;
static NSString *sysFileMetadataDirec = nil;
static NSString *mediaFileMetadataDirec = nil;
static NSString *mediaFileDirec = nil;
static NSString *yiniSystemFileDirec = nil;
static NSString *dbRootPath = nil;

@synthesize delegate;


#pragma mark - initializing methods
+(WSQFileHelper*)sharedHelper
{
    @synchronized([WSQFileHelper class])
    {
        if (!_sharedHelper) {
            _sharedHelper = [[self alloc] init];
            
        }
        return _sharedHelper;
        
        
    }
    return nil;

}

+(id)alloc
{
    @synchronized([WSQFileHelper class])
    {
        NSAssert(_sharedHelper == nil, @"Attempt to allocate second singleton");
        _sharedHelper = [super alloc];
        return _sharedHelper;
    }
    return nil;
    
}

-(id)init
{
    self = [super init];
    if (self != nil) {
        //init here
        localCursor = nil;
        newsNames = nil;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selfDestory) name:@"clear catch" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selfDestory) name:@"log out" object:nil];
        
        NSArray *a = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dp = [a objectAtIndex:0];
        newsSysFilePath = [dp stringByAppendingPathComponent:@"News/systemFile"];//changed here...
        
        cursorPath = [dp stringByAppendingPathComponent:@"News/systemFile/cursor.data"];
        sysFileDirec = [dp stringByAppendingPathComponent:@"News/systemFile"];
//        newsNames = [[NSMutableArray alloc]init];
        thumbnailSavePath = [dp stringByAppendingPathComponent:@"News/thumbnail"];
        
        sysFileMetadataDirec = [dp stringByAppendingPathComponent:@"News/systemFile/metadata"];
        
        mediaFileMetadataDirec = [dp stringByAppendingPathComponent:@"News/metadata"];
        
        mediaFileDirec = [dp stringByAppendingPathComponent:@"News"];
        
        yiniSystemFileDirec = [dp stringByAppendingPathComponent:@"News/systemFile/yini system file"];
        
        [self setDBRootPath:[BWLord myLord].dbPlayingGround];
        
        manager = [NSFileManager defaultManager];

        [self makeDirectories];
        if (photoExtensions == nil) {
            //
            photoExtensions = [NSArray arrayWithObjects:@"jpg", @"png", nil];
        }
        if (videoExtensions == nil) {
            //
            videoExtensions = [NSArray arrayWithObjects:@"mp4", nil];
        }
        if (textExtensions == nil) {
            //
            textExtensions = [NSArray arrayWithObjects:@"txt", nil];
        }
        
        
    }
    return self;
    
}

-(DBRestClient *)restClient
{
    if (!restClient) {
        restClient =
        [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    }
    restClient.delegate = self;
    return restClient;
}





#pragma mark - helper methods


-(NSString*)newsListPath
{
    return [sysFileDirec stringByAppendingPathComponent:@"newsList.plist"];
}

-(NSString*)localFileDirec
{
    return mediaFileDirec;
}

-(NSString*)directoryForNewsSysFile:(NSString*)name
{
    if ([[[name componentsSeparatedByString:@"/"] objectAtIndex:0] isEqualToString:@"yini system file"])
    {
        name = [name stringByReplacingOccurrencesOfString:@"yini system file/" withString:@""];
    }
    
    NSString *savePath = [yiniSystemFileDirec stringByAppendingPathComponent:name];
    savePath = [[savePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"plist"];

    return savePath;
    
    
}

-(NSString*)directoryForNewsMediaFile:(NSString *)name
{
    return [mediaFileDirec stringByAppendingPathComponent:name];
    
}

-(NSString*)mediaMetadataPathForNews:(NSString *)name
{
    return [mediaFileMetadataDirec stringByAppendingPathComponent:[[name stringByDeletingPathExtension] stringByAppendingPathExtension:@"plist"]];
}

-(NSString*)sysMetadataPathForNews:(NSString *)name
{
    if (![[[name componentsSeparatedByString:@"/"] objectAtIndex:0] isEqualToString:@"yini system file"]) {
        name = [@"yini system file" stringByAppendingPathComponent:name];
    }
    return [mediaFileMetadataDirec stringByAppendingPathComponent:[[name stringByDeletingPathExtension]stringByAppendingPathExtension:@"plist"]];
}

-(NSString*)pathNameFromDBPath:(NSString *)path
{
    NSRange rootRange = [path rangeOfString:dbRootPath];
    
    if (rootRange.location == NSNotFound) {
        rootRange = [path rangeOfString:[dbRootPath lowercaseString]];
    }
    
    if (rootRange.location != NSNotFound) {
        NSString *pathName = [path substringFromIndex:rootRange.location + rootRange.length + 1];
        return pathName;
    }
    else
    {
        return nil;
    }

}

-(NSString*)sysPathNameFromDBPath:(NSString *)path
{
    return [[[self pathNameFromDBPath:path] stringByDeletingPathExtension] stringByAppendingPathExtension:@"plist"];
}

-(NSString*)thumbnailPathForNewsNamePath:(NSString *)namePath
{
    return [thumbnailSavePath stringByAppendingPathComponent:namePath];
}

-(BOOL)sysFileExistForNamePath:(NSString *)np
{
    if ([[[np componentsSeparatedByString:@"/"] objectAtIndex:0] isEqualToString:@"yini system file"]) {
        np = [np stringByReplacingOccurrencesOfString:@"yini system file/" withString:@""];
    }
    
    np = [[np stringByDeletingPathExtension] stringByAppendingPathExtension:@"plist"];
    
    NSString *path = [self directoryForNewsSysFile:np];
    return [manager fileExistsAtPath:path];
    
}

-(NSString*)sysFolderAnyFileDirectoryWithOriginalNamePath:(NSString *)oNamePath
{
    if ([[[oNamePath componentsSeparatedByString:@"/"] objectAtIndex:0] isEqualToString:@"yini system file"])
    {
        oNamePath = [oNamePath stringByReplacingOccurrencesOfString:@"yini system file/" withString:@""];
    }
    
    NSString *savePath = [yiniSystemFileDirec stringByAppendingPathComponent:oNamePath];
    
    return savePath;
}

-(BOOL)fileExistInSysFolderWithNamePath:(NSString *)np
{
    if ([[[np componentsSeparatedByString:@"/"] objectAtIndex:0] isEqualToString:@"yini system file"]) {
        np = [np stringByReplacingOccurrencesOfString:@"yini system file/" withString:@""];
    }
    
//    np = [[np stringByDeletingPathExtension] stringByAppendingPathExtension:@"plist"];
    
    NSString *path = [self sysFolderAnyFileDirectoryWithOriginalNamePath:np];
    return [manager fileExistsAtPath:path];
}



#pragma mark - actions, public

-(void)refresh
{
    [[self restClient] loadDelta:[self cursor]];



    
}

-(void)selfDestory
{
    localCursor = nil;
    newsNames = nil;
    
}

-(void)setDBRootPath:(NSString *)dbP
{
    dbRootPath = dbP;
}

-(void)loadThumbnailForDBPath:(NSString *)DBPath
{
    NSRange r = [DBPath rangeOfString:dbRootPath];
    NSString *namePath = [DBPath substringFromIndex:r.location+r.length+1];
    NSString *tPath = [self thumbnailPathForNewsNamePath:namePath];
    [manager createDirectoryAtPath:tPath withIntermediateDirectories:YES attributes:nil error:nil];
    [[self restClient] loadThumbnail:DBPath ofSize:@"s" intoPath:tPath];
    
}

-(void)loadMediaFileForDBPath:(NSString *)dbPath
{
    NSString *localPath = [self directoryForNewsMediaFile:[self pathNameFromDBPath:dbPath]];
    if (![manager fileExistsAtPath:localCursor]) {
        [manager createDirectoryAtPath:[localPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [[self restClient] loadFile:dbPath intoPath:localPath];
    
}

-(void)loadSysFileForNamePath:(NSString *)nPath
{
    NSString *localPath = [self directoryForNewsSysFile:nPath];
    [[self restClient] loadFile:[self dbPathFromNamePath:nPath] intoPath:localPath];
}







#pragma mark - DB call-backs

-(void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata
{
    if (metadata.isDirectory) {
        //        NSMutableArray *list;
        NSLog(@"Folder '%@' contains:", metadata.path);
        
        //        list = [[NSMutableArray alloc]init];
        
        for (DBMetadata *data in metadata.contents)
        {
            NSString *pathName = [self pathNameFromDBPath:data.path];
            
            if ([data.path rangeOfString:@"yini system file"].location != NSNotFound)
            {
                //if sys folder
                if (data.isDirectory) {
                    [[self restClient] loadMetadata:data.path];
                }
                else
                {
                    [[self restClient] loadFile:data.path intoPath:[self sysFolderAnyFileDirectoryWithOriginalNamePath:pathName]];
                    [manager createDirectoryAtPath:[[self sysFolderAnyFileDirectoryWithOriginalNamePath:pathName] stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
                    
                    [manager createDirectoryAtPath:[[[self sysMetadataPathForNews:pathName] stringByDeletingLastPathComponent] stringByDeletingPathExtension] withIntermediateDirectories:YES attributes:nil error:nil];
                [manager createFileAtPath:[self sysMetadataPathForNews:pathName] contents:nil attributes:nil];
                    [NSKeyedArchiver archiveRootObject:data toFile:[self sysMetadataPathForNews:[self pathNameFromDBPath:data.path]]];

                }
            }
            else
            {
                //if media folder
                if (data.isDirectory) {
                    [[self restClient] loadMetadata:data.path];
                }
                else
                {
                    [self putIntoNewsNames:data];
                }
            }
        }
     
            
            //write news names into a plist in systemFile!
            [self saveNewsNames];//change on the list reported once only
        if ([self.delegate respondsToSelector:@selector(loadedNewsList)]) {
            
            [[self delegate] loadedNewsList];
        }
    }

}


-(void)restClient:(DBRestClient *)client loadedDeltaEntries:(NSArray *)entries reset:(BOOL)shouldReset cursor:(NSString *)cursor hasMore:(BOOL)hasMore
{
    localCursor = cursor;
    NSLog(@"cursor recieved! %@", cursor);
    [self saveCursor];

    if (shouldReset) {
        [self implementFromScratch];
    }
    else {
        if (hasMore) {
            [[self restClient] loadDelta:cursor];
        }
        BOOL changeMadeInActivityFolder = NO;

        if ([entries count] == 0) {
            
            if ([self.delegate respondsToSelector:@selector(noChange)]) {
                changeMadeInActivityFolder = NO;
                
                [[self delegate] noChange];
            }             return;
        }
        else {
            BOOL changeMade = NO;
            for (DBDeltaEntry *d in entries)
            {
                NSRange r = [d.lowercasePath rangeOfString:[dbRootPath lowercaseString]];
                NSArray *pathCompounent = [d.lowercasePath componentsSeparatedByString:@"/"];
                
                
                
                //if relevent to our program?!
                if (r.location == NSNotFound) {
                    //this change not made in our folder
                    //break;
                }
                else
                {
                    changeMade = TRUE;
                    //change made in our folder
                    //check path
                    //reload news or system file?!

                    if (![pathCompounent containsObject:@"yini system file"])
                    {
                        //if change in media folder
                        
                        if (d.metadata) {
                            
                            
                            [self putIntoNewsNames:d.metadata];//should it just put names into the newsnames list?!?!!!!
                            //if new news

                        }
                        else {
                            //if delete news
                            NSString *name = [self pathNameFromDBPath:d.lowercasePath];
                            //may not work for album, i.e. folder of news, only name is passed not directory after root folder
                            name = [self realNameFromLowerCase:name];
                            [self deleteNewsMediaFileWithName:name];
                        }
                        
                        [[self delegate] loadedFile];
                        [self saveNewsNames];
                        
                    }
                    else 
                    {
                        //if change made in system file folder



                        if (d.metadata.isDirectory)
                        {
                            //break;
                        }
                        else
                        {
                            if (d.metadata)
                            {
                                NSString *localPath = [[NSString alloc]init];
                                NSString *pathName = [self pathNameFromDBPath:d.metadata.path];
                                if ([pathName rangeOfString:@"user activities"].location != NSNotFound) {
                                    changeMadeInActivityFolder = YES;
                                }
                                localPath = [self sysFolderAnyFileDirectoryWithOriginalNamePath:pathName];
                                
                                if (![manager fileExistsAtPath:localPath])
                                {
                                    [manager createDirectoryAtPath:[[localPath stringByDeletingLastPathComponent] stringByDeletingPathExtension] withIntermediateDirectories:YES attributes:nil error:nil];
                                     }
                                     [[self restClient] loadFile:d.metadata.path intoPath:localPath];
                                     
                                     
                                     NSString *sysMP = [self sysMetadataPathForNews:pathName];
                                     [manager createDirectoryAtPath:[[self sysMetadataPathForNews:[pathName stringByDeletingLastPathComponent] ] stringByDeletingPathExtension]withIntermediateDirectories:YES attributes:nil error:nil];
                                     [manager createFileAtPath:sysMP contents:nil attributes:nil];
                                     [NSKeyedArchiver archiveRootObject:d.metadata toFile:sysMP];
                                     
                                     }
                                     
                                     else
                                     {
                                         NSString *pathName = [[NSString alloc]init];
                                         pathName = [self pathNameFromDBPath:[self realNameFromLowerCase:d.lowercasePath]];
                                         NSString *name = [self realNameFromLowerCase:pathName];
                                         [self deleteNewsSysFileWithName:name];
                                     }
                        }
                        
                        
                        
                        
                        
                    }
                    
                    //there is some change!!!
                }
            }
            
            if (changeMade) {
                if ([self.delegate respondsToSelector:@selector(loadedNewsList)]) {
                    
                    [[self delegate] loadedNewsList];
                }            }
            else
            {
                if ([self.delegate respondsToSelector:@selector(noChange)]) {
                    [[self delegate] noChange];
                }             }
        }
        if (!changeMadeInActivityFolder) {
            NSNotification *note = [NSNotification notificationWithName:@"user activities no change" object:self];
            [[NSNotificationCenter defaultCenter] postNotification:note];
        }
    }
    
    //[[self delegate] changeInFileWithName:];
}

-(void)restClient:(DBRestClient *)client loadedFile:(NSString *)destPath
{
    [[self delegate] loadedFile];//change reported on every file
    NSLog(@"loaded files to %@", destPath);
    if ([destPath rangeOfString:@"user info"].location != NSNotFound)
    {
        NSNotification *note = [NSNotification notificationWithName:@"user info changed" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }
    if ([destPath rangeOfString:@"user activities"].location != NSNotFound)
    {
        NSString *userName = [[[destPath componentsSeparatedByString:@"/"] lastObject] stringByDeletingPathExtension];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:userName forKey:@"userName"];
        NSNotification *note = [NSNotification notificationWithName:@"user activities changed" object:self userInfo:userInfo];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }
}


-(void)restClient:(DBRestClient *)client loadDeltaFailedWithError:(NSError *)error
{
    NSLog(@"WSQ file manager loading Delta from Dropbox failed with error: %@", [error localizedDescription]);
    
}

-(void)restClient:(DBRestClient *)client metadataUnchangedAtPath:(NSString *)path
{
    NSLog(@"delta reponse! no change, cheers~!");
}

-(void)restClient:(DBRestClient *)client loadedThumbnail:(NSString *)destPath
{
    [[self delegate] loadedFile];
}










#pragma mark - private methods


-(NSString*)cursor
{
    if (!localCursor) {
        //unarchive from .data
        localCursor = [NSKeyedUnarchiver unarchiveObjectWithFile:cursorPath];
    }
    
    return localCursor;
}

/** Save the localCursor to the file
 */
-(void)saveCursor
{
    if (![NSKeyedArchiver archiveRootObject:localCursor toFile:cursorPath]) {
        NSLog(@"error archive cursor to local file");
    }
}

/** Going to have a better approach than this one...
 call db to load metadata of the root, and process metadata one by one
 */
-(void)implementFromScratch
{
    [self makeDirectories];
    [[self restClient] loadMetadata:[@"/" stringByAppendingString:dbRootPath]];

}

/** Put a DB metadata into newsNames dictionary
 @param     metadata    db metadata got from dropbox
 \warning{
            checked newsNames before adding object!}
 @return    sucess or not
 */
-(BOOL)putIntoNewsNames:(DBMetadata *)metadata
{
    
    NSString *pathName = [self pathNameFromDBPath:metadata.path];
    
//    NSString *savePath = [self directoryForNewsSysFile:name];
    if (![[self newsNames] objectForKey:pathName]) {
        [[self newsNames] setObject:metadata.lastModifiedDate forKey:pathName];
    }
    
    [self saveNewsNames];
    
    [manager createDirectoryAtPath:[[self mediaMetadataPathForNews:pathName] stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    [NSKeyedArchiver archiveRootObject:metadata toFile:[self mediaMetadataPathForNews:pathName]];
    
    return TRUE;
}

-(NSString*)realNameFromLowerCase:(NSString*)name
{
    NSEnumerator *enumerator = [[self newsNames] keyEnumerator];
    NSString *key;
    
    while ((key = [enumerator nextObject])) {
        /* code that uses the returned key */
        if ([[key lowercaseString] isEqualToString:name]) {
            return key;
        }
    }
    return name;
}

-(void)deleteNewsMediaFileWithName:(NSString*)name
{
    if (!name) {
        return;
    }
    

    
    if ([[self newsNames] objectForKey:name]) {
        [[self newsNames] removeObjectForKey:name];
        [self saveNewsNames];
    }
    NSError *e;
    
    if ([manager fileExistsAtPath:[self directoryForNewsMediaFile:name]]) {
        [manager removeItemAtPath:[self directoryForNewsMediaFile:name] error:&e];
    }

    if ([manager fileExistsAtPath:[self directoryForNewsSysFile:name]]) {
        [manager removeItemAtPath:[self directoryForNewsSysFile:name] error:&e];
        
    }
    
    if ([manager fileExistsAtPath:[self thumbnailPathForNewsNamePath:name]]) {
        [manager removeItemAtPath:[self thumbnailPathForNewsNamePath:name] error:&e];
        
    }

    
    if (![manager removeItemAtPath:[self mediaMetadataPathForNews:name] error:&e]) {
        NSLog(@"fale to delete metadata for news media file:%@, when loading delta", name);
    }
    
}

-(void)deleteNewsSysFileWithName:(NSString*)name
{
    if (!name) {
        return;
    }

    NSError *e;
    
    if ([self fileExistInSysFolderWithNamePath:name]) {
        [manager removeItemAtPath:[self sysFolderAnyFileDirectoryWithOriginalNamePath:name] error:&e];
        
    }
    
    if ([self sysFileExistForNamePath:name]) {
        [manager removeItemAtPath:[self directoryForNewsSysFile:name] error:nil];
    }
    
    if (![manager removeItemAtPath:[self sysMetadataPathForNews:name] error:&e]) {
        NSLog(@"fail to delete metadata for news sys file:%@, when loading delta", name);
    }
}

-(NSMutableDictionary*)newsNames
{
    
    if (!newsNames) {
        newsNames = [NSKeyedUnarchiver unarchiveObjectWithFile:[self newsListPath]];
    }
    if (!newsNames) {
        newsNames = [[NSMutableDictionary alloc]init];
    }
    return newsNames;
}

-(void)saveNewsNames
{
    if (![NSKeyedArchiver archiveRootObject:newsNames toFile:[sysFileDirec stringByAppendingPathComponent:@"newsList.plist"]]) {
        NSLog(@"error write to newsList.plist");
        
    }
}

-(void)makeDirectories
{
//    [manager createDirectoryAtPath:newsSysFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    [manager createDirectoryAtPath:sysFileMetadataDirec withIntermediateDirectories:YES attributes:nil error:nil];
    [manager createDirectoryAtPath:mediaFileMetadataDirec withIntermediateDirectories:YES attributes:nil error:nil];
    [manager createDirectoryAtPath:yiniSystemFileDirec withIntermediateDirectories:YES attributes:nil error:nil];
    [manager createDirectoryAtPath:thumbnailSavePath withIntermediateDirectories:YES attributes:nil error:nil];
}

-(NSString*)dbPathFromNamePath:(NSString*)nPath
{
    return [dbRootPath stringByAppendingPathComponent:nPath];
}


@end



















