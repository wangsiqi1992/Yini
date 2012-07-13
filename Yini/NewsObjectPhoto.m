//
//  NewsObjectPhoto.m
//  socioville
//
//  Created by Siqi Wang on 12-6-15.
//  Copyright (c) 2012年 Universitatea Babeș-Bolyai. All rights reserved.
//

#import "NewsObjectPhoto.h"


@implementation NewsObjectPhoto
@synthesize createdDate, path, thumbnailPath;

-(NewsObjectPhoto*)loadPhoto
{
    return self;
}

//-(id)initPhotoNewsWith:(WSQNews *)news
//{
//    self = (NewsObjectPhoto*) news;
//    
//    return self;
//}

-(id)initWithDBobject:(DBMetadata *)metadata
{
    self = [super initWithDBobject:metadata];
    
    self.createdDate = metadata.clientMtime;

    self.newsType = WSQPhoto;
    
    self.path = metadata.path;
    
    //implement thumbnail path here!!!!

    NSArray *pa = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dPath = [pa objectAtIndex:0];
    
    NSArray *parts = [path componentsSeparatedByString:@"/"];
    NSString *name = [parts objectAtIndex:[parts count]-1];
    NSString *localPath = [dPath stringByAppendingPathComponent:@"News/thumbnail"];
    
    
    NSString *localDic = [localPath stringByAppendingPathComponent:name];
    thumbnailPath = localDic;
    
    
    //write to file plist.....~!!!
    
    
    return self;    
}

-(id)initWithName:(NSString *)name
{
    
    
    return self;
}

-(id)initWithSysFilePath:(NSString *)path
{
    self = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.createdDate forKey:@"createdDate"];
    [aCoder encodeObject:self.path forKey:@"path"];
    [aCoder encodeObject:self.thumbnailPath forKey:@"thumbnailPath"];
    
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.createdDate = [aDecoder decodeObjectForKey:@"createdDate"];
        self.path = [aDecoder decodeObjectForKey:@"path"];
        self.thumbnailPath = [aDecoder decodeObjectForKey:@"thumbnailPath"];

    }
    return self;
}




@end
