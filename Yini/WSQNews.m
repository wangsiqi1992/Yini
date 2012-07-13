//
//  WSQNews.m
//  socioville
//
//  Created by Siqi Wang on 12-6-15.
//  Copyright (c) 2012年 Universitatea Babeș-Bolyai. All rights reserved.
//

#import "WSQNews.h"
//static NSString *newsFileDirec = @"News/systemFile/individual";

@implementation WSQNews
@synthesize newsType, lastModifiedDate, filename;
-(id)initWithDBobject:(DBMetadata *)metadata
{

    //check the trype!
    //return the correct news...
    
    //implement comments here and all the things related to plist

    self.filename = metadata.filename;
    self.lastModifiedDate = metadata.lastModifiedDate;
   // NewsObjectPhoto *photo;
    
    
    return self;
    
}

-(id)initWithName:(NSString *)name
{
//    NSFileManager *fm = [NSFileManager defaultManager];
//    if (![fm fileExistsAtPath:[newsFileDirec stringByAppendingPathComponent:name]]) {
//        //news system file not exist, do nothing....!
//    }
//ASK WSQ FILE MANAGER HERE?!
    
    return self;
}

-(id)initWithSysFilePath:(NSString *)path
{
    self = [NSKeyedUnarchiver unarchiveObjectWithFile:path];

    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.newsType forKey:@"newsType"];
    [aCoder encodeObject:self.lastModifiedDate forKey:@"lastModifiedDate"];
    [aCoder encodeObject:self.filename forKey:@"filename"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.newsType = [aDecoder decodeObjectForKey:@"newsType"];
        self.lastModifiedDate = [aDecoder decodeObjectForKey:@"lastModifiedDate"];
        self.filename = [aDecoder decodeObjectForKey:@"filename"];
    }

    
    return self;
}

@end
