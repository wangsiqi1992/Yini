//
//  BWMyLordInfoViewController.m
//  Yini
//
//  Created by siqi wang on 12-7-20.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWMyLordInfoViewController.h"

@interface BWMyLordInfoViewController ()

@end

@implementation BWMyLordInfoViewController
@synthesize profilPic;
@synthesize statusTextLable;
@synthesize littleWheel, lord, navTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        self = [self initWithNibName:nil bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self configureView];
    if (self.navTitle)
    {
//        self.navigationController.navigationBar. = self.navTitle;
        
    }
    
}

-(void)configureView
{
    self.lord = [BWLord myLord];
    if (self.lord.displayName) {
        [self.littleWheel stopAnimating];
        NSString *greeting = [NSString stringWithFormat:@"Hi, %@", self.lord.displayName];
        self.statusTextLable.text = greeting;
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self.lord profilePicLocalPath]]) {
            self.profilPic.image = [UIImage imageWithContentsOfFile:[self.lord profilePicLocalPath]];
        }
        else
        {
            self.profilPic.image = [UIImage imageNamed:@"user_1.png"];
            self.lord.delegate = self;
        }
    }
    else
    {
        self.lord.delegate = self;
        [self.littleWheel startAnimating];
        self.profilPic.image = [UIImage imageNamed:@"user_1.png"];
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

- (IBAction)choosePicture:(id)sender
{
    UIImagePickerController *ip = [[UIImagePickerController alloc]init];
    [ip setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [ip setDelegate:self];
    [self presentModalViewController:ip animated:YES];
}

-(IBAction)save:(id)sender
{

    
    if (pickedImage) {
        
        [self.littleWheel startAnimating];
        
        //save file here!!!! to db
        NSRange r = [[self.lord profilePicLocalPath] rangeOfString:@"yini system file/"];
        NSString *namePath = [[self.lord profilePicLocalPath] substringFromIndex:r.location + r.length];
        [[NSFileManager defaultManager] createFileAtPath:[[WSQFileUploader sharedLoader] sysFileUploadingTempPathForNews:namePath] contents:UIImageJPEGRepresentation(pickedImage, 1.0) attributes:nil];
        [[WSQFileUploader sharedLoader] saveSysFileOfNews:namePath withOldName:namePath];
        [WSQFileUploader sharedLoader].delegate = self;
    }

    else
    {
        [self dismissModalViewControllerAnimated:YES];
    }

}

- (void)viewDidUnload {
    [self setProfilPic:nil];
    [self setStatusTextLable:nil];
    [self setLittleWheel:nil];
    [super viewDidUnload];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *im = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.profilPic.image = im;
    pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissModalViewControllerAnimated:YES];
}



#pragma mark - bw call back
-(void)myLordInfoLoaded
{
    [self.littleWheel stopAnimating];
    [self configureView];
}

-(void)myLordProfilePicLoaded
{
    [self.littleWheel stopAnimating];
    [self configureView];
}

-(void)fileUploadFinished:(BOOL)isSucceed
{
    if (isSucceed) {
        [self.littleWheel stopAnimating];
        [self dismissModalViewControllerAnimated:YES];
        [self.delegate myLordInfoViewDidGotNewProfile];
    }
    
}


















@end
