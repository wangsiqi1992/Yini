//
//  BWMyLordActivityWriter.m
//  Yini
//
//  Created by siqi wang on 12-8-6.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWMyLordActivityWriter.h"
static BWMyLordActivityWriter *sharedLordActiWriter;
static NSString *myLordActivityFileLocalPath;
//static NSString *LordFileNamePath;
static NSString *actiFileNamePath;



@implementation BWMyLordActivityWriter

+(BWMyLordActivityWriter*)sharedLordActiWriter
{
    if (nil != sharedLordActiWriter) {
        return sharedLordActiWriter;
    }
    else
    {
        sharedLordActiWriter = [[BWMyLordActivityWriter alloc] init];
    }
    return sharedLordActiWriter;
}

-(id)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadedNewActivityFile:) name:[BWNotificationCenter userActivityNotificationName] object:nil];
        
        NSArray *a = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dp = [a objectAtIndex:0];
        
        NSString* LordFileNamePath = [[@"News/systemFile/yini system file/user activities/" stringByAppendingPathComponent:[BWLord myLord].displayName] stringByAppendingPathExtension:@"plist"];
        myLordActivityFileLocalPath = [dp stringByAppendingPathComponent:LordFileNamePath];
        actiFileNamePath = [[BWLord myLord].displayName stringByAppendingPathExtension:@"plist"];
        actiFileNamePath = [@"user activities" stringByAppendingPathComponent:actiFileNamePath];
        
        loadedActivities = [[NSMutableArray alloc] init];
        if ([[NSFileManager defaultManager] fileExistsAtPath:myLordActivityFileLocalPath]) {
            [self loadRawActivities];
        }
        else
        {
            myLordActivities = [[NSMutableArray alloc] init];
        }
        return self;
    }
    return nil;
}





-(void)loadedNewActivityFile:(NSNotification*)note
{
    if ([[note.userInfo objectForKey:@"changed"] boolValue] == YES) {
        if ([[note.userInfo objectForKey:@"userName"] isEqualToString:[BWLord myLord].displayName])
        {
            [self loadRawActivities];
        }
        [[WSQFileHelper sharedHelper] refresh];
    }
    else
    {
        if([loadedActivities count] > 0)
        {
            WSQFileUploader *uploader = [WSQFileUploader sharedLoader];
            NSString *temp = [uploader sysFileUploadingTempPathForNews:actiFileNamePath];
            [myLordActivities addObjectsFromArray:loadedActivities];
            if (![[NSFileManager defaultManager] fileExistsAtPath:temp]) {
                [[NSFileManager defaultManager] createFileAtPath:temp contents:nil attributes:nil];
            }
            [NSKeyedArchiver archiveRootObject:myLordActivities toFile:temp];
            [uploader saveSysFileOfNews:actiFileNamePath withOldName:actiFileNamePath];
            [loadedActivities removeAllObjects];

        }
    }
}




-(void)addNewActivity:(BWActivity *)activity
{
    if (activity) {
        [loadedActivities addObject:activity];
        [[WSQFileHelper sharedHelper] refresh];
    }
}

-(void)fileUploadFinished:(BOOL)isSucceed
{
    if (isSucceed) {
    }
    else
    {
        NSLog(@"my lord activity writer save file fail... WTF?");
    }
}

-(void)loadRawActivities
{
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:myLordActivityFileLocalPath];
    myLordActivities = [array mutableCopy];
    
}



























@end
