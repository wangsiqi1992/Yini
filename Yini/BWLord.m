//
//  BWLord.m
//  Yini
//
//  Created by siqi wang on 12-7-20.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWLord.h"
static NSString* myLordInfoSavePath;
static NSString* myLordProfilePicSavePath;
static NSString* myLordProfilePicDBRequestPath;
static BWLord *myLord;
@implementation BWLord
@synthesize delegate;


+(BWLord*)myLord
{
    if (nil != myLord) {
        return myLord;
    }
    else
    {
        myLord = [[BWLord alloc] init];
    }
    return myLord;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        NSArray *a = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dp = [a objectAtIndex:0];
        myLordInfoSavePath = [dp stringByAppendingPathComponent:@"User/myLordInfo.plist"];
        myLordProfilePicSavePath = [dp stringByAppendingPathComponent:@"News/systemFile/yini system file/user info"];
        myLordProfilePicDBRequestPath = @"王小旎/yini system file/user info";
        
        //related to self...
        if (![[NSFileManager defaultManager] fileExistsAtPath:myLordInfoSavePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[[myLordInfoSavePath stringByDeletingLastPathComponent] stringByDeletingPathExtension] withIntermediateDirectories:YES attributes:nil error:nil];
            [[self client] loadAccountInfo];
        }
        else
        {
            self = [NSKeyedUnarchiver unarchiveObjectWithFile:myLordInfoSavePath];
            
            
        }

    }
    return self;


    
    
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return self;
}










-(BWUser*)myLordAsAUser
{
    return [super initWithName:self.displayName];
}

-(NSString*)myLordInfoSavePath
{
    return myLordInfoSavePath;
}

-(void)selfDestory
{
    myLord = nil;
}



- (DBRestClient *)client {
    if (!client && [[DBSession sharedSession] isLinked]) {
        client = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        client.delegate = self;
    }
    return client;
}



















#pragma mark - db call back

-(void)restClient:(DBRestClient *)client loadedAccountInfo:(DBAccountInfo *)info
{
    self.displayName = info.displayName;
//    self.profilePicLocalPath = [self profilePicPathForName:self.displayName];

    [[NSFileManager defaultManager] createFileAtPath:myLordInfoSavePath contents:nil attributes:nil];
    [NSKeyedArchiver archiveRootObject:self toFile:myLordInfoSavePath];
    
    myLordProfilePicSavePath = [myLordProfilePicSavePath stringByAppendingPathComponent:[self.displayName stringByAppendingPathExtension:@"jpg"]];
    myLordProfilePicDBRequestPath = [myLordProfilePicDBRequestPath stringByAppendingPathComponent:[self.displayName stringByAppendingPathExtension:@"jpg"]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:myLordProfilePicSavePath])
    {
        //if my lord profile pic has not been down loaded...
        [[NSFileManager defaultManager] createDirectoryAtPath:[[myLordProfilePicSavePath stringByDeletingLastPathComponent] stringByDeletingPathExtension] withIntermediateDirectories:YES attributes:nil error:nil];
        [[self client] loadFile:myLordProfilePicDBRequestPath intoPath:myLordProfilePicSavePath];
    }
    [[self delegate] myLordInfoLoaded];
}

- (void)restClient:(DBRestClient*)client loadAccountInfoFailedWithError:(NSError*)error
{
    NSLog(@"load account info fail...");
}

-(void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error
{
    [[self delegate] myLordProfilePicLoaded];
}

-(void)restClient:(DBRestClient *)client loadedFile:(NSString *)destPath
{
    [[self delegate] myLordProfilePicLoaded];
}


-(NSString*)profilePicLocalPath
{
    return [super profilePicPathForName:self.displayName];
}












@end
