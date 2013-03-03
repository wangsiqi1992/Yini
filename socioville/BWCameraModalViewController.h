//
//  BWCameraModalViewController.h
//  Yini
//
//  Created by siqi wang on 12-8-4.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWNewsWriter.h"

@interface BWCameraModalViewController : UIViewController<UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate>
{
    UIImage *selectedImage;
    NSString *newsName;
    BOOL    fistTime;

}
- (IBAction)doneButton:(id)sender;
- (IBAction)closeButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *littleWheel;

@end
