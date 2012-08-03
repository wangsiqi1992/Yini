//
//  MasterViewController.h
//  socioville
//
//  Created by Valentin Filip on 4/2/12.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardCell.h"
#import "NewsLoader.h"
#import "PullRefreshTableViewController.h"
#import "BWPhotoVideoViewController.h"
#import "BWLord.h"
#import "BWMyLordInfoViewController.h"
#import <DropboxSDK/DropboxSDK.h>


@interface MasterViewController :PullRefreshTableViewController <NewsLoaderDelegate>


{
    
    UIActivityIndicatorView *actIndi;
    NewsLoader *loader;
    NSArray *datasource;
    NSInteger selected;
      
}

//@property (strong, nonatomic) DetailViewController *detailViewController;

@end
