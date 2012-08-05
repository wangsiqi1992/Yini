//
//  BWUser.h
//  Yini
//
//  Created by siqi wang on 12-7-19.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DropboxSDK/DropboxSDK.h"
#import "BWAppDelegate.h"

@interface BWUser : NSObject<NSCoding>
{
    DBRestClient *client;
}


@property (nonatomic, strong) NSString *displayName;

-(id)initWithName:(NSString*)name;
-(NSString*)profilePicPathForName:(NSString*)displayUserName;

-(NSString*)profilePicLocalPath;




@end
