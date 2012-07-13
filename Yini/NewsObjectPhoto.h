//
//  NewsObjectPhoto.h
//  socioville
//
//  Created by Siqi Wang on 12-6-15.
//  Copyright (c) 2012年 Universitatea Babeș-Bolyai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSQNews.h"

@interface NewsObjectPhoto : WSQNews<NSCoding>
{
    //NewsObjectPhoto *newsP;
    
}


@property (nonatomic, strong) NSString *dbpath;
@property (nonatomic, strong) NSString *thumbnailPath;


-(NewsObjectPhoto*)loadPhoto;
//-(id)initPhotoNewsWith:(WSQNews*)news;
-(id)initWithDBobject:(DBMetadata *)metadata;
//-(id)initWithName:(NSString *)name;
-(id)initWithSysFilePath:(NSString *)path;
@end
