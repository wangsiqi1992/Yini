//
//  BWLord.h
//  Yini
//
//  Created by siqi wang on 12-7-20.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWUser.h"
#import <DropboxSDK/DropboxSDK.h>



@interface BWLord : BWUser<DBRestClientDelegate>
{
    DBRestClient *client;
}

+(BWLord*)myLord;
@property (nonatomic, strong) id delegate;
-(BWUser*)myLordAsAUser;




@end



@protocol BWLordInfoDelegate <NSObject>

-(void)myLordInfoLoaded;
-(void)myLordProfilePicLoaded;
@end