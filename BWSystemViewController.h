//
//  BWSystemViewController.h
//  Yini
//
//  Created by siqi wang on 12-8-3.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSQFileHelper.h"
#import "BWLord.h"
#import "NewsLoader.h"
#import <DropboxSDK/DropboxSDK.h>
#import "BWNotificationCenter.h"

@interface BWSystemViewController : UIViewController
- (IBAction)clearCatchButton:(id)sender;
- (IBAction)logOutButton:(id)sender;

@end
