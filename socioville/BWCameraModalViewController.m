//
//  BWCameraModalViewController.m
//  Yini
//
//  Created by siqi wang on 12-8-4.
//  Copyright (c) 2012年 siqi wang. All rights reserved.
//

#import "BWCameraModalViewController.h"

@interface BWCameraModalViewController ()

@end

@implementation BWCameraModalViewController
@synthesize nameTextField;
@synthesize photoImageView;
@synthesize littleWheel;

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
    //UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewPhoto:)];
    
    //[photoImageView addGestureRecognizer:gr];
    
    selectedImage = nil;
    newsName = nil;

    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textFieldResignFirstResp)];
    [self.photoImageView addGestureRecognizer:tgr];
    fistTime = YES;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (fistTime) {
        [self startPicker];
        fistTime = NO;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButton:(id)sender
{
    if (selectedImage)
    {
        newsName = nameTextField.text;
        [littleWheel startAnimating];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:newsName, @"news name", nil];
        
        if ([[BWNewsWriter sharedWriter] composePhotoNewsWithPhoto:selectedImage attributes:dic])
        {
            [self dismissModalViewControllerAnimated:YES];
        }
    }
}

- (IBAction)closeButton:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setNameTextField:nil];
    [self setPhotoImageView:nil];
    [self setLittleWheel:nil];
    [super viewDidUnload];
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    self.photoImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    selectedImage = [[info objectForKey:UIImagePickerControllerOriginalImage] copy];
    [picker dismissModalViewControllerAnimated:YES];
}












//- (void)addNewPhoto:(UITapGestureRecognizer*)sender
//{
//    [self startPicker];
//    
//}

-(void)startPicker
{
    UIImagePickerController *pc = [[UIImagePickerController alloc]init];
    [pc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    pc.delegate = self;
    [self presentModalViewController:pc animated:YES];
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (nameTextField.text) {
        newsName = nameTextField.text;
    }
}


-(void)textFieldResignFirstResp
{
    [self.nameTextField resignFirstResponder];
}



























- (IBAction)pick:(id)sender {
    [self startPicker];
}
@end
