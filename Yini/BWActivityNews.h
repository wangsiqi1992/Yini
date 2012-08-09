//
//  BWActivityNews.h
//  Yini
//
//  Created by siqi wang on 12-8-6.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWActivity.h"

@interface BWActivityNews : BWActivity



@property (nonatomic, strong) NSString *newsSysNamePath;
@property (nonatomic, strong) NSString *userDiscription;
-(id)initWithNewsSysNamePath:(NSString*)namePath;

@end
