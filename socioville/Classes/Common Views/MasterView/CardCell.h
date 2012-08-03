//
//  CardCellCell.h
//  socioville
//
//  Created by Tope on 17/04/2012.
//  Copyright (c) 2012 Universitatea Babeș-Bolyai. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NewsObjectPhoto.h"
#import "NewsLoader.h"


@interface CardCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView* playImageView;

@property (nonatomic, weak) IBOutlet UIButton* commentButton;

@property (nonatomic, weak) IBOutlet UIButton* likeButton;

@property (nonatomic, weak) IBOutlet UILabel *label;

@property (nonatomic, strong) IBOutlet UIImageView *majorImage;

@property (nonatomic, weak) IBOutlet UIImageView *userPic;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *littleWheel;

//-(void)setLabelText:(NSString *)label withUserPic: (UIImage*)pic andMajorImage: (UIImage*)mPic;

-(id)initWithNews:(id)news;

@end
