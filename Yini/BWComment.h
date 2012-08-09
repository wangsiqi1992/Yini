//
//  BWComment.h
//  Yini
//
//  Created by siqi wang on 12-7-20.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWUser.h"
#import "BWAgeCalculator.h"
@interface BWComment : NSObject<NSCoding>

@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) BWUser *author;
@property (nonatomic, strong) NSString *commentString;
-(id)initWithAuthor:(BWUser*)theAuthor commentString:(NSString*)theCommentString;

-(NSString*)ageDescription;


@end
