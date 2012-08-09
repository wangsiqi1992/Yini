//
//  BWActivityLoaderViewController.h
//  Yini
//
//  Created by siqi wang on 12-8-7.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWUser.h"
#import "BWActivityLoader.h"
#import "BWUserActivityCommentsCell.h"
#import "BWUserActivityNewsCell.h"
#import "UserActivityProfileCell.h"
#import "ZUUIRevealController.h"
#import "MainViewController.h"


@interface BWActivityLoaderViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *activities;
    BWActivityLoader *actiLoader;
    UITapGestureRecognizer *dismissMenuTap;

    
}
@property (strong, nonatomic) BWUser *user;




@end
