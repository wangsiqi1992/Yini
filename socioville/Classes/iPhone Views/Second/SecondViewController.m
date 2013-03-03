//
//  SecondViewController.m
//  socioville
//
//  Created by Valentin Filip on 4/20/12.
//  Copyright (c) 2012 Universitatea Babeș-Bolyai. All rights reserved.
//

#import "SecondViewController.h"
#import "ZUUIRevealController.h"
#import "BWAppDelegate.h"

@interface SecondViewController ()

@property (retain, nonatomic) UIPanGestureRecognizer *navigationBarPanGestureRecognizer;

@end



@implementation SecondViewController

@synthesize navigationBarPanGestureRecognizer;

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.title = NSLocalizedString(@"Home", @"Home");
	
    UINavigationController *nav = self.navigationController;
    UIViewController *controller = nav.parentViewController; // MainViewController : ZUUIRevealController
    if ([controller respondsToSelector:@selector(revealGesture:)] && [controller respondsToSelector:@selector(revealToggle:)])
	{
		// Check if a UIPanGestureRecognizer already sits atop our NavigationBar.
		if (![[self.navigationController.navigationBar gestureRecognizers] containsObject:self.navigationBarPanGestureRecognizer])
		{
			// If not, allocate one and add it.
			UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:controller action:@selector(revealGesture:)];
			self.navigationBarPanGestureRecognizer = panGestureRecognizer;
			
			[self.navigationController.navigationBar addGestureRecognizer:self.navigationBarPanGestureRecognizer];
		}
		
		// Check if we have a revealButton already.
		if (![self.navigationItem leftBarButtonItem]) {
			// If not, allocate one and add it.
			UIImage *imageMenu = [[BWAppDelegate instance].colorSwitcher getImageWithName:@"button-menu.png"];
            UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [menuButton setImage:imageMenu forState:UIControlStateNormal];
            menuButton.frame = CGRectMake(0.0, 0.0, imageMenu.size.width, imageMenu.size.height);
            [menuButton addTarget:controller action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
            
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
		}
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

@end
