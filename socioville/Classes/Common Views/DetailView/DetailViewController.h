//
//  DetailViewController.h
//  socioville
//
//  Created by Valentin Filip on 4/2/12.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsObjectPhoto.h"
#import "NewsLoader.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, NewsLoaderDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UIImageView *newsMediaImageView;
@property (weak, nonatomic) IBOutlet UITextField *newsNameTextField;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton* playButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *littleWheel;

- (IBAction)playMovie:(id)sender;


@end
