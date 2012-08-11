//
//  BWNotificationCenter.h
//  Yini
//
//  Created by siqi wang on 12-8-9.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//



#import <Foundation/Foundation.h>


/**
	Provide a central place to registering notifications!
 */
@interface BWNotificationCenter : NSObject
{
    NSNotificationCenter *center;
}

+(NSString*)logOutNotificationName;
+(NSString*)clearCatchNotificationName;
+(NSString*)uiProgressBarNotificationName;

/**
	indivadual folder monitoring
    userInfo Keys:
                    -changed    bool
                    -name path  string
	@returns string
 */
+(NSString*)userActivityNotificationName;
+(NSString*)userInfoNotificationName;
+(NSString*)newsSysFileFolderNotificationName;

/**
	global file mointor,
    userInfo Keys:
                    -changed        bool
                    -changed paths  array   (when loading delta)
                    -name path      string  (when actural file is loaded)
	@returns 
 */
+(NSString*)playingGroundAllOurFilesNotificationName;

/**
 Used for the helper and uploader to send notifications, help other object to get the correct notification name they are registering..
 @warning       no notification is registered for other use...
 @code{.m}
 static NSString *logOutNotificationName = @"log out";
 static NSString *clearCatchNotification = @"clear catch";
 static NSString *uiProgressBarShowNotification = @"start loading data";
 static NSString *uiProgressBarDismissNotification = @"finished loading";
 static NSString *userActivityNotificationName = @"user activities";
 static NSString *userInfoNotificationName = @"user info";
 static NSString *newsSysFileFolderNotificationName = @"yini system file";
 @endcode
 
 */
+(BWNotificationCenter*)sharedCenter;



/** called when there is a file changed when helper loaded the delta
 @note                              only added name is put into file
 @param     changedFileNamePaths    dictionary of all the new added files, db name path(not lowercaseString)
 */
-(void)filesChangedWhenLoadingTheDelta:(NSArray*)changedFileNamePaths;

/**
 help when there is no change
*/
-(void)filesNoChangeWhenLoadingTheDelta;

/**called when helper loaded a file~
 @param     namePath    local path for the file changed
 */
-(void)loadedFile:(NSString*)namePath;

/**
 when user want to log himself out
 */
-(void)logOut;

/**
 when system want to clear the catch
 */
-(void)clearCatch;


/**
 loading progress, may be used when first loading the data or uploading progress, or downloading progress
    @note           userInfo send with key:loading + progress
	@param yes      loading or not
	@param progress progress
    @param description  status message
 */
-(void)loading:(BOOL)yes withProgress:(float)progress uiDescription:(NSString*)description;



















































@end
