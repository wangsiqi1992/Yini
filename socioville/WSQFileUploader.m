//
//  WSQFileUploader.m
//  WSQFileHelperTestProject
//
//  Created by siqi wang on 12-7-10.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "WSQFileUploader.h"
static WSQFileUploader *sharedLoader;
static NSString *localTempDirec;
static NSString *dbMediaPath;
static NSString *dbSysPath;



@implementation WSQFileUploader
@synthesize delegate;


+ (WSQFileUploader *)sharedLoader
{
    if (nil != sharedLoader) {
        return sharedLoader;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedLoader = [[WSQFileUploader alloc] init];
    });
    
    return sharedLoader;
}

-(id)init
{
    self = [super init];
    
    if (self) {
        
        // Work your initialising magic here as you normally would
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selfDestory) name:[BWNotificationCenter logOutNotificationName] object:nil];

        
        manager = [NSFileManager defaultManager];
        helper = [WSQFileHelper sharedHelper];
        NSArray *a = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dp = [a objectAtIndex:0];
        localTempDirec = [dp stringByAppendingPathComponent:@"temp"];
        [manager createDirectoryAtPath:localTempDirec withIntermediateDirectories:YES attributes:nil error:nil];
        
        dbMediaPath = [@"/" stringByAppendingString:[BWLord myLord].dbPlayingGround];
        dbSysPath = [dbMediaPath stringByAppendingPathComponent:@"yini system file"];
        
        uploadingList = [[NSMutableDictionary alloc]init];
    }
    
    return self;
}

-(DBRestClient *)client
{
    if (!client) {
        client = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    }
    client.delegate = self;
    return client;
}

-(void)selfDestory
{
    dbMediaPath = nil;
}

-(void)setDBRootPath
{
    [self init];
}





#pragma mark - helper

-(NSString *)sysFileUploadingTempPathForNews:(NSString *)name
{
//    [manager createDirectoryAtPath:[localTempDirec stringByAppendingPathComponent:[[name stringByDeletingPathExtension] stringByAppendingPathExtension:@"plist"]] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *p = [localTempDirec stringByAppendingPathComponent:name];
    [manager createDirectoryAtPath:[[p stringByDeletingLastPathComponent] stringByDeletingPathExtension] withIntermediateDirectories:YES attributes:nil error:nil];
    return  p;
}

-(NSString*)mediaFileUploadingTempPathForNews:(NSString *)name
{
    [manager createDirectoryAtPath:[[localTempDirec stringByAppendingPathComponent:name] stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];

    return [localTempDirec stringByAppendingPathComponent:name];
}

#pragma mark - action

-(void)saveSysFileOfNews:(NSString*)name withOldName:(NSString*)oldName
{
    NSString *filename = [[name componentsSeparatedByString:@"/"] lastObject];
    NSString *metaPath = [helper sysMetadataPathForNews:oldName];
    DBMetadata *d = [NSKeyedUnarchiver unarchiveObjectWithFile:metaPath];
    NSString *uploadPath = [[dbSysPath stringByAppendingPathComponent:name] stringByReplacingOccurrencesOfString:filename withString:@""];
    
    if (![oldName isEqualToString:name])
    {
        [[self client] uploadFile:filename toPath:uploadPath withParentRev:nil fromPath:[self sysFileUploadingTempPathForNews:name]];
        if (oldName != nil) {
            [uploadingList setObject:d.path forKey:filename];
        }    }
    else
    {
        if (d) {
            [[self client] uploadFile:filename toPath:uploadPath withParentRev:d.rev fromPath:[self sysFileUploadingTempPathForNews:name]];
        }
        else
        {
            [[self client] uploadFile:filename toPath:uploadPath withParentRev:nil fromPath:[self sysFileUploadingTempPathForNews:name]];
        }
        
        
    }
    
}

-(void)saveMediaFileOfNews:(NSString*)name withOldName:(NSString *)oldName
{
    NSString *filename = [[name componentsSeparatedByString:@"/"] lastObject];
    NSString *metaPath = [helper mediaMetadataPathForNews:oldName];
    DBMetadata *d = [NSKeyedUnarchiver unarchiveObjectWithFile:metaPath];
    NSString *uploadPath = [[dbMediaPath stringByAppendingPathComponent:name] stringByReplacingOccurrencesOfString:filename withString:@""];
    
    if (![oldName isEqualToString:name])
    {
        [[self client] uploadFile:filename toPath:uploadPath withParentRev:nil fromPath:[self mediaFileUploadingTempPathForNews:name]];
        if (oldName != nil) {
            [uploadingList setObject:d.path forKey:filename];
        }
    }
    else
    {
        if (d) {
            [[self client] uploadFile:filename toPath:uploadPath withParentRev:d.rev fromPath:[self mediaFileUploadingTempPathForNews:name]];
        }
        else
        {
            [[self client] uploadFile:filename toPath:uploadPath withParentRev:nil fromPath:[self mediaFileUploadingTempPathForNews:name]];
        }
    }
}













#pragma mark - Dropbox call-back

-(void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath
{
    NSString *name = [[srcPath componentsSeparatedByString:@"/"] lastObject];
    if ([uploadingList objectForKey:name]) {
        [[self client]deletePath:[uploadingList objectForKey:name]];
        [uploadingList removeObjectForKey:name];
    }
    
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"finished save news", @"status", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"finished loading" object:self userInfo:userInfo];
    
    if ([self.delegate respondsToSelector:@selector(fileUploadFinished:)])
    {
        [self.delegate fileUploadFinished:YES];
    }
}

-(void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error
{
    NSLog(@"upload fail... please implement something else here... %@", [error localizedDescription]);
    
}

-(void)restClient:(DBRestClient *)restClient uploadProgress:(CGFloat)progress forFile:(NSString *)destPath from:(NSString *)srcPath
{
    NSLog(@"%f", progress);
    
}

































@end
