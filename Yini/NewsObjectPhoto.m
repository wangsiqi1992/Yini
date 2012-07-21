//
//  NewsObjectPhoto.m
//  socioville
//
//  Created by Siqi Wang on 12-6-15.
//  Copyright (c) 2012年 Universitatea Babeș-Bolyai. All rights reserved.
//

#import "NewsObjectPhoto.h"


@implementation NewsObjectPhoto
@synthesize dbpath, thumbnailPath;

-(NewsObjectPhoto*)loadPhoto
{
    return self;
}



-(id)initWithMetadataPath:(NSString *)path
{
    self = [super initWithMetadataPath:path];
    DBMetadata *d = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    self.dbpath = d.path;
    WSQFileHelper* helper = [WSQFileHelper sharedHelper];
    self.thumbnailPath = [helper thumbnailPathForNewsNamePath:[helper pathNameFromDBPath:self.dbpath]];
//    self.mediaPath = [helper directoryForNewsMediaFile:[helper pathNameFromDBPath:self.dbpath]];
    return self;
    
}


-(id)initWithSysFilePath:(NSString *)path
{
    //no super init here, file contain everything...
    self = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.dbpath forKey:@"dbpath"];
    [aCoder encodeObject:self.thumbnailPath forKey:@"thumbnailPath"];
//    [aCoder encodeObject:self.mediaPath forKey:@"mediaPath"];

    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.dbpath = [aDecoder decodeObjectForKey:@"dbpath"];
        self.thumbnailPath = [aDecoder decodeObjectForKey:@"thumbnailPath"];
//        self.mediaPath = [aDecoder decodeObjectForKey:@"mediaPath"];


    }
    return self;
}

-(NSString*)mediaPath
{
    WSQFileHelper* helper = [WSQFileHelper sharedHelper];
    return [helper directoryForNewsMediaFile:[helper pathNameFromDBPath:self.dbpath]];
}















@end
