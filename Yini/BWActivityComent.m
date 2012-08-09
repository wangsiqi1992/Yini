//
//  BWActivityComent.m
//  Yini
//
//  Created by siqi wang on 12-8-7.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWActivityComent.h"

@implementation BWActivityComent

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
        WSQNews *news = [[WSQNews alloc] initWithSysFilePath:namePath];
        if (news.author) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.relatedUsers];
            [array addObject:news.author];
            self.relatedUsers = array;
            self.userDiscription = [NSString stringWithFormat:@"commented on %@'s news: %@", news.author, news.newsName];
        }
        else
        {
            self.userDiscription = [NSString stringWithFormat:@"commented on news:%@", news.newsName];
        }
        
        return self;
    }
    return nil;
}


@end
