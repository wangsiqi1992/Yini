//
//  BWNewsWriter.h
//  Yini
//
//  Created by siqi wang on 12-8-7.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsLoader.h"
#import "BWMyLordActivityWriter.h"
#import "BWNotificationCenter.h"
enum status{
    BWNewsWriterStatusUploadingMediaFile,
    BWNewsWriterStatusUploadingSystemFile,
    BWNewsWriterStatusUploadingActivity,
    BWNewsWriterStatusFree
};

enum task {
    BWNewsWriterTaskCompostNews = 1,
    BWNewsWriterTaskSaveNews = 2
    };




@interface BWNewsWriter : NSObject<WSQFileUploaderDelegate>
{
    NSString *fileName;
    NSDictionary *pendingAtrributes;
    WSQNews* news;
    NSInteger status;
    NSInteger task;
    BOOL waitingForFile;    /**only used for save news sys file... when checking if updates~*/
}



+(BWNewsWriter*)sharedWriter;
-(BOOL)composePhotoNewsWithPhoto:(UIImage*)image attributes:(NSDictionary*)attributes;

-(BOOL)saveNewsObject:(id)newsObject;
@property (nonatomic, strong) id delegate;

@end








@protocol BWNewsWriterDelegate <NSObject>

-(WSQNews*)reImplementNews;

@optional
-(void)writingNewsSucceed;

@end




























