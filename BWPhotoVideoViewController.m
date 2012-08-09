//
//  BWPhotoVideoViewController.m
//  Yini
//
//  Created by siqi wang on 12-7-16.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWPhotoVideoViewController.h"

@interface BWPhotoVideoViewController ()

@end

@implementation BWPhotoVideoViewController
@synthesize littleWheel;
@synthesize littleWheelForNewsNameTextField;
@synthesize commentUploadingLittleWheel;
@synthesize mainImageView;
@synthesize newsNameTextField;
@synthesize scrollView;
@synthesize commentsTableView;
@synthesize commentTextField;
@synthesize myLordProfilePic;
@synthesize pullToReloadHeaderView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //sub views
    scrollView.contentInset=UIEdgeInsetsMake(50,0.0,44.0,0.0);
    scrollView.contentSize = CGSizeMake(100, 800);
    [self registerForKeyboardNotifications];
    newsNameTextField.delegate = self;
    commentTextField.delegate = self;
    UITapGestureRecognizer *taoCon = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    taoCon.delegate = self;
    [self.view addGestureRecognizer:taoCon];
    loader = [NewsLoader sharedLoader];
    
    [self configureViewForDetailObject];
    self.commentsTableView.delegate = self;
    self.commentsTableView.dataSource = self;
    
    
    //try to implement the pull to refresh...
    pullToReloadHeaderView = [[UIPullToReloadHeaderView alloc] initWithFrame: CGRectMake(0.0f, 0.0f - self.commentsTableView.bounds.size.height,
																						 320.0f, self.commentsTableView.bounds.size.height)];
	[self.commentsTableView addSubview:pullToReloadHeaderView];
    
/*hack the full screen*/

//    UITapGestureRecognizer *pgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterFullScreenMode)];
//    [pgr setNumberOfTapsRequired:2];
//    [self.mainImageView addGestureRecognizer:pgr];
}



-(void)configureViewForDetailObject
{
    [self.commentUploadingLittleWheel stopAnimating];
    WSQNews *n = (WSQNews *)detailedObject;
    NSString *dobSnp = [n sysFileFullPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dobSnp]) {
        detailedObject = [NSKeyedUnarchiver unarchiveObjectWithFile:dobSnp];
        
    }
    
    [self.commentsTableView reloadData];
//    self.commentTextField.text = @"";
    self.myLordProfilePic.image = [UIImage imageWithContentsOfFile:[[BWLord myLord] profilePicLocalPath]];

    WSQNews* dOb = (WSQNews*)detailedObject;

    
    if (dOb) {
        if (dOb.newsType == WSQPhoto)
        {
            NewsObjectPhoto *p = (NewsObjectPhoto*) dOb;
            
            [self.littleWheel setHidesWhenStopped:YES];
            [self.littleWheel startAnimating];
            
            if (p.newsName)
            {
                self.newsNameTextField.placeholder = p.newsName;
                
            }
            else
            {
                self.newsNameTextField.placeholder = @"Please enter a name for this photo";
            }
            
            //            [self.playButton removeFromSuperview];
            //            [self.playButton setHidden:YES];
            [self.mainImageView setImage:nil];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:[p mediaPath]])
            {
                [self.littleWheel stopAnimating];
                [self.littleWheel setHidden:YES];
                
                [self.mainImageView  setImage:[UIImage imageWithContentsOfFile:[p mediaPath]]];
            }
            else
            {
                //activity indicator starting here...
                [self.littleWheel startAnimating];
                [[NewsLoader sharedLoader] loadMediaFileForNews:dOb];
                [NewsLoader sharedLoader].delegate = self;
            }
            
        }
        // else if ([dOb isKindOfClass:<#(__unsafe_unretained Class)#>])
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


/*hack the full screen*/

//-(void)enterFullScreenMode
//{
//    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 768, 1004)];
//    [mainImageView setCenter:CGPointMake(sv.frame.size.width/2, sv.frame.size.height/2)];
//    [sv addSubview:mainImageView];
//    [sv setHidden:FALSE];
//    [mainImageView setHidden:FALSE];
//    [self.view addSubview:sv];
//
//}
//
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
////    if (touch.view == mainImageView) {
////        return NO;
////    }
//    CGPoint point = [touch locationInView:mainImageView];
//    
//    
//    if ((point.x > 0 && point.x - mainImageView.frame.size.width < 0) && (point.y > 0 && point.y - mainImageView.frame.size.height < 0))
//    {
//        
//        [self enterFullScreenMode];
//        return NO;
//    }
//    return YES;
//}






-(void)initWithDetailedObject:(id)dOb
{
    if ([dOb isKindOfClass:[WSQNews class]])
    {

        detailedObject = dOb;

    }

}




#pragma mark - subview managment
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (activeTextField == newsNameTextField) {
        
    }
    else if (activeTextField == commentTextField)
    {
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
        CGRect aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, activeTextField.frame.origin.y-kbSize.height+160);
            [scrollView setContentOffset:scrollPoint animated:YES];
        }
        
    }

}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(100.0, 0.0, 0.0, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}




-(void)dismissKeyboard
{
    [activeTextField resignFirstResponder];

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyboard];
    //place holder text...check
    if (textField == newsNameTextField) {
        if (textField.text != detailedObject.newsName) {
            detailedObject.newsName = textField.text;
            [littleWheelForNewsNameTextField startAnimating];
            [loader saveNewsObject:detailedObject];
            loader.delegate = self;
        }

    }
    else if(textField == commentTextField)
    {
        if (textField.text) {
            //made the comment...
            [self.commentUploadingLittleWheel startAnimating];
            appendingComment = [[BWComment alloc] initWithAuthor:[[BWLord myLord] myLordAsAUser] commentString:textField.text];
            
            [self pullDownToReloadAction];
            refreshReady = FALSE;
            commentReady = TRUE;


        }
    }
    //get the text and save it here...
    
    return YES;
}

-(void)disableMainScrollView
{
    [self.scrollView setScrollEnabled:false];
    [self.commentsTableView setScrollEnabled:TRUE];
}



#pragma mark - pull to reload thing
- (void)scrollViewWillBeginDragging:(UIScrollView *)theScrollView {
    if (theScrollView == self.commentsTableView) {
        if ([pullToReloadHeaderView status] == kPullStatusLoading) return;
        checkForRefresh = YES;  //  only check offset when dragging
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)theScrollView
{

    if (theScrollView == self.commentsTableView)
    {
        if ([pullToReloadHeaderView status] == kPullStatusLoading) return;
        
        if (checkForRefresh) {
            if (theScrollView.contentOffset.y > -kPullDownToReloadToggleHeight && commentsTableView.contentOffset.y < 0.0f) {
                [pullToReloadHeaderView setStatus:kPullStatusPullDownToReload animated:YES];
                
            } else if (theScrollView.contentOffset.y < -kPullDownToReloadToggleHeight) {
                [pullToReloadHeaderView setStatus:kPullStatusReleaseToReload animated:YES];
            }
        }
    }

}
- (void)scrollViewDidEndDragging:(UIScrollView *)theScrollView willDecelerate:(BOOL)decelerate {
    if (theScrollView == self.commentsTableView) {
        if ([pullToReloadHeaderView status] == kPullStatusLoading) return;
        
        if ([pullToReloadHeaderView status]==kPullStatusReleaseToReload) {
            [pullToReloadHeaderView startReloading:self.commentsTableView animated:YES];
            [self pullDownToReloadAction];
        }
        checkForRefresh = NO;
    }
}




#pragma mark - comments table view actions

-(void) pullDownToReloadAction
{
	NSLog(@"TODO: Overload this");
    [loader refresh];
    loader.delegate = self;
    
    
    
}

-(void)saveComment
{
    refreshReady = FALSE;
    commentReady = FALSE;
    NSMutableArray *comments = [[NSMutableArray alloc] initWithArray:detailedObject.commentsArray];
    [comments addObject:appendingComment];
    detailedObject.commentsArray = comments;
    [loader saveNewsObject:detailedObject];
    loader.delegate = self;
}


#pragma mark - comments table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [detailedObject.commentsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 77;
    } else {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    
    UILabel* titleLabel = (UILabel*)[cell viewWithTag:1];
    
    [titleLabel setTextColor:[[BWAppDelegate instance].colorSwitcher textColor]];
    if ([detailedObject.commentsArray objectAtIndex:indexPath.row]) {
        NSArray *reversedComments = [[detailedObject.commentsArray reverseObjectEnumerator] allObjects];
        BWComment *c = (BWComment*)[reversedComments objectAtIndex:indexPath.row];
        titleLabel.text = c.author.displayName;
        UILabel *commentLable = (UILabel*)[cell viewWithTag:2];
        commentLable.text = c.commentString;
        UIImageView *authorPicView = (UIImageView*)[cell viewWithTag:3];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[c.author profilePicLocalPath]]) {
            authorPicView.image = [UIImage imageWithContentsOfFile:[c.author profilePicLocalPath]];
        }
        
        UILabel *ageLable = (UILabel*)[cell viewWithTag:4];
        ageLable.text = [NSString stringWithFormat:@"%@", [c ageDescription]];
        
        return cell;
    }
    else
    {
        return nil;
    }

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}





#pragma mark - delegate
-(void)newsLoaderDidLoadFile
{
    [pullToReloadHeaderView finishReloading:self.commentsTableView animated:YES];
    [self configureViewForDetailObject];
    
    if (commentReady) {
        [self saveComment];
    }
    else
    {
        refreshReady = TRUE;
    }

}

-(void)noChange
{
    NSLog(@"detail vc got a notice that the data modle has no change...");
    [pullToReloadHeaderView finishReloading:self.commentsTableView animated:YES];

    if (commentReady) {
        [self saveComment];
    }
    else
    {
        refreshReady = TRUE;
    }

}

-(void)saveNewsObjectSucceed
{
    [littleWheelForNewsNameTextField stopAnimating];
    [loader refresh];
    loader.delegate = self;
    [self configureViewForDetailObject];
    self.commentTextField.text = @"";

    
}



- (void)viewDidUnload {
    [self setCommentsTableView:nil];
    [self setCommentTextField:nil];
    [self setCommentUploadingLittleWheel:nil];
    [self setMyLordProfilePic:nil];
    pullToReloadHeaderView = nil;
    [super viewDidUnload];
}
@end
