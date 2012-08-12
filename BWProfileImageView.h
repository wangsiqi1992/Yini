//
//  BWProfileImageView.h
//  Yini
//
//  Created by siqi wang on 12-8-12.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWProfileImageView : UIImageView

-(void)setUserDisplayName:(NSString *)userDisplayName;

-(void)enableTouchEventFromVC:(UIViewController *)viewCon;
@end
