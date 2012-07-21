//
//  WSQNews.h
//  socioville
//
//  Created by Siqi Wang on 12-6-15.
//  Copyright (c) 2012年 Universitatea Babeș-Bolyai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>
#import "WSQFileHelper.h"
#import "BWComment.h"

//#import "NewsObjectPhoto.h"

enum WSQNewsTypes {
    WSQPhoto,
    WSQVideo,
    WSQArticle
};

@interface WSQNews : NSObject<NSCoding>

+(NSArray*)photoExtensions;
+(NSArray*)videoExtensions;
+(NSArray*)articleExtensions;



-(id)initWithMetadataPath:(NSString*)path;
-(id)initWithSysFilePath:(NSString *)path;


-(NSString*)sysFileFullPath;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic) int newsType;
@property (nonatomic, strong) NSDate *lastModifiedDate;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSString *newsName;
@property (nonatomic, strong) NSArray *commentsArray;
@property (nonatomic, strong) NSString *namePath;




@end
