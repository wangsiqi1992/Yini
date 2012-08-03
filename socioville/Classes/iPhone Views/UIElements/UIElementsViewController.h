//
//  UIElementsViewController.h
//  socioville
//
//  Created by Valentin Filip on 4/3/12.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIElementsViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)sliderValueChanged:(id)sender;

@property (nonatomic, weak) IBOutlet UIButton* colorButton;

@property (nonatomic, weak) IBOutlet UIButton* colorButtonSelected;

@end
