//
//  BWPlayingGroundSettingViewController.m
//  Yini
//
//  Created by siqi wang on 12-8-3.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWPlayingGroundSettingViewController.h"

@interface BWPlayingGroundSettingViewController ()

@end

@implementation BWPlayingGroundSettingViewController
@synthesize textField;

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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)doneButton:(id)sender
{
    [BWLord myLord].dbPlayingGround = self.textField.text;
    [[WSQFileHelper sharedHelper] setDBRootPath:self.textField.text];
    [[WSQFileUploader sharedLoader] setDBRootPath];
    
    [self dismissModalViewControllerAnimated:YES];
}
























@end
