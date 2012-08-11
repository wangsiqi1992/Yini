//
//  CardCellCell.m
//  socioville
//
//  Created by Tope on 17/04/2012.
//  Copyright (c) 2012 Universitatea Babeș-Bolyai. All rights reserved.
//

#import "CardCell.h"
#import "BWAppDelegate.h"

@implementation CardCell

@synthesize playImageView, commentButton, likeButton, label, userPic, majorImage, littleWheel;

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

    UIImage* commentBg = [[BWAppDelegate instance].colorSwitcher getImageWithName:@"fb_comment.png"];
    [commentButton setImage:commentBg forState:UIControlStateNormal];
    
    UIImage* likeBG = [[BWAppDelegate instance].colorSwitcher getImageWithName:@"fb_like.png"];
    [likeButton setImage:likeBG forState:UIControlStateNormal];
    
    [playImageView setImage:[[BWAppDelegate instance].colorSwitcher getImageWithName:@"play-big.png"]];
    // Configure the view for the selected state    
    
}


-(id)initWithNews:(id)news
{
    if ([news isKindOfClass:[WSQNews class]]) {
    
        if ([news newsType] == WSQPhoto) {
            NewsObjectPhoto *n = (NewsObjectPhoto*) news;
            
            [[self littleWheel] stopAnimating];
            [self.littleWheel setHidesWhenStopped:YES];
//            [self.littleWheel setHidden:YES];
            
            //init a photo cell here...
            [self.playImageView removeFromSuperview];
            label.text = n.newsName;
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:[n thumbnailPath]])
            {
                self.majorImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[n thumbnailPath]]];
                
            }
            else {
//                [[NewsLoader sharedLoader] loadThumbnailWithPath:n.dbpath];
                [self.littleWheel startAnimating];
//                [self.littleWheel setHidden:NO];
                self.majorImage.image = nil;
            }
            if (n.author.displayName)
            {
                self.userPic.image = [[BWImageStroe sharedStore] userProfileViewWithUserDisplayName:n.author.displayName];
            }
            else
            {
                self.userPic.image = [UIImage imageNamed:@"user_1.png"];
            }
            
            
            
        }
    }
    return self;
    
}








@end
