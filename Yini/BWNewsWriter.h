//
//  BWNewsWriter.h
//  Yini
//
//  Created by siqi wang on 12-8-7.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsLoader.h"
#import "BWMyLordActivityWriter.h"

@interface BWNewsWriter : NSObject<NewsLoaderDelegate, WSQFileUploaderDelegate>
{
    NSString *fileName;
    NSDictionary *pendingAtrributes;
    id news;
    
}



+(BWNewsWriter*)sharedWriter;
-(BOOL)composePhotoNewsWithPhoto:(UIImage*)image attributes:(NSDictionary*)attributes;

@end






