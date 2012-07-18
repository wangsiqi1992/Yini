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
@synthesize newsType, lastModifiedDate, filename, createdDate, newsName;


-(id)initWithMetadataPath:(NSString *)path
{
    DBMetadata *d = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    self.filename = d.filename;
    self.lastModifiedDate = d.lastModifiedDate;
    self.newsType = [self newsTypeForExtension:[d.path pathExtension]];
    self.createdDate = d.clientMtime;
    
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
    [aCoder encodeObject:self.createdDate forKey:@"createdDate"];
    [aCoder encodeObject:self.newsName forKey:@"newsName"];

}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.newsType = [aDecoder decodeIntegerForKey:@"newsType"];
        self.lastModifiedDate = [aDecoder decodeObjectForKey:@"lastModifiedDate"];
        self.filename = [aDecoder decodeObjectForKey:@"filename"];
        self.createdDate = [aDecoder decodeObjectForKey:@"createdDate"];
        self.newsName = [aDecoder decodeObjectForKey:@"newsName"];
    }

    
    return self;
}

+(NSArray*)photoExtensions
{
    
    return [[NSArray alloc]initWithObjects:@"jpg", @"png", @"gif", nil];
}


+(NSArray*)videoExtensions
{
    return [[NSArray alloc]initWithObjects:@"mov", @"mp4", @"avi", nil];

}


+(NSArray*)articleExtensions
{
    return [[NSArray alloc]initWithObjects:@"rtf", @"txt", @"plist", nil];

}





















#pragma mark - private helper

-(int)newsTypeForExtension:(NSString*)extension
{
    extension = [extension lowercaseString];
    for (NSString *s in [WSQNews photoExtensions]) {
        if ([extension isEqualToString:s]) {
            return WSQPhoto;
        }
    }
    for (NSString *s in [WSQNews videoExtensions]) {
        if ([extension isEqualToString:s]) {
            return WSQVideo;
        }
    }
    for (NSString *s in [WSQNews articleExtensions]) {
        if ([extension isEqualToString:s]) {
            return WSQArticle;
        }
    }
    
    return nil;
    
}










































@end
