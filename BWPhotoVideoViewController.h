//
//  BWPhotoVideoViewController.h
//  Yini
//
//  Created by siqi wang on 12-7-16.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsObjectPhoto.h"
#import "NewsLoader.h"
#import "BWAppDelegate.h"
#import "BWComment.h"
#import "BWLord.h"
#import "UIPullToReloadHeaderView.h"
#import "BWNewsWriter.h"
#import "BWImageStroe.h"
#import "BWActivityLoaderViewController.h"


@interface BWPhotoVideoViewController : UIViewController<NewsLoaderDelegate, BWNewsWriterDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    NewsLoader *loader;
    WSQNews *detailedObject;
    UITextField *activeTextField;
    BWComment *appendingComment;
    NSString *appendingNewsName;
    UITapGestureRecognizer *taoCon;
    
    BOOL checkForRefresh;
    BOOL savingNewsName;
    BOOL savingComment;
}
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *littleWheel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *littleWheelForNewsNameTextField;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *commentUploadingLittleWheel;
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;
@property (strong, nonatomic) IBOutlet UITextField *newsNameTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *commentsTableView;
@property (strong, nonatomic) IBOutlet UITextField *commentTextField;
@property (strong, nonatomic) IBOutlet UIImageView *myLordProfilePic;

@property(nonatomic, readonly) UIPullToReloadHeaderView *pullToReloadHeaderView;

-(void)initWithDetailedObject:(id)dOb;
@end
