//
//  DataSource.m
//  socioville
//
//  Created by Valentin Filip on 10.04.2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import "DataSource.h"
#import "MenuItem.h"

@implementation DataSource

@synthesize items;

+ (DataSource *)dataSource {
    DataSource *source = [[DataSource alloc] init];
    
    NSArray *rawItems = [NSArray arrayWithObjects:
                           [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Home", @"name"
                            , @"menu-home.png", @"imageName"
                            , nil]
                         , [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Popular", @"name"
                            , @"menu-eye.png", @"imageName"
                            , nil]
                         , [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Around me", @"name"
                            , @"menu-pin.png", @"imageName"
                            , [NSNumber numberWithInt:8], @"eventCount"
                            , nil]
                         , [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Recent", @"name"
                            , @"menu-clock.png", @"imageName"
                            , [NSNumber numberWithInt:11], @"eventCount"
                            , nil]
                         , [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Friends", @"name"
                            , @"menu-friends.png", @"imageName"
                            , nil]                         
                         , nil];
    NSMutableArray *newItems = [NSMutableArray array];
    for (NSDictionary *item in rawItems) {
        [newItems addObject:[MenuItem itemWithData:item]];
    }
    source.items = [NSArray arrayWithArray:newItems];
    
    return source;
}

@end
