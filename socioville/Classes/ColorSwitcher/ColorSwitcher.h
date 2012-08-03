//
//  ColourSwitcher.h
//  prolific
//
//  Created by Tope on 21/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorSwitcher : NSObject

-(id)init;

@property (nonatomic, retain) NSMutableDictionary* modifiedImages;

@property (nonatomic, assign) float hue;

@property (nonatomic, assign) float saturation;

@property (nonatomic, readonly) float baseHue;

@property (nonatomic, strong) UIColor* textColor;

-(UIImage*)getImageWithName:(NSString*)imageName;

-(UIImage*)processImage:(UIImage*)originalImage withKey:(NSString*)key;

-(void)configureAppWithHue:(float)theHue andSaturation:(float)theSaturation;

@end
