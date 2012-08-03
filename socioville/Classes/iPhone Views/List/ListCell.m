//
//  ListCell.m
//  socioville
//
//  Created by Tope on 17/04/2012.
//  Copyright (c) 2012 Universitatea Babeș-Bolyai. All rights reserved.
//

#import "ListCell.h"
#import "BWAppDelegate.h"

@implementation ListCell
@synthesize titleLabel;


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

    [titleLabel setTextColor:[[BWAppDelegate instance].colorSwitcher textColor]];
    // Configure the view for the selected state
}

@end
