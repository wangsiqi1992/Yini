//
//  WSQFileUploader.h
//  WSQFileHelperTestProject
//
//  Created by siqi wang on 12-7-10.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>
#import "WSQFileHelper.h"
#import "BWNotificationCenter.h"
@interface WSQFileUploader : NSObject<DBRestClientDelegate>
{
    NSFileManager *manager;
    WSQFileHelper *helper;
    DBRestClient *client;
    NSMutableDictionary *uploadingList;
}



+(WSQFileUploader *)sharedLoader;

-(void)saveSysFileOfNews:(NSString*)name withOldName:(NSString*)oldName;//reture string have not been changed the extension...
-(void)saveMediaFileOfNews:(NSString*)name withOldName:(NSString*)oldName;
-(NSString*)sysFileUploadingTempPathForNews:(NSString*)name;
-(NSString*)mediaFileUploadingTempPathForNews:(NSString*)name;
@property (nonatomic, strong) id delegate;

-(void)selfDestory;

-(void)setDBRootPath;

@end

@protocol WSQFileUploaderDelegate <NSObject>




@optional
-(void)fileUploadFinished:(BOOL)isSucceed;
@end