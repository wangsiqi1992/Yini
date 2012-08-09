//
//  BWMyLordActivityWriter.h
//  Yini
//
//  Created by siqi wang on 12-8-6.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWLord.h"
#import "BWActivityNews.h"
#import "WSQFileUploader.h"

@interface BWMyLordActivityWriter : NSObject<WSQFileUploaderDelegate>
{
    NSMutableArray *myLordActivities;
    NSMutableArray *loadedActivities;
}

+(BWMyLordActivityWriter*)sharedLordActiWriter;

-(void)addNewActivity:(BWActivity*)activity;







@end
