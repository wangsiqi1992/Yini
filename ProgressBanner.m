//
//  ProgressBanner.m
//  Yini
//
//  Created by siqi wang on 12-8-7.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "ProgressBanner.h"

@implementation ProgressBanner
@synthesize  littleWheel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.littleWheel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.littleWheel setCenter:CGPointMake(self.littleWheel.frame.size.width/2, self.littleWheel.frame.size.height/2)];
        [self.littleWheel setColor:[UIColor blackColor]];
        self.littleWheel.frame = CGRectMake(self.frame.size.width/2, self.frame.size.height/2, 100, 100);
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setOpaque:NO];
        [self addSubview:self.littleWheel];
        [self.littleWheel setHidesWhenStopped:YES];
        
    }
    return self;
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // UIView will be "transparent" for touch events if we return NO
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
