//
//  UISearchBar+TextColor.h
//  socioville
//
//  Created by Valentin Filip on 09.04.2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (TextColor)

- (UITextField *)field;
- (UIColor *)textColor;
- (void)setTextColor:(UIColor *)color;

@end
