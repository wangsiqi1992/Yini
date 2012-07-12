//
//  BWAppDelegate.h
//  Yini
//
//  Created by siqi wang on 12-7-12.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
