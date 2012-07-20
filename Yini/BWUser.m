//
//  BWUser.m
//  Yini
//
//  Created by siqi wang on 12-7-19.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWUser.h"

static NSString* userInfoDirectory;


@implementation BWUser



@synthesize displayName, profilePicLocalPath;

-(id)initWithName:(NSString *)name
{
    self = [super init];
    self.displayName = name;
    self.profilePicLocalPath = [self profilePicPathForName:name];
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.displayName forKey:@"displayName"];
    [aCoder encodeObject:self.profilePicLocalPath forKey:@"profilePicLocalPath"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.profilePicLocalPath = [aDecoder decodeObjectForKey:@"profilePicLocalPath"];
        self.displayName = [aDecoder decodeObjectForKey:@"displayName"];
    }
    return self;
}



















-(NSString*)profilePicPathForName:(NSString*)displayUserName
{
    NSArray *a = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dp = [a objectAtIndex:0];
    userInfoDirectory = [dp stringByAppendingPathComponent:@"News/systemFile/yini system file/user info"];
    return [[userInfoDirectory stringByAppendingPathComponent:displayUserName] stringByAppendingPathExtension:@"jpg"];

}
































@end
