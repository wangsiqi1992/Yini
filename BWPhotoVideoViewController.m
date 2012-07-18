//
//  BWPhotoVideoViewController.m
//  Yini
//
//  Created by siqi wang on 12-7-16.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWPhotoVideoViewController.h"

@interface BWPhotoVideoViewController ()

@end

@implementation BWPhotoVideoViewController
@synthesize littleWheel;
@synthesize mainImageView;
@synthesize newsNameTextField;

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
    
    id dOb = detailedObject;
    
    if (dOb) {
        if ([dOb isKindOfClass:[NewsObjectPhoto class]])
        {
            NewsObjectPhoto *p = (NewsObjectPhoto*) dOb;
            
            [self.littleWheel setHidesWhenStopped:YES];
            [self.littleWheel startAnimating];
            
            if (p.newsName)
            {
                self.newsNameTextField.placeholder = p.newsName;
                
            }
            else
            {
                self.newsNameTextField.placeholder = @"Please enter a name for this photo";
            }
            
            //            [self.playButton removeFromSuperview];
            //            [self.playButton setHidden:YES];
            [self.mainImageView setImage:nil];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:p.mediaPath])
            {
                [self.littleWheel stopAnimating];
                [self.littleWheel setHidden:YES];
                
                [self.mainImageView  setImage:[UIImage imageWithContentsOfFile:p.mediaPath]];
            }
            else
            {
                //activity indicator starting here...
                [self.littleWheel startAnimating];
                [[NewsLoader sharedLoader] loadMediaFileForNews:dOb];
                [NewsLoader sharedLoader].delegate = self;
            }
            
        }
        // else if ([dOb isKindOfClass:<#(__unsafe_unretained Class)#>])
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)initWithDetailedObject:(id)dOb
{
    detailedObject = dOb;
    
}











#pragma mark - delegate
-(void)newsLoaderDidLoadFile
{
    [self viewDidLoad];
    //    [self.view reloadInputViews];
}

-(void)noChange
{
    NSLog(@"detail vc got a notice that the data modle has no change...");
}

@end
