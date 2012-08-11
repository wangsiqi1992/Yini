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

            for (BWActivity* checkingActi in preparedArray)
            {
                if (checkingActi.type == BWActivityTypeComment)
                {// if it is a comment
                    BWActivityComent *comment = (BWActivityComent*)checkingActi;
                    if (rawComment.newsSysNamePath == comment.newsSysNamePath)
                    {//check if the namePath for the news is the same
                        
                        if ([rawComment.date timeIntervalSinceDate:comment.date] < 0)
                        {//check which one is newer...
                            //if the new one is newer then the one already in the array
                            [preparedArray delete:checkingActi];
                            [preparedArray addObject:comment];
                        }
                        
                    }
                }
               
            }
            
        }
    }
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    
    return [preparedArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]];
}






























@end
