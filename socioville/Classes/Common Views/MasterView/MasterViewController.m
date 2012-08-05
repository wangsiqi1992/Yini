//
//  MasterViewController.m
//  socioville
//
//  Created by Valentin Filip on 4/2/12.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import "MasterViewController.h"
#import "ZUUIRevealController.h"
#import "DetailViewController.h"
#import "BWAppDelegate.h"

@interface MasterViewController ()

@property (retain, nonatomic) UIPanGestureRecognizer *navigationBarPanGestureRecognizer;

@end

@implementation MasterViewController

//@synthesize detailViewController = _detailViewController;
@synthesize navigationBarPanGestureRecognizer;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    
    //init data model
    //set activity indicator on!
    
    
    

    

    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selfDestory) name:@"clear catch" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selfDestory) name:@"log out" object:nil];

    
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[[BWAppDelegate instance].colorSwitcher getImageWithName:@"background.png"]];

    
    
//    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	
    
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    else
    {
        if ([BWLord myLord].dbPlayingGround)
        {
           
            if (!loader) {
                loader = [NewsLoader sharedLoader];
            }
            
            [self startLoading];
            self.title = NSLocalizedString(@"Cards View", @"Cards View");
            
            UINavigationController *nav = self.navigationController;
            MainViewController *controller = (MainViewController*)nav.parentViewController; // MainViewController : ZUUIRevealController
            
            if ([controller respondsToSelector:@selector(revealGesture:)] && [controller respondsToSelector:@selector(revealToggle:)])
            {
                // Check if a UIPanGestureRecognizer already sits atop our NavigationBar.
                if (![[self.navigationController.navigationBar gestureRecognizers] containsObject:self.navigationBarPanGestureRecognizer])
                {
                    // If not, allocate one and add it.
                    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:controller action:@selector(revealGesture:)];
                    self.navigationBarPanGestureRecognizer = panGestureRecognizer;
                    
                    [self.navigationController.navigationBar addGestureRecognizer:self.navigationBarPanGestureRecognizer];
                    
                    
                    
                    dismissMenuTap = [[UITapGestureRecognizer alloc] initWithTarget:controller action:@selector(revealToggle:)];
                    [dismissMenuTap setEnabled:FALSE];
                    [self.tableView addGestureRecognizer:dismissMenuTap];
                    controller.delegate = self;
                    
                }
                
                // Check if we have a revealButton already.
                if (![self.navigationItem leftBarButtonItem]) {
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerSelectedOption:) name:@"MenuSelectedOption" object:nil];
                    // If not, allocate one and add it.
                    UIImage *imageMenu = [[BWAppDelegate instance].colorSwitcher getImageWithName:@"button-menu.png"];
                    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [menuButton setImage:imageMenu forState:UIControlStateNormal];
                    menuButton.frame = CGRectMake(0.0, 0.0, imageMenu.size.width, imageMenu.size.height);
                    [menuButton addTarget:controller action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
                    
                    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
                }
                if (![BWLord myLord].displayName) {
                    
                    UIViewController *lvc = [self.storyboard instantiateViewControllerWithIdentifier:@"BWMyLordInfoViewController"];
                    
                    [self presentModalViewController:lvc animated:YES];
                }
                datasource = [loader list];
                [[self tableView] reloadData];
                
            }
        }
        else
        {
            UIViewController *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayGroundSettingModalController"];
            [self presentModalViewController:pvc animated:YES];
        }
        

    }
    
	    

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

#pragma mark - Actions

- (void)menuControllerSelectedOption:(NSDictionary *)args {
    NSLog(@"selected option: %@", args);
}

- (void)refresh {
    

    if (!loader) {
        loader = [NewsLoader sharedLoader];
    }
    loader.delegate = self;
    [loader refresh];
    [[self tableView] reloadData];



}

-(void)selfDestory
{
    datasource = nil;
    
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [datasource count];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

        return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardCell"];

    if (!cell) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"CardCell" owner:nil options:nil];
        for (id obj in views) {
            if ([obj isKindOfClass:[UITableViewCell class]]) {
                cell = (CardCell *) obj;
                break;
            }
        }
    }
    
    cell = [cell initWithNews:[datasource objectAtIndex:indexPath.row]];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        self.detailViewController.detailItem = @"detail";
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        selected = indexPath.row;
        
        //        self.detailViewController = [[DetailViewController alloc]init];
//        [self.detailViewController setDetailItem:[datasource objectAtIndex:indexPath.row]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        //[[segue destinationViewController] setDetailItem:@"detail"];
        if([segue destinationViewController])
        {
            BWPhotoVideoViewController *pvc = (BWPhotoVideoViewController*) [segue destinationViewController];
            WSQNews *n = [datasource objectAtIndex:[self.tableView indexPathForSelectedRow].row];
            [pvc initWithDetailedObject:n];
        }
    }
}


#pragma mark - Data model

-(void)newsLoaderDidLoadNewsList
{
    [self stopLoading];
    datasource = [loader list];    
    [[self tableView] reloadData];
    
}

-(void)newsLoaderDidLoadFile
{
    datasource = [loader list];
    [[self tableView] reloadData];
    [self stopLoading];
}

-(void)noChange
{
    [self stopLoading];
}




- (void)revealController:(ZUUIRevealController *)revealController didRevealRearViewController:(UIViewController *)rearViewController
{
    [dismissMenuTap setEnabled:TRUE];

}

- (void)revealController:(ZUUIRevealController *)revealController didHideRearViewController:(UIViewController *)rearViewController
{
    [dismissMenuTap setEnabled:FALSE];
}



@end
