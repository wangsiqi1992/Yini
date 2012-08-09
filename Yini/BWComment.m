//
//  BWComment.m
//  Yini
//
//  Created by siqi wang on 12-7-20.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWComment.h"

@implementation BWComment
@synthesize createdDate, author, commentString;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.createdDate = [aDecoder decodeObjectForKey:@"createdDate"];
    self.commentString = [aDecoder decodeObjectForKey:@"commentString"];
    self.author = [aDecoder decodeObjectForKey:@"author"];
    return self;
}

-(id)initWithAuthor:(BWUser*)theAuthor commentString:(NSString*)theCommentString
{
    self.author = theAuthor;
    self.commentString = theCommentString;
    self.createdDate = [NSDate date];
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.createdDate forKey:@"createdDate"];
    [aCoder encodeObject:self.commentString forKey:@"commentString"];
    [aCoder encodeObject:self.author forKey:@"author"];
}




-(NSString*)ageDescription
{

    return [BWAgeCalculator describeDate:self.createdDate];
    

}
    





















@end
