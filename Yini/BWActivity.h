//
//  BWActivity.h
//  Yini
//
//  Created by siqi wang on 12-8-6.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//
//  
//
//
//
//
//

#import <Foundation/Foundation.h>
#import "BWLord.h"
#import "BWAgeCalculator.h"
enum BWActivityType
{
    BWActivityTypeNews,
    BWActivityTypeLike,
    BWActivityTypeComment
    
};


@interface BWActivity : NSObject<NSCoding>


@property (nonatomic, strong) BWUser *owner;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic) NSInteger type;
@property (nonatomic, strong) NSArray *seenBy;
@property (nonatomic, strong) NSArray *relatedUsers;

-(id)initWithLord;// for any new activity created by my self, activity inited from file shouldnt call this method...


-(NSString*)ageDescription;







@end
