//
//  UIElementsViewController.m
//  socioville
//
//  Created by Valentin Filip on 4/3/12.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import "UIElementsViewController.h"
#import "RCSwitchOnOff.h"
#import "ADVPopoverProgressBar.h"
#import "STSegmentedControl.h"
#import "SampleSegment.h"
#import "BWAppDelegate.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;

CGFloat animatedDistance;

@interface UIElementsViewController ()

@property (nonatomic, strong) ADVPopoverProgressBar *progressBar;

@end

@implementation UIElementsViewController
@synthesize scrollView, colorButton, colorButtonSelected;

@synthesize progressBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[[BWAppDelegate instance].colorSwitcher getImageWithName:@"background.png"]];
        
    RCSwitchOnOff* onSwitch = [[RCSwitchOnOff alloc] initWithFrame:CGRectMake(72, 20, 76, 42)];
    [onSwitch setOn:YES];    
    [self.scrollView addSubview:onSwitch];
    
    RCSwitchOnOff* offSwitch = [[RCSwitchOnOff alloc] initWithFrame:CGRectMake(176, 20, 76, 42)];
    [offSwitch setOn:NO];    
    [self.scrollView addSubview:offSwitch];
    
    self.progressBar = [[ADVPopoverProgressBar alloc] initWithFrame:CGRectMake(20, 68, 280, 24) andProgressBarColor:ADVProgressBarBlue];
    [progressBar setProgress:0.5];
    [self.scrollView addSubview:self.progressBar];
    
    NSArray *objects = [NSArray arrayWithObjects:@"Yes", @"No", @"Maybe", nil];
    /*
    STSegmentedControl *segment = [[STSegmentedControl alloc] initWithItems:objects];
	segment.frame = CGRectMake(35, 175, 250, 45);
	segment.selectedSegmentIndex = 1;
	segment.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    */
    
    SampleSegment *segment = [[SampleSegment alloc] init];
    segment.titles = objects;
    segment.frame = CGRectMake(35, 165, 250, 45);
    
    [colorButton setBackgroundImage:[[BWAppDelegate instance].colorSwitcher getImageWithName:@"button-green.png"] forState:UIControlStateNormal];
    
        
    [colorButtonSelected setBackgroundImage:[[BWAppDelegate instance].colorSwitcher getImageWithName:@"button-green-pressed.png"] forState:UIControlStateNormal];
     
	[self.scrollView addSubview:segment];
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)sliderValueChanged:(id)sender {    
    if([sender isKindOfClass:[UISlider class]]) {
        UISlider *s = (UISlider*)sender;
        
        if(s.value >= 0.0 && s.value <= 1.0) {
            [progressBar setProgress:s.value];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
        midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
        (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = 
        [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
        
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
