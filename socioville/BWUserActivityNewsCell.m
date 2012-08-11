//
//  BWUserActivityNewsCell.m
//  Yini
//
//  Created by siqi wang on 12-8-7.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWUserActivityNewsCell.h"

@implementation BWUserActivityNewsCell
@synthesize mainImageView;
@synthesize nameLabel;
@synthesize newsNameLabel;
@synthesize dateDescription;

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

-(void)setNewsActivity:(BWActivityNews *)activity
{
    self.nameLabel.text = activity.userDiscription;
    self.dateDescription.text = [activity ageDescription];
    NSString *namePath = activity.newsSysNamePath;
    NSString *path = [[WSQFileHelper sharedHelper] directoryForNewsSysFile:namePath];
    WSQNews *news = [[WSQNews alloc] initWithSysFilePath:path];
    if (news.newsType == WSQPhoto) {
        NewsObjectPhoto *aNews = (NewsObjectPhoto*)news;
        self.mainImageView.image = [[BWImageStroe sharedStore] thumbnailImageWithDBPath:aNews.dbpath];
        
        self.newsNameLabel.text = aNews.newsName;
        
    }
}




























@end
