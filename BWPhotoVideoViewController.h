//
//  BWPhotoVideoViewController.h
//  Yini
//
//  Created by siqi wang on 12-7-16.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsObjectPhoto.h"
#import "NewsLoader.h"

@interface BWPhotoVideoViewController : UIViewController<NewsLoaderDelegate, UITextFieldDelegate>
{
    NewsLoader *loader;
    WSQNews *detailedObject;
    UITextField *activeTextField;
}
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *littleWheel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *littleWheelForNewsNameTextField;
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;
@property (strong, nonatomic) IBOutlet UITextField *newsNameTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


-(void)initWithDetailedObject:(id)dOb;
@end
