//
//  BWActivityComent.h
//  Yini
//
//  Created by siqi wang on 12-8-7.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWActivity.h"
#import "WSQNews.h"

@interface BWActivityComent : BWActivity

@property (nonatomic, strong) NSString *newsSysNamePath;
@property (nonatomic, strong) NSString *userDiscription;
-(id)initWithNewsSysNamePath:(NSString*)namePath;



@end
