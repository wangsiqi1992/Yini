//
//  BWNotificationCenter.m
//  Yini
//
//  Created by siqi wang on 12-8-9.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWNotificationCenter.h"

static NSString *logOutNotificationName = @"log out";
static NSString *clearCatchNotification = @"clear catch";
static NSString *uiProgressBarShowNotification = @"start loading data";
static NSString *userActivityNotificationName = @"user activities";
static NSString *userInfoNotificationName = @"user info";
static NSString *newsSysFileFolderNotificationName = @"yini system file";
static NSString *playingGroundAllOurFilesNotificationName = @"all file";
//static NSString *NotificationName = @"";
static BWNotificationCenter* sharedCenter;


@implementation BWNotificationCenter

+(NSString*)logOutNotificationName
{
    return logOutNotificationName;
}
+(NSString*)clearCatchNotificationName
{
    return clearCatchNotification;
}
+(NSString*)uiProgressBarNotificationName
{
    return uiProgressBarShowNotification;
}
+(NSString*)userActivityNotificationName
{
    return userActivityNotificationName;
}
+(NSString*)userInfoNotificationName
{
    return userInfoNotificationName;
}
+(NSString*)newsSysFileFolderNotificationName
{
    return newsSysFileFolderNotificationName;
}
+(NSString*)playingGroundAllOurFilesNotificationName
{
    return playingGroundAllOurFilesNotificationName;
}


+(BWNotificationCenter*)sharedCenter
{
    if (nil != sharedCenter) {
        return sharedCenter;
    }
    else
    {
        sharedCenter = [[self alloc] init];
        
    }
    return sharedCenter;
}

- (id)init
{
    self = [super init];
    if (self) {
        center = [NSNotificationCenter defaultCenter];
    }
    return self;
}

-(void)filesChangedWhenLoadingTheDelta:(NSArray *)changedFileNamePaths
{
    BOOL userInfo = FALSE, userActivity = FALSE, systemFile = FALSE;
    
    for (NSString* namePath in changedFileNamePaths) {
        if ([namePath rangeOfString:@"user info"].location != NSNotFound) {
            userInfo = TRUE;
        }
        if ([namePath rangeOfString:@"user activities"].location != NSNotFound) {
            userActivity = TRUE;
        }
        if ([namePath rangeOfString:@"yini system file"].location != NSNotFound) {
            systemFile = TRUE;
        }
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"changed", nil];
    
    if (!userInfo) {
        [center postNotificationName:userInfoNotificationName object:self userInfo:dic];
    }
    if (!userActivity) {
        [center postNotificationName:userActivityNotificationName object:self userInfo:dic];
    }
    if (!systemFile) {
        [center postNotificationName:newsSysFileFolderNotificationName object:self userInfo:dic];
        
    }
    
    NSDictionary *userInfoDic = [[NSDictionary alloc] initWithObjectsAndKeys:changedFileNamePaths, @"changed paths", [NSNumber numberWithBool:YES], @"changed", nil];
    [center postNotificationName:playingGroundAllOurFilesNotificationName object:self userInfo:userInfoDic];
    
    
}

-(void)filesNoChangeWhenLoadingTheDelta
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"changed", nil];
    [center postNotificationName:userInfoNotificationName object:self userInfo:dic];
    [center postNotificationName:userActivityNotificationName object:self userInfo:dic];
    [center postNotificationName:newsSysFileFolderNotificationName object:self userInfo:dic];
    [center postNotificationName:playingGroundAllOurFilesNotificationName object:self userInfo:dic];
    

}

-(void)loadedFile:(NSString *)namePath
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:namePath, @"name path", [NSNumber numberWithBool:YES], @"changed", nil];
    if ([namePath rangeOfString:@"user info"].location != NSNotFound) {
        [center postNotificationName:userInfoNotificationName object:self userInfo:dic];
    }
    if ([namePath rangeOfString:@"user activities"].location != NSNotFound) {
        [center postNotificationName:userActivityNotificationName object:self userInfo:dic];
    }
    if ([namePath rangeOfString:@"yini system file"].location != NSNotFound) {
        [center postNotificationName:newsSysFileFolderNotificationName object:self userInfo:dic];
    }
    
    [center postNotificationName:playingGroundAllOurFilesNotificationName object:self userInfo:dic];


}

-(void)logOut
{
    [center postNotificationName:logOutNotificationName object:self];
}

-(void)clearCatch
{
    [center postNotificationName:clearCatchNotification object:self];
    
}

-(void)loading:(BOOL)yes withProgress:(float)progress uiDescription:(NSString*)description
{
    NSDictionary* dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:yes], @"loading", progress, @"progress", description, @"status", nil];
    [center postNotificationName:uiProgressBarShowNotification object:self userInfo:dic];
}
































@end
