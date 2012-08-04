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


@synthesize displayName;

-(id)initWithName:(NSString *)name
{
    self = [super init];
    self.displayName = name;
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.displayName forKey:@"displayName"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.displayName = [aDecoder decodeObjectForKey:@"displayName"];
    }
    return self;
}















-(NSString*)profilePicLocalPath
{
    return [self profilePicPathForName:self.displayName];
}



-(NSString*)profilePicPathForName:(NSString*)displayUserName
{
    NSString* pg = [BWAppDelegate instance].dbPlayingGround;
    NSArray *a = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dp = [a objectAtIndex:0];
    userInfoDirectory = [dp stringByAppendingPathComponent:@"News/systemFile/yini system file/user info"];
    NSString* np = [[userInfoDirectory stringByAppendingPathComponent:displayUserName] stringByAppendingPathExtension:@"jpg"];
    NSString* requestPath = [NSString stringWithFormat:@"yini system file/user info/%@.jpg", self.displayName];
    requestPath = [pg stringByAppendingPathComponent:requestPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:np]) {
        return np;

    }
    else
    {
        [[[DBRestClient alloc] initWithSession:[DBSession sharedSession]] loadFile:requestPath intoPath:np];
        return np;
    }
    

}
































@end
