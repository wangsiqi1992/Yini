//
//  BWAgeCalculator.m
//  Yini
//
//  Created by siqi wang on 12-8-8.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWAgeCalculator.h"

@implementation BWAgeCalculator

+(NSString*)describeDate:(NSDate *)date
{
    NSDate *startDate = date;
    NSDate *endDate = [NSDate date];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    
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
            if (year > 5)
            {
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                
                
                NSString *formattedDateString = [dateFormatter stringFromDate:date];
                return formattedDateString;
            }
            return [NSString stringWithFormat:@"%i years ago", year];
            
        }
        else
        {
            return [NSString stringWithFormat:@"%i year ago", year];
            
        }
    }
    else if (week != 0) {
        if (week > 1) {
            if (week > 5)
            {
                [dateFormatter setDateFormat:@"MM-dd"];
                
                
                NSString *formattedDateString = [dateFormatter stringFromDate:date];
                return formattedDateString;
            }
            
            return [NSString stringWithFormat:@"%i weeks ago", week];
            
        }
        else
        {
            return [NSString stringWithFormat:@"%i week ago", week];
            
        }
    }
    else if (days != 0) {
        if (days > 1) {
            if (days > 5)
            {
                [dateFormatter setDateFormat:@"MM-dd 'at' HH:mm"];
                
                
                NSString *formattedDateString = [dateFormatter stringFromDate:date];
                return formattedDateString;
            }
            return [NSString stringWithFormat:@"%i days ago", days];
            
        }
        else
        {
            return [NSString stringWithFormat:@"%i day ago", days];
            
        }
    }
    else if (hour != 0) {
        if (hour > 1) {
            if (hour > 10)
            {
                [dateFormatter setDateFormat:@"'Today at' HH:mm:ss"];
                
                
                NSString *formattedDateString = [dateFormatter stringFromDate:date];
                return formattedDateString;
            }
            return [NSString stringWithFormat:@"%i hours ago", hour];
            
        }
        else
        {
            return [NSString stringWithFormat:@"%i hour ago", hour];
            
        }
    }
    else if (minute != 0) {
        if (minute > 1) {
            if (minute > 40)
            {
                [dateFormatter setDateFormat:@"HH:mm:ss"];
                
                
                NSString *formattedDateString = [dateFormatter stringFromDate:date];
                return formattedDateString;
            }
            return [NSString stringWithFormat:@"%i minutes ago", minute];
            
        }
        else
        {
            return [NSString stringWithFormat:@"%i minute ago", minute];
            
        }
    }
    else// if (second != 0) {
    {
        if (second > 1) {
            return [NSString stringWithFormat:@"%i seconds ago", second];
            
        }
        else
        {
            return [NSString stringWithFormat:@"%i second ago", second];
            
        }
    }

}

@end
