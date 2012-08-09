//
//  BWActivityNews.m
//  Yini
//
//  Created by siqi wang on 12-8-6.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWActivityNews.h"

@implementation BWActivityNews
@synthesize newsSysNamePath, userDiscription;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.newsSysNamePath = [aDecoder decodeObjectForKey:@"newsSysNamePath"];
        self.userDiscription = [aDecoder decodeObjectForKey:@"userDiscription"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.newsSysNamePath forKey:@"newsSysNamePath"];
    [aCoder encodeObject:self.userDiscription forKey:@"userDiscription"];
}

-(id)initWithNewsSysNamePath:(NSString *)namePath
{
    if ([super init]) {
        self.newsSysNamePath = namePath;
        return self;
    }
    return nil;
}
































@end
