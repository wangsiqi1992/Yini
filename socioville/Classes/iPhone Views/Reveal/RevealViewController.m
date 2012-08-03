//
//  RevealViewController.m
//  socioville
//
//  Created by Valentin Filip on 09.04.2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import "RevealViewController.h"
#import "MainViewController.h"

@interface RevealViewController ()

@end

@implementation RevealViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self performSegueWithIdentifier:@"showMain" sender:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated {
    //
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [super viewDidAppear:animated];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *frontVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FrontVC"];
    UIViewController *rearVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RearVC"];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:frontVC];
    
    MainViewController *mainVC = segue.destinationViewController;
    mainVC.frontViewController = nav;
    mainVC.rearViewController = rearVC;
}

@end
