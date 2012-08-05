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
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewPhoto:)];
    
    [photoImageView addGestureRecognizer:gr];
    
    selectedImage = nil;
    newsName = nil;
    uploader = [WSQFileUploader sharedLoader];
    helper = [WSQFileHelper sharedHelper];
    loader = [NewsLoader sharedLoader];
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textFieldResignFirstResp)];
    [self.navigationController.view addGestureRecognizer:tgr];
    
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
        NSDate* now = [NSDate date];
        fileName = [[[NSString stringWithFormat:@"%@ %@", [BWLord myLord].displayName, [NSDateFormatter localizedStringFromDate:now dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle]] stringByReplacingOccurrencesOfString:@":" withString:@" "] stringByAppendingPathExtension:@"jpg"];
        
                    
        NSString *saveP = [[WSQFileUploader sharedLoader] mediaFileUploadingTempPathForNews:fileName];
        
        NSError *e;

        NSData *d = UIImageJPEGRepresentation(selectedImage, 1);
        [d writeToFile:saveP options:NSDataWritingAtomic error:&e];
        NSLog(@"%@", [e localizedDescription]);

        [uploader saveMediaFileOfNews:fileName withOldName:nil];
        uploader.delegate = self;
        
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












- (void)addNewPhoto:(UITapGestureRecognizer*)sender
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







#pragma mark - delegate call backs...

-(void)fileUploadFinished:(BOOL)isSucceed
{

    if (isSucceed) {
        [loader refresh];
        loader.delegate = self;
    }


    
}

-(void)newsLoaderDidLoadFile
{
    NewsObjectPhoto *newsOject = [[NewsObjectPhoto alloc] initWithMetadataPath:[helper mediaMetadataPathForNews:fileName]];
    if (newsOject) {
        newsOject.author = [[BWLord myLord] myLordAsAUser];
        newsOject.newsName = newsName;
        [loader saveNewsObject:newsOject];
        loader.delegate = self;
    }
    
}

-(void)saveNewsObjectSucceed
{
    //yeah!
    [self dismissModalViewControllerAnimated:YES];
}



















@end
