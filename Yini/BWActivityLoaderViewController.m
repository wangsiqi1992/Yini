//
//  BWActivityLoaderViewController.m
//  Yini
//
//  Created by siqi wang on 12-8-7.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWActivityLoaderViewController.h"

@interface BWActivityLoaderViewController ()
@property (retain, nonatomic) UIPanGestureRecognizer *navigationBarPanGestureRecognizer;

@end

//@synthesize detailViewController = _detailViewController;

@implementation BWActivityLoaderViewController
@synthesize navigationBarPanGestureRecognizer;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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
//            controller.delegate = self;
            
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
    }

    
    
    
    
    
    
    if (self.user)
    {
        actiLoader = [[BWActivityLoader alloc] initWithUserName:self.user.displayName];
        activities = [actiLoader activitiesPreparedForProfilePage];
    }
    else
    {
        
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    activities = nil;
    actiLoader = nil;
    
}


#pragma mark - table view related...

-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else
    {
        return [activities count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 150;
    }
    else
    {
        if ([[activities objectAtIndex:indexPath.row] isKindOfClass:[BWActivityNews class]])
        {
            return 160;
        }
        if ([[activities objectAtIndex:indexPath.row] isKindOfClass:[BWActivityNews class]]) {
            return 85;
            
        }
    
    }
    
    return 30;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UserActivityProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserActivityProfile"];
        

        
        [cell setUser:self.user];
        
        return cell;
    }
    else
    {
        if ([[activities objectAtIndex:indexPath.row] isKindOfClass:[BWActivityNews class]])
        {
            BWActivityNews *newsActi = (BWActivityNews *)[activities objectAtIndex:indexPath.row];
            BWUserActivityNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BWUserActivityNewsCell"];

            
            [cell setNewsActivity:newsActi];
            
            return cell;
            
        }
        

    }
    return nil;
}

//not selectable at the moment~

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



































@end
