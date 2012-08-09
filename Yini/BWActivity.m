//
//  BWActivity.m
//  Yini
//
//  Created by siqi wang on 12-8-6.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWActivity.h"

@implementation BWActivity
@synthesize owner, date, type, seenBy, relatedUsers;

-(id)initWithLord
{
    if (self = [super init]) {
        self.owner = [[BWLord myLord] myLordAsAUser];
        self.date = [NSDate date];
    }
    return self;
}

-(id)init
{
    return [self initWithLord];
}









-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.owner = [aDecoder decodeObjectForKey: @"owner"];
        self.date = [aDecoder decodeObjectForKey: @"date"];
        self.seenBy = [aDecoder decodeObjectForKey: @"seenBy"];
        self.relatedUsers = [aDecoder decodeObjectForKey: @"relatedUsers"];
        self.type = [aDecoder decodeIntegerForKey:@"type"];
    }

    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.owner forKey:@"owner"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.seenBy forKey:@"seenBy"];
    [aCoder encodeObject:self.relatedUsers forKey:@"relatedUsers"];
    [aCoder encodeInteger:self.type forKey:@"type"];
}

-(NSString*)ageDescription
{
    return [BWAgeCalculator describeDate:self.date];
    
}



































@end
