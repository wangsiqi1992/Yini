//
//  DataSource.h
//  socioville
//
//  Created by Valentin Filip on 10.04.2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject

@property (nonatomic, strong) NSArray *items;

+ (DataSource *)dataSource;

@end
