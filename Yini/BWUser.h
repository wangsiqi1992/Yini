//
//  BWUser.h
//  Yini
//
//  Created by siqi wang on 12-7-19.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DropboxSDK/DropboxSDK.h"

@interface BWUser : NSObject<NSCoding>


@property (nonatomic, strong) NSString *displayName;

-(id)initWithName:(NSString*)name;
-(NSString*)profilePicPathForName:(NSString*)displayUserName;

-(NSString*)profilePicLocalPath;




@end
