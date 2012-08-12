//
//  BWActivityLoader.m
//  Yini
//
//  Created by siqi wang on 12-8-7.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWActivityLoader.h"
static NSString *activityInfoPath;


@implementation BWActivityLoader

-(id)initWithUserName:(NSString *)name
{
    if (self = [super init])
    {
        NSArray *a = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dp = [a objectAtIndex:0];
        
        activityInfoPath = [dp stringByAppendingPathComponent:@"News/systemFile/yini system file/user activities"];
        self.userName = name;
        activityInfoPath = [activityInfoPath stringByAppendingPathComponent:[name stringByAppendingPathExtension:@"plist"]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:activityInfoPath]) {
            rawActivities = [NSKeyedUnarchiver unarchiveObjectWithFile:activityInfoPath];
        }
        else
        {
            
        }
    
    }
    return self;
}


-(NSArray *)activitiesPreparedForProfilePage
{
    NSMutableArray *preparedArray = [[NSMutableArray alloc] init];
    for (BWActivity *acti in rawActivities) {
        if (acti.type == BWActivityTypeNews)
        {//if news, it is added stright away
            BWActivityNews *news = (BWActivityNews*)acti;
            if ([[WSQFileHelper sharedHelper] fileExistInSysFolderWithNamePath:news.newsSysNamePath])///&& [[NSFileManager defaultManager] fileExistsAtPath:[[WSQFileHelper sharedHelper] directoryForNewsMediaFile:news.newsSysNamePath]]
            {//if we got the news~
                [preparedArray addObject:news];
            }
            
        }
        else if(acti.type == BWActivityTypeComment)
        {
            BWActivityComent *rawComment = (BWActivityComent*)acti;

            if ([preparedArray count] > 0)
            {
                BOOL haveTheObject = NO;
                BWActivity *checkActi;
                NSEnumerator *emnu = [preparedArray objectEnumerator];
                while (checkActi = [emnu nextObject])
                {
                    if (checkActi.type == BWActivityTypeComment)
                    {
                        BWActivityComent *comment = (BWActivityComent*)checkActi;
                        
                        if ([rawComment.newsSysNamePath isEqualToString:comment.newsSysNamePath])
                        {//check if the namePath for the news is the same
                            
                            if ([rawComment.date timeIntervalSinceDate:comment.date] > 0)
                            {//check which one is newer...
                             //if the new one is newer then the one already in the array
                                [preparedArray removeObject:checkActi];
                                [preparedArray addObject:rawComment];
                            }
                            haveTheObject = YES;
                        }
                    }
                }
                if (!haveTheObject)
                {
                    [preparedArray addObject:rawComment];
                }
            }
            else
            {
                [preparedArray addObject:rawComment];
            }
            
            
        }
    }
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    
    return [preparedArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]];
}






























@end
