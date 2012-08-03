//
//  ColourSwitcher.m
//  prolific
//
//  Created by Tope on 21/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ColorSwitcher.h"

@implementation ColorSwitcher

@synthesize modifiedImages, hue, saturation, baseHue, textColor;

-(id)init
{
    self = [super init];
    
    if(self)
    {
        hue = 0;
        saturation = 1;  
        baseHue = 161.0; //degrees
        
        textColor = [UIColor colorWithHue:baseHue/360.0 saturation:0.67 brightness:0.72 alpha:1.0];
    }
    
    return self;
}

-(void)configureAppWithHue:(float)theHue andSaturation:(float)theSaturation
{
    self.hue = theHue;
    self.saturation = theSaturation;
    
    float oneRadianInDegrees = 57.2957795;
    
    float newHue = (int)(baseHue + (theHue * oneRadianInDegrees)) % 360;
    
    newHue = newHue / 360.0;
    
    textColor = [UIColor colorWithHue:newHue saturation:0.67 brightness:0.72 alpha:1.0];
}


-(UIImage*)processImage:(UIImage*)originalImage withKey:(NSString*)key
{

    UIImage* existingImage = [modifiedImages objectForKey:key];
    
    if(existingImage)
    {
        return existingImage;
    }
    else if (hue == 0 && saturation == 1)
    {
        return originalImage;
    }
    
    
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
    
    [modifiedImages setObject:processed forKey:key];
    
    return processed;

}



-(UIImage*)getImageWithName:(NSString*)imageName
{
    UIImage* image = [UIImage imageNamed:imageName];
    
    return [self processImage:image withKey:imageName];
}



@end
