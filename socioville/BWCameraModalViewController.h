//
//  BWCameraModalViewController.h
//  Yini
//
//  Created by siqi wang on 12-8-4.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsLoader.h"

@interface BWCameraModalViewController : UIViewController<UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, WSQFileUploaderDelegate, NewsLoaderDelegate>
{
    UIImage *selectedImage;
    NSString *newsName;
    NSString *fileName;
    WSQFileUploader *uploader;
    WSQFileHelper *helper;
    NewsLoader *loader;
}
- (IBAction)doneButton:(id)sender;
- (IBAction)closeButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *littleWheel;

@end
