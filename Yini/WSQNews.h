//
//  WSQNews.h
//  socioville
//
//  Created by Siqi Wang on 12-6-15.
//  Copyright (c) 2012年 Universitatea Babeș-Bolyai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>
//#import "NewsObjectPhoto.h"

enum WSQNewsTypes {
    WSQPhoto,
    WSQVideo,
    WSQArticle
};

@interface WSQNews : NSObject<NSCoding>




-(id)initWithDBobject:(DBMetadata*)metadata;
//-(id)initWithName:(NSString*)name;
-(id)initWithSysFilePath:(NSString *)path;


@property (nonatomic) int newsType;
@property (nonatomic, strong) NSDate *lastModifiedDate;
@property (nonatomic, strong) NSString *filename;

@end
