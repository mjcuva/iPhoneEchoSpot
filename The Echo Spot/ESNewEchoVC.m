//
//  ESNewEchoVC.m
//  The Echo Spot
//
//  Created by Marc Cuva on 6/29/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESNewEchoVC.h"
#import "constants.h"
#import "ThemeManager.h"

@interface ESNewEchoVC ()
@property (strong, nonatomic) UIScrollView *scrollView;

// Title
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextField *titleInput;

// Content
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UITextView *contentInput;

// Type
@property (strong, nonatomic) UILabel *typeLabel;
@property (strong, nonatomic) UISegmentedControl *typeControl;

// Privacy
@property (strong, nonatomic) UILabel *privacyLabel;
@property (strong, nonatomic) UISegmentedControl *privacyControl;
@end

@implementation ESNewEchoVC

- (void)viewDidLoad{
    self.navigationItem.title = @"Create Echo";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [[ThemeManager sharedManager] lightBackgroundColor];
    self.navigationController.navigationBar.barTintColor = [[ThemeManager sharedManager] navBarColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    
    double contentHeight = 0;
    
    // Title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width, 44)];
    self.titleLabel.text = @"Title";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    self.titleLabel.textColor = [[ThemeManager sharedManager] detailFontColor];
    
    contentHeight += 10 + self.titleLabel.frame.size.height;
    
    self.titleInput = [[UITextField alloc] initWithFrame:CGRectMake(0, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height, self.view.frame.size.width, 50)];
    self.titleInput.backgroundColor = [UIColor colorWithRed:244/255.0f green:238/255.0f blue:240/255.0f alpha:1.0f];
    
    contentHeight += self.titleInput.frame.size.height;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    self.titleInput.leftView = paddingView;
    self.titleInput.leftViewMode = UITextFieldViewModeAlways;
    
    // Content
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.titleInput.frame.origin.y + self.titleInput.frame.size.height + 10, self.view.frame.size.width, 50)];
    self.contentLabel.text = @"Echo";
    self.contentLabel.font = [UIFont boldSystemFontOfSize:30];
    self.contentLabel.textColor = [[ThemeManager sharedManager] detailFontColor];
    
    contentHeight += self.contentLabel.frame.size.height + 10;
    
    self.contentInput = [[UITextView alloc] initWithFrame:CGRectMake(0, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height, self.view.frame.size.width, 150)];
    self.contentInput.backgroundColor = [UIColor colorWithRed:244/255.0f green:238/255.0f blue:240/255.0f alpha:1.0f];
    self.contentInput.editable = YES;
    self.contentInput.textContainerInset = UIEdgeInsetsMake(10, 10, 5, 10);
    self.contentInput.font = [UIFont systemFontOfSize:14];
    
    contentHeight += self.contentInput.frame.size.height;
    
    // Type
    
    self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.contentInput.frame.origin.y + self.contentInput.frame.size.height + 10, self.view.frame.size.height, 50)];
    self.typeLabel.text = @"Type";
    self.typeLabel.font = [UIFont boldSystemFontOfSize:30];
    self.typeLabel.textColor = [[ThemeManager sharedManager] detailFontColor];
    
    contentHeight += self.typeLabel.frame.size.height + 10;
    
    self.typeControl = [[UISegmentedControl alloc] initWithItems:@[@"Idea", @"Question", @"Issue"]];
    self.typeControl.tintColor = [[ThemeManager sharedManager] themeColor];                    
    self.typeControl.frame = CGRectMake(10, self.typeLabel.frame.size.height + self.typeLabel.frame.origin.y + 10, self.view.frame.size.width - 20, 40);
    
    contentHeight += self.typeControl.frame.size.height + 10;
    
    // Privacy
    
    self.privacyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.typeControl.frame.origin.y + self.typeControl.frame.size.height + 20, self.view.frame.size.width, 50)];
    self.privacyLabel.text = @"Display Name";
    self.privacyLabel.font = [UIFont boldSystemFontOfSize:30];
    self.privacyLabel.textColor = [[ThemeManager sharedManager] detailFontColor];
    
    contentHeight += self.privacyLabel.frame.size.height + 20;
    
    self.privacyControl = [[UISegmentedControl alloc] initWithItems:@[@"Anonymous", @"Username"]];
    self.privacyControl.frame = CGRectMake(10, self.privacyLabel.frame.origin.y + self.privacyLabel.frame.size.height + 10, self.view.frame.size.width - 20, 50);
    self.privacyControl.tintColor = [[ThemeManager sharedManager] themeColor];
    
    contentHeight += self.privacyControl.frame.size.height + 10;
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, contentHeight + 20);
    NSLog(@"%@", NSStringFromCGSize(self.scrollView.contentSize));
    NSLog(@"%f", self.view.frame.size.height);
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.titleInput];
    [self.scrollView addSubview:self.contentLabel];
    [self.scrollView addSubview:self.contentInput];
    [self.scrollView addSubview:self.typeLabel];
    [self.scrollView addSubview:self.typeControl];
    [self.scrollView addSubview:self.privacyLabel];
    [self.scrollView addSubview:self.privacyControl];
    
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
