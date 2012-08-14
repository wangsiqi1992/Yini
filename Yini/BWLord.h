//
//  BWLord.h
//  Yini
//
//  Created by siqi wang on 12-7-20.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>
#import "BWUser.h"
#import "BWNotificationCenter.h"

@interface BWLord : BWUser<DBRestClientDelegate>
{
}

+(BWLord*)myLord;
@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) NSString* dbPlayingGround;
-(BWUser*)myLordAsAUser;

-(NSString*)profilePicLocalPath;

-(NSString*)myLordInfoSavePath;

-(void)selfDestory;
@end























@protocol BWLordInfoDelegate <NSObject>

-(void)myLordInfoLoaded;
-(void)myLordProfilePicLoaded;

@end