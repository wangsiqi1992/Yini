//
//  CustomTabBarViewController.m
//
//  Created by Valentin Filip on 04/03/2012.
//
// Copyright (c) 2012 Valentin Filip
// 


#import "CustomTabBarViewController.h"

@implementation CustomTabBarViewController

@synthesize allowLandscape;

- (void)viewDidLoad
{
    [super viewDidLoad];
    int idx = (self.viewControllers.count / 2);
    UIViewController *controller = [self.viewControllers objectAtIndex:idx];
    NSString *string = controller.title ? controller.title : @" ";
    [self addCenterButtonWithOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                        @"tabbar-center.png", @"buttonImage"
                                      , @"camera.png", @"icon"
                                      , string, @"title"
                                      , nil]];
    [super setWantsFullScreenLayout:NO];
    pb = [[ProgressBanner alloc] initWithFrame:CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height, self.view.frame.size.width, self.view.frame.size.height)];

    
    [pb.littleWheel startAnimating];
    [self.view addSubview:pb];
    [pb setHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingWithStatus:) name:[BWNotificationCenter uiProgressBarNotificationName] object:nil];


}

-(void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(self.allowLandscape || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

-(void)loadingWithStatus:(NSNotification*)note
{
    if ([[note.userInfo objectForKey:@"loading"] boolValue] == YES) {
        [pb setHidden:NO];
        [pb setOpaque:NO];
        [pb setAlpha:0.5];
        [pb.littleWheel startAnimating];
        if ([note.userInfo objectForKey:@"status"]) {
            
        }
        else
        {
        }
        if ([note.userInfo objectForKey:@"progress"]) {
            
        }
    }
    else
    {
        if ([pb isHidden] == NO) {
            [pb.littleWheel stopAnimating];
            if ([note.userInfo objectForKey:@"status"]) {
                
            }
            else
            {
            }
            [self hidePB];

        }
    }

}

-(void)hidePB
{
    [pb setHidden:YES];
}
























@end
