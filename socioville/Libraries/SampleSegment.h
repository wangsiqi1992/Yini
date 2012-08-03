//
//  PopoverSegment.h
//  ocean
//
//  Created by Valentin Filip on 3/25/12.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSegmentedControl.h"

@protocol SampleSegmentDelegate;

@interface SampleSegment : UIView <CustomSegmentedControlDelegate>

@property (nonatomic, strong)   NSArray             *titles;
@property (nonatomic) id<SampleSegmentDelegate>      delegate;

@end

@protocol SampleSegmentDelegate

- (void)selectedSegmentAtIndex:(NSInteger)index;

@end