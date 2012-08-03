//
//  CustomTabBarViewController.m
//
//  Created by Valentin Filip on 04/03/2012.
//
// Copyright (c) 2012 Valentin Filip
// 


#import "CustomTabBarViewController.h"

@implementation CustomTabBarViewController

@synthesize allowLandscape;

- (void)viewDidLoad
{
    [super viewDidLoad];
    int idx = (self.viewControllers.count / 2);
    UIViewController *controller = [self.viewControllers objectAtIndex:idx];
    NSString *string = controller.title ? controller.title : @" ";
    [self addCenterButtonWithOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                        @"tabbar-center.png", @"buttonImage"
                                      , @"camera.png", @"icon"
                                      , string, @"title"
                                      , nil]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(self.allowLandscape || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

@end
