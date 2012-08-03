//
//  MenuItem.h
//  socioville
//
//  Created by Valentin Filip on 10.04.2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject

@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *imageName;
@property (nonatomic, strong) UIImage   *image;
@property (nonatomic, strong) NSNumber  *eventCount;

+ (MenuItem *)itemWithData:(NSDictionary *)data;

@end
