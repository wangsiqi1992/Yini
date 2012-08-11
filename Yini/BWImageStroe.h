//
//  BWImageStroe.h
//  Yini
//
//  Created by siqi wang on 12-8-11.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWUser.h"
#import "BWNotificationCenter.h"



@interface BWImageStroe : NSObject
{
    NSMutableDictionary *storeDic;
    NSMutableDictionary *profileDic;
    
}


+(BWImageStroe*)sharedStore;
-(UIImage*)userProfileViewWithUserDisplayName:(NSString*)name;

@end
