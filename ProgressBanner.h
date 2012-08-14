//
//  ProgressBanner.h
//  Yini
//
//  Created by siqi wang on 12-8-7.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADVPopoverProgressBar.h"


@interface ProgressBanner : UIView

@property (nonatomic, strong) UILabel* statusLable;
@property (nonatomic, strong) UIActivityIndicatorView* littleWheel;
@property (nonatomic, strong) ADVPopoverProgressBar *progressBar;


@end
