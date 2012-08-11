//
//  CustomTabBarViewController.h
//
//  Created by Valentin Filip on 04/03/2012.
//
// Copyright (c) 2012 Valentin Filip
// 

#import "BaseViewController.h"
#import "ProgressBanner.h"
#import "BWNotificationCenter.h"

@interface CustomTabBarViewController : BaseViewController <UINavigationControllerDelegate>
{
    ProgressBanner *pb;

}

@property (nonatomic) BOOL allowLandscape;

@end
