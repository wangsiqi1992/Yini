//
//  BWActivityLoader.h
//  Yini
//
//  Created by siqi wang on 12-8-7.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWActivityNews.h"
#import "BWActivityComent.h"
#import "WSQFileHelper.h"

@interface BWActivityLoader : NSObject
{
    NSArray *rawActivities;
}
@property (nonatomic, strong) NSString *userName;


-(id)initWithUserName:(NSString*)name;
-(NSArray*)activitiesPreparedForProfilePage;


@end
