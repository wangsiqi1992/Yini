//
//  BWUserActivityNewsCell.h
//  Yini
//
//  Created by siqi wang on 12-8-7.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsObjectPhoto.h"
#import "BWActivityNews.h"
#import "BWImageStroe.h"

@interface BWUserActivityNewsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *newsNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *dateDescription;



-(void)setNewsActivity:(BWActivityNews*)activity;


@end
