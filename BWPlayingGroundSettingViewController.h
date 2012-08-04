//
//  BWPlayingGroundSettingViewController.h
//  Yini
//
//  Created by siqi wang on 12-8-3.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWLord.h"
//#import "WSQFileHelper.h"
#import "WSQFileUploader.h"

@interface BWPlayingGroundSettingViewController : UIViewController
- (IBAction)doneButton:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *textField;
@end
