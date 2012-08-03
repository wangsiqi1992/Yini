//
//  UISearchBar+TextColor.m
//  socioville
//
//  Created by Valentin Filip on 09.04.2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import "UISearchBar+TextColor.h"

@implementation UISearchBar (TextColor)

- (UITextField *)field {
    // HACK: This may not work in future iOS versions
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            return (UITextField *)subview;
        }
    }
    return nil;
}

- (UIColor *)textColor {
    return self.field.textColor;
}

- (void)setTextColor:(UIColor *)color {
    self.field.textColor = color;
}

@end
