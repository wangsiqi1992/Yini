//
//  MainViewController.m
//  socioville
//
//  Created by Valentin Filip on 09.04.2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import "MainViewController.h"
#import "MasterViewController.h"
#import "MenuViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.viewControllers = [NSArray arrayWithObject:self];
    self.title = self.frontViewController.title;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)revealToggle:(id)sender {
    MenuViewController *rearVC = (MenuViewController *)self.rearViewController;
    [rearVC.searchBar resignFirstResponder];
    
    [super revealToggle:sender];
}

- (void)revealGesture:(UIPanGestureRecognizer *)recognizer {
    MenuViewController *rearVC = (MenuViewController *)self.rearViewController;
    [rearVC.searchBar resignFirstResponder];
    
    [super revealGesture:recognizer];
}

@end
