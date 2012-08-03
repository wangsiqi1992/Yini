//
//  ColorChoiceController.h
//  prolific
//
//  Created by Tope on 12/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorSwitcher.h"



@interface ColorChoiceController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UISlider *hueSlider;
@property (strong, nonatomic) IBOutlet UILabel *lblHue;

@property (nonatomic, weak) IBOutlet UISlider * saturationSlider;
@property (strong, nonatomic) IBOutlet UILabel *lblSaturation;

@property (nonatomic, strong) UIImage* image;

-(UIImage*)modifyImage:(UIImage*)originalImage WithHue:(float)hue andSaturation:(float)saturation;

-(IBAction)doneModifying:(id)sender;

//-(void)finishedLinkingDB;


@end
