//
//  MenuItem.m
//  socioville
//
//  Created by Valentin Filip on 10.04.2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

@synthesize name, image, imageName, eventCount;

+ (MenuItem *)itemWithData:(NSDictionary *)data {
    MenuItem *item = [[MenuItem alloc] init];
    item.name = [data objectForKey:@"name"];
    item.eventCount = [data objectForKey:@"eventCount"];
    item.imageName = [data objectForKey:@"imageName"];
    if (item.imageName) {
        item.image = [UIImage imageNamed:item.imageName];
    }
    
    return item;
}

@end
