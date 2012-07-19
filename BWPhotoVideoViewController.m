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
@synthesize littleWheelForNewsNameTextField;
@synthesize mainImageView;
@synthesize newsNameTextField;
@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //sub views
    scrollView.contentInset=UIEdgeInsetsMake(100.0,0.0,44.0,0.0);
    [self registerForKeyboardNotifications];
    newsNameTextField.delegate = self;
    UITapGestureRecognizer *taoCon = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:taoCon];
    loader = [NewsLoader sharedLoader];
    
    [self configureViewForDetailObject];
    
    

}



-(void)configureViewForDetailObject
{
    
    WSQNews *n = (WSQNews *)detailedObject;
    NSString *dobSnp = n.mainMediaSysFileFullPath;
    if ([[NSFileManager defaultManager] fileExistsAtPath:dobSnp]) {
        detailedObject = [NSKeyedUnarchiver unarchiveObjectWithFile:dobSnp];
        
    }

    WSQNews* dOb = (WSQNews*)detailedObject;

    
    if (dOb) {
        if (dOb.newsType == WSQPhoto)
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
    if ([dOb isKindOfClass:[WSQNews class]])
    {

        detailedObject = dOb;

    }

}




#pragma mark - subview managment
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeTextField.frame.origin.y-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(100.0, 0.0, 0.0, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}




-(void)dismissKeyboard
{
    [activeTextField resignFirstResponder];

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    //place holder text...check
    if (textField == newsNameTextField) {
        if (textField.text != detailedObject.newsName) {
            detailedObject.newsName = textField.text;
            [littleWheelForNewsNameTextField startAnimating];
            [loader saveNewsObject:detailedObject];
            loader.delegate = self;
        }

    }
    //get the text and save it here...
    
    return YES;
}





#pragma mark - delegate
-(void)newsLoaderDidLoadFile
{
    [self configureViewForDetailObject];
}

-(void)noChange
{
    NSLog(@"detail vc got a notice that the data modle has no change...");
}

-(void)saveNewsObjectSucceed
{
    [littleWheelForNewsNameTextField stopAnimating];
    [self configureViewForDetailObject];
}

@end
