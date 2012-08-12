//
//  BWProfileImageVIew.m
//  Yini
//
//  Created by siqi wang on 12-8-12.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWProfileImageVIew.h"

@implementation BWProfileImageVIew
@synthesize userDisplayName = _userDisplayName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setUserDisplayName:(NSString *)userDisplayName
{
    _userDisplayName = userDisplayName;
    self.image = [[BWImageStroe sharedStore] userProfileViewWithUserDisplayName:userDisplayName];
    
}

-(void)enableTouchEventFromVC:(UIViewController *)viewCon
{
    vc = viewCon;
    tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(initActivityVC)];
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:tapRec];
}


-(void)initActivityVC
{
    BWActivityLoaderViewController *actiVC = [[vc storyboard] instantiateViewControllerWithIdentifier:@"activity VC"];
    [actiVC setUser:[[BWUser alloc] initWithName:self.userDisplayName]];
    [vc.navigationController pushViewController:actiVC animated:YES];
    
}
























@end
