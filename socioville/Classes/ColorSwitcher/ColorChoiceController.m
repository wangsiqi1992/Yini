//
//  ColorChoiceController.m
//  prolific
//
//  Created by Tope on 12/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ColorChoiceController.h"
#import "BWAppDelegate.h"


@implementation ColorChoiceController
@synthesize lblSaturation;
@synthesize lblHue;

@synthesize imageView, hueSlider, saturationSlider, image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.image = [UIImage imageNamed:@"button-green.png"];
    
    [imageView setImage:image];
    [self changeValue:nil];
    [super viewDidLoad];
    
    


    
}

-(void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
}


-(IBAction)changeValue:(UISlider *)sender {
    self.lblHue.text = [NSString stringWithFormat:@"%0.4f", hueSlider.value];
    self.lblSaturation.text = [NSString stringWithFormat:@"%0.4f", saturationSlider.value];
    UIImage* modifiedImage = [self modifyImage:image WithHue:hueSlider.value andSaturation:saturationSlider.value];
    
    [imageView setImage:modifiedImage];
}


-(UIImage*)modifyImage:(UIImage*)originalImage WithHue:(float)hue andSaturation:(float)saturation
{

    CIImage *beginImage = [CIImage imageWithData:UIImagePNGRepresentation(originalImage)];
    
    CIContext* context = [CIContext contextWithOptions:nil];
    
    CIFilter* hueFilter = [CIFilter filterWithName:@"CIHueAdjust" keysAndValues:kCIInputImageKey, beginImage, @"inputAngle", [NSNumber numberWithFloat:hue], nil];
    
    CIImage *outputImage = [hueFilter outputImage];
    
    CIFilter* saturationFilter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, outputImage, @"inputSaturation", [NSNumber numberWithFloat:saturation], nil];
    
    outputImage = [saturationFilter outputImage];
    
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    
    UIImage *processed;
    if ( [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0 )
    {
        processed = [UIImage imageWithCGImage:cgimg scale:2.0 orientation:UIImageOrientationUp]; 
    }
    else
    {
        processed = [UIImage imageWithCGImage:cgimg]; 
    }
    
    CGImageRelease(cgimg);
    
   
    return processed;

}

-(IBAction)doneModifying:(id)sender
{
    [[BWAppDelegate instance].colorSwitcher configureAppWithHue:hueSlider.value andSaturation:saturationSlider.value];
    
    [[BWAppDelegate instance] customizeGlobalTheme];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) 
    {
        [[BWAppDelegate instance] customizeiPadTheme];
        
    }

    [self performSegueWithIdentifier:@"main" sender:self];
    

}

- (void)viewDidUnload
{
    [self setLblHue:nil];
    [self setLblSaturation:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
