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
    NSDate *startDate = self.createdDate;
    NSDate *endDate = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSYearCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:startDate
                                                  toDate:endDate options:0];
    NSInteger year = [components year];
    NSInteger week = [components week];
    NSInteger days = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    if (year != 0) {
        if (year > 1) {
            return [NSString stringWithFormat:@"%i years", year];
            
        }
        else
        {
            return [NSString stringWithFormat:@"%i year", year];
            
        }
    }
    else if (week != 0) {
        if (week > 1) {
            return [NSString stringWithFormat:@"%i weeks", week];
            
        }
        else
        {
            return [NSString stringWithFormat:@"%i week", week];
            
        }
    }
    else if (days != 0) {
        if (days > 1) {
            return [NSString stringWithFormat:@"%i days", days];
            
        }
        else
        {
            return [NSString stringWithFormat:@"%i day", days];
            
        }
    }
    else if (hour != 0) {
        if (hour > 1) {
            return [NSString stringWithFormat:@"%i hours", hour];
            
        }
        else
        {
            return [NSString stringWithFormat:@"%i hour", hour];
            
        }
    }
    else if (minute != 0) {
        if (minute > 1) {
            return [NSString stringWithFormat:@"%i minutes", minute];
            
        }
        else
        {
            return [NSString stringWithFormat:@"%i minute", minute];
            
        }
    }
    else// if (second != 0) {
    {
        if (second > 1) {
            return [NSString stringWithFormat:@"%i seconds", second];
            
        }
        else
        {
            return [NSString stringWithFormat:@"%i second", second];
            
        }
    }
    

}
    





















@end
