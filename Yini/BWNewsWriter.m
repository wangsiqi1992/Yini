//
//  BWNewsWriter.m
//  Yini
//
//  Created by siqi wang on 12-8-7.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWNewsWriter.h"
static BWNewsWriter *sharedWriter;


@implementation BWNewsWriter

+(BWNewsWriter*)sharedWriter
{
    if (nil != sharedWriter) {
        return sharedWriter;
    }
    else
    {
        sharedWriter = [[BWNewsWriter alloc] init];
    }
    return sharedWriter;
}

-(BOOL)composePhotoNewsWithPhoto:(UIImage *)image attributes:(NSDictionary *)attributes
{
    if (image && [attributes objectForKey:@"news name"]) {
        pendingAtrributes = attributes;
        
        WSQFileUploader *uploader = [WSQFileUploader sharedLoader];
        NSDate* now = [NSDate date];
        fileName = [[[NSString stringWithFormat:@"%@ %@", [BWLord myLord].displayName, [NSDateFormatter localizedStringFromDate:now dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle]] stringByReplacingOccurrencesOfString:@":" withString:@" "] stringByAppendingPathExtension:@"jpg"];
        
        
        NSString *saveP = [[WSQFileUploader sharedLoader] mediaFileUploadingTempPathForNews:fileName];
        
        NSError *e;
        
        NSData *d = UIImageJPEGRepresentation(image, 1);
        [d writeToFile:saveP options:NSDataWritingAtomic error:&e];
        NSLog(@"%@", [e localizedDescription]);
        
        [uploader saveMediaFileOfNews:fileName withOldName:nil];
        uploader.delegate = self;
        
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"saving news", @"status", nil];
        NSNotification *note = [NSNotification notificationWithName:@"start loading data" object:self userInfo:userInfo];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        
        return YES;
    }
    return NO;
    
}
















#pragma mark - delegate call backs...

-(void)fileUploadFinished:(BOOL)isSucceed
{
    
    if (isSucceed) {
        NewsLoader *loader = [NewsLoader sharedLoader];
        [loader refresh];
        loader.delegate = self;
    }
    
    
    
}


-(void)newsLoaderDidLoadFile
{
    WSQFileHelper *helper = [WSQFileHelper sharedHelper];
    NewsLoader *loader = [NewsLoader sharedLoader];
    WSQNews *wsqNews = [[WSQNews alloc] initWithMetadataPath:[helper mediaMetadataPathForNews:fileName]];
    if (wsqNews.newsType == WSQPhoto) {
        NewsObjectPhoto *newsOject = [[NewsObjectPhoto alloc] initWithMetadataPath:[helper mediaMetadataPathForNews:fileName]];
        if (newsOject) {
            newsOject.author = [[BWLord myLord] myLordAsAUser];
            newsOject.newsName = [pendingAtrributes objectForKey:@"news name"];
            [loader saveNewsObject:newsOject];
            loader.delegate = self;
            news = newsOject;
        }
    }
    
    
    
}

-(void)saveNewsObjectSucceed
{
    //yeah!

    fileName = nil;
    pendingAtrributes = nil;
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"finished save news", @"status", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"finished loading" object:self userInfo:userInfo];
    [[WSQFileUploader sharedLoader] setDelegate:Nil];
    [[NewsLoader sharedLoader] setDelegate:Nil];
    if ([news isKindOfClass:[WSQNews class]])
    {
        WSQNews *theNews = (WSQNews*)news;
        BWActivityNews *acti = [[BWActivityNews alloc] initWithNewsSysNamePath:theNews.namePath];
        [acti setUserDiscription:[NSString stringWithFormat:@"%@ shared a news:", acti.owner.displayName]];
        [[BWMyLordActivityWriter sharedLordActiWriter] addNewActivity:acti];
        

    }
}























@end
