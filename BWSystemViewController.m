//
//  BWSystemViewController.m
//  Yini
//
//  Created by siqi wang on 12-8-3.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWSystemViewController.h"

@interface BWSystemViewController ()

@end

@implementation BWSystemViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clearCatchButton:(id)sender
{
    NSString *documentsDirectory = [[WSQFileHelper sharedHelper] localFileDirec];
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (error == nil) {
        for (NSString *path in directoryContents) {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:path];
            BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
            if (!removeSuccess) {
                // Error handling
                NSLog(@"deleting file fail... named: %@", path);
            }
        }
    } else {
        // Error handling
        
        NSLog(@"getting all directory fail...");
    }
    
    NSNotification *note = [NSNotification notificationWithName:@"clear catch" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:note];
    
}


- (IBAction)logOutButton:(id)sender
{
    [self clearCatchButton:nil];
    [[DBSession sharedSession] unlinkAll];
    
    NSString *userD = [[[BWLord myLord] myLordInfoSavePath] stringByDeletingLastPathComponent];
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:userD error:&error];
    if (error == nil) {
        for (NSString *path in directoryContents) {
            NSString *fullPath = [userD stringByAppendingPathComponent:path];
            BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
            if (!removeSuccess) {
                // Error handling
                NSLog(@"deleting user info fail... named: %@", path);
            }
        }
    } else {
        // Error handling
        
        NSLog(@"getting user info directory fail...");
    }
    NSNotification *note = [NSNotification notificationWithName:@"log out" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:note];
    

}



















@end
