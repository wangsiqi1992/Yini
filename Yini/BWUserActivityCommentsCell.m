//
//  BWUserActivityCommentsCell.m
//  Yini
//
//  Created by siqi wang on 12-8-7.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWUserActivityCommentsCell.h"

@implementation BWUserActivityCommentsCell
@synthesize profilePicView;
@synthesize nameLable;
@synthesize cotentsLabel;
@synthesize dateDesctiption;
@synthesize acti;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setActi:(BWActivityComent *)activity
{
    acti = activity;
    self.nameLable.text = acti.owner.displayName;
    self.cotentsLabel.text = acti.userDiscription;
    self.dateDesctiption.text = [BWAgeCalculator describeDate:acti.date];
    self.profilePicView.image = [[BWImageStroe sharedStore] userProfileViewWithUserDisplayName:acti.owner.displayName];
    
}

@end
