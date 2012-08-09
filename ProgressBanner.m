//
//  ProgressBanner.m
//  Yini
//
//  Created by siqi wang on 12-8-7.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "ProgressBanner.h"

@implementation ProgressBanner

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.littleWheel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.littleWheel setCenter:CGPointMake(self.littleWheel.frame.size.width/2, self.littleWheel.frame.size.height/2)];
        
        CGRect stuFrame = CGRectMake(self.littleWheel.frame.size.width, 0, self.frame.size.width - self.littleWheel.frame.size.width, self.littleWheel.frame.size.height);
        self.statusLable = [[UILabel alloc] initWithFrame:stuFrame];
        
        [self setBackgroundColor:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:0.9]];
        [self addSubview:self.littleWheel];
        [self addSubview:self.statusLable];
        [self.statusLable setBackgroundColor:[UIColor clearColor]];
        [self.statusLable setTextAlignment:NSTextAlignmentCenter];
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
