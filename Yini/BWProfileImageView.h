//
//  BWProfileImageVIew.h
//  Yini
//
//  Created by siqi wang on 12-8-12.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWImageStroe.h"
#import "BWActivityLoaderViewController.h"

@interface BWProfileImageVIew : UIImageView
{
    UIViewController *vc;
    UITapGestureRecognizer *tapRec;
}

@property (nonatomic, strong) NSString* userDisplayName;
-(void)enableTouchEventFromVC:(UIViewController*)viewCon;






@end
