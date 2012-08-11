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
#import "WSQFileHelper.h"
#import "NewsLoader.h"





@interface BWImageStroe : NSObject
{
    NSMutableDictionary *storeDic;
    NSMutableDictionary *profileDic;
    NSMutableDictionary *thumbNailDic;
    
}


+(BWImageStroe*)sharedStore;
-(UIImage*)userProfileViewWithUserDisplayName:(NSString*)name;


/**
	get a image for thumbnail, search the media file first, then thumbnail folder, then load from db...
	@param DBPath db path!
	@returns image itself...
 */
-(UIImage*)thumbnailImageWithDBPath:(NSString*)namePath;



@end
