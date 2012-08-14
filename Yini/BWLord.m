//
//  BWLord.m
//  Yini
//
//  Created by siqi wang on 12-7-20.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWLord.h"
#import "BWAppDelegate.h"


static NSString* myLordInfoSavePath;
static NSString* myLordProfilePicSavePath;
static NSString* myLordProfilePicDBRequestPath;
static BWLord *myLord;
@implementation BWLord
@synthesize delegate;
@synthesize dbPlayingGround = _dbPlayingGround;


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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selfDestory) name:[BWNotificationCenter logOutNotificationName] object:nil];
        if ([[DBSession sharedSession] isLinked]) {
            NSArray *a = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *dp = [a objectAtIndex:0];
            myLordInfoSavePath = [dp stringByAppendingPathComponent:@"User/myLordInfo.plist"];
            myLordProfilePicSavePath = [dp stringByAppendingPathComponent:@"News/systemFile/yini system file/user info"];
            
            //related to self...
            if (![[NSFileManager defaultManager] fileExistsAtPath:myLordInfoSavePath]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:[[myLordInfoSavePath stringByDeletingLastPathComponent] stringByDeletingPathExtension] withIntermediateDirectories:YES attributes:nil error:nil];
                [[self client] loadAccountInfo];
            }
            else
            {
                self = [NSKeyedUnarchiver unarchiveObjectWithFile:myLordInfoSavePath];
                
                
            }
            [BWAppDelegate instance].dbPlayingGround = self.dbPlayingGround;

        }


    }
    return self;


    
    
    
}

-(void)setDbPlayingGround:(NSString *)dbPlayingGround
{
    _dbPlayingGround = dbPlayingGround;
    if (dbPlayingGround)
    {
        //set it into a real string... not when destory it...
        myLordProfilePicDBRequestPath = [dbPlayingGround stringByAppendingPathComponent:@"yini system file/user info"];
        myLordProfilePicDBRequestPath = [@"/" stringByAppendingString:myLordProfilePicDBRequestPath];
        [NSKeyedArchiver archiveRootObject:self toFile:[self myLordInfoSavePath]];
        
    }
    [BWAppDelegate instance].dbPlayingGround = dbPlayingGround;
    
    if (dbPlayingGround) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:myLordProfilePicSavePath])
        {
                //if my lord profile pic has not been down loaded...
            [[NSFileManager defaultManager] createDirectoryAtPath:[[myLordProfilePicSavePath stringByDeletingLastPathComponent] stringByDeletingPathExtension] withIntermediateDirectories:YES attributes:nil error:nil];
            if (myLordProfilePicDBRequestPath)
            {
                    //if the root is set...
                [[self client] loadFile:myLordProfilePicDBRequestPath intoPath:myLordProfilePicSavePath];
            }
        }
    }

    
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.dbPlayingGround forKey:@"dbPlayingGround"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.dbPlayingGround = [aDecoder decodeObjectForKey:@"dbPlayingGround"];
    return self;
}










-(BWUser*)myLordAsAUser
{
    BWUser *me = [[BWUser alloc]initWithName:self.displayName];
    return me;
}

-(NSString*)myLordInfoSavePath
{
    return myLordInfoSavePath;
}

-(void)selfDestory
{
    myLord = nil;
    self.dbPlayingGround = nil;
    self.displayName = nil;
    
}



- (DBRestClient *)client {
    if (!client && [[DBSession sharedSession] isLinked]) {
        client = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        client.delegate = self;
    }
    return client;
}



-(NSString*)profilePicLocalPath
{
    if (self.displayName) {
        return [super profilePicPathForName:self.displayName];
    }
    else return nil;
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
//    if (![[NSFileManager defaultManager] fileExistsAtPath:myLordProfilePicSavePath])
//    {
//        //if my lord profile pic has not been down loaded...
//        [[NSFileManager defaultManager] createDirectoryAtPath:[[myLordProfilePicSavePath stringByDeletingLastPathComponent] stringByDeletingPathExtension] withIntermediateDirectories:YES attributes:nil error:nil];
//        if (myLordProfilePicDBRequestPath)
//        {
//            //if the root is set...
//            [[self client] loadFile:myLordProfilePicDBRequestPath intoPath:myLordProfilePicSavePath];
//        }
//    }
    if ([self.delegate respondsToSelector:@selector(myLordInfoLoaded)])
    {
        [[self delegate] myLordInfoLoaded];
    }
}

- (void)restClient:(DBRestClient*)client loadAccountInfoFailedWithError:(NSError*)error
{
    NSLog(@"load account info fail...");
}

-(void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error
{
//    [[self delegate] myLordProfilePicLoaded];
    
}

-(void)restClient:(DBRestClient *)client loadedFile:(NSString *)destPath
{
    [[self delegate] myLordProfilePicLoaded];
}













@end
