//
//  BWAppDelegate.h
//  Yini
//
//  Created by siqi wang on 12-7-12.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorSwitcher.h"
#import <DropboxSDK/DropboxSDK.h>
#import "WSQFilehelper.h"



@interface BWAppDelegate : UIResponder <UIApplicationDelegate, DBSessionDelegate>
{

}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSString* dbPlayingGround;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@property (strong, nonatomic) ColorSwitcher* colorSwitcher;

+(BWAppDelegate *)instance;

- (void)customizeGlobalTheme;

- (void)customizeiPadTheme;


@end
