//
//  NewsObjectPhoto.h
//  socioville
//
//  TO ADD A PROPERTY:
//  1. ADD PROPERTY AND SYNTHESIS IT
//  2. INIT WITH DB OBJECT IF IT IS RELATED
//  3. ADD TO ENCODE AND DECODE METHOD
//
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


-(NewsObjectPhoto*)loadPhoto;
//-(id)initPhotoNewsWith:(WSQNews*)news;
//-(id)initWithDBobject:(DBMetadata *)metadata;
//-(id)initWithName:(NSString *)name;
-(id)initWithSysFilePath:(NSString *)path;
-(NSString*)mediaPath;
-(NSString*)thumbnailPath;

@end
