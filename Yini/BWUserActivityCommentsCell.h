//
//  BWUserActivityCommentsCell.h
//  Yini
//
//  Created by siqi wang on 12-8-7.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWActivityComent.h"
#import "BWAgeCalculator.h"
#import "BWImageStroe.h"


@interface BWUserActivityCommentsCell : UITableViewCell
{
    BWActivityComent *acti;
}
@property (strong, nonatomic) IBOutlet UIImageView *profilePicView;
@property (strong, nonatomic) IBOutlet UILabel *nameLable;
@property (strong, nonatomic) IBOutlet UILabel *cotentsLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateDesctiption;

@property (strong, nonatomic) BWActivityComent *acti;

//-(void)setActi:(BWActivityComent*)activity;

@end
