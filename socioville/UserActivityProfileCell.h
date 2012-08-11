//
//  UserActivityProfileCell.h
//  Yini
//
//  Created by siqi wang on 12-8-7.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWUser.h"
#import "BWImageStroe.h"


@interface UserActivityProfileCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *profilePicView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
-(void)setUser:(BWUser*)user;//init here!!!


@end
