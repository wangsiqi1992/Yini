//
//  UserActivityProfileCell.m
//  Yini
//
//  Created by siqi wang on 12-8-7.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "UserActivityProfileCell.h"

@implementation UserActivityProfileCell
@synthesize profilePicView;
@synthesize nameLabel;

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

-(void)setUser:(BWUser *)user
{
    self.nameLabel.text = user.displayName;
    if ([[NSFileManager defaultManager] fileExistsAtPath:user.profilePicLocalPath])
    {
        self.profilePicView.image = [UIImage imageWithContentsOfFile:user.profilePicLocalPath];
    }
    
}




















@end
