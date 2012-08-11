//
//  BWImageStroe.m
//  Yini
//
//  Created by siqi wang on 12-8-11.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWImageStroe.h"
static BWImageStroe *sharedStrore;
@implementation BWImageStroe

+(BWImageStroe*)sharedStore
{
    if (nil == sharedStrore) {
        sharedStrore = [[BWImageStroe alloc] init];
    }
    return sharedStrore;
}

- (id)init
{
    self = [super init];
    if (self) {
        storeDic = [[NSMutableDictionary alloc]init];
        profileDic = [[NSMutableDictionary alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChanged:) name:[BWNotificationCenter userInfoNotificationName] object:nil];
    }
    return self;
}

-(UIImage*)userProfileViewWithUserDisplayName:(NSString *)name
{
    UIImage *profileP;
    if ([profileDic objectForKey:name]) {
        profileP = [profileDic objectForKey:name];
    }
    else
    {
        profileP = [UIImage imageWithContentsOfFile:[[[BWUser alloc] initWithName:name] profilePicLocalPath]];
        if (!profileP)
        {
            profileP = [UIImage imageNamed:@"user_1.png"];
        }
        [profileDic setObject:profileP forKey:name];
    }
    return profileP;
}

-(void)userInfoChanged:(NSNotification*)note
{
    BOOL changed = [[note.userInfo objectForKey:@"changed"] boolValue];
    if (changed)
    {
        [profileDic removeAllObjects];
    }
}











































@end
