//
//  NoAnimPushSegue.m
//  socioville
//
//  Created by Valentin Filip on 09.04.2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import "NoAnimPushSegue.h"

@implementation NoAnimPushSegue

- (void)perform{
    UIViewController *dst = [self destinationViewController];
    UIViewController *src = [self sourceViewController];
    
    [src.navigationController pushViewController:dst animated:NO];    
}

@end
