//
//  ESAuthVC.m
//  The Echo Spot
//
//  Created by Marc Cuva on 7/30/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESAuthVC.h"
#import "ThemeManager.h"
#import "UIImage+StackBlur.h"
#import "constants.h"
#import "ESAuthenticator.h"

@interface ESAuthVC () <UITextFieldDelegate>
@property (strong, nonatomic) UIView *formView;


// Signup
@property (strong, nonatomic) UIView *signupForm;

// Login
@property (strong, nonatomic) UIView *loginForm;
@property (strong, nonatomic) UITextField *usernameField;
@property (strong, nonatomic) UITextField *passwordField;

@property CGRect formStart;
@end

@implementation ESAuthVC

#define FORM_HEIGHT 300
#define TOP_PADDING 20
#define WIDTH_PADDING 10
#define VERTICAL_PADDING 10
#define SEG_CONTROL_HEIGHT 44

- (void)viewDidLoad{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];
    
    // blur background
    UIImage *image = [[UIImage imageNamed:@"Logo.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    self.navigationController.navigationBar.barTintColor = [[ThemeManager sharedManager] navBarColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIView *backgroundColor = [[UIView alloc] initWithFrame:self.view.frame];
    backgroundColor.backgroundColor = [[ThemeManager sharedManager] themeColor];
    UIView *background = [[UIView alloc] initWithFrame:self.view.frame];
    background.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"profileBackground.png"]];
    [backgroundColor addSubview:background];
    
    UIGraphicsBeginImageContextWithOptions(backgroundColor.bounds.size, backgroundColor.opaque, 0.0);
    [backgroundColor.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[img stackBlur:8]];
    
    
    // Set up Form
    self.formStart = CGRectMake(0, (self.view.frame.size.height / 2) - (FORM_HEIGHT / 2) - 40, self.view.frame.size.width, FORM_HEIGHT);
    self.formView = [[UIView alloc] initWithFrame:self.formStart];
    self.formView.backgroundColor = [UIColor whiteColor];
    
    UISegmentedControl *typeChooser = [[UISegmentedControl alloc] initWithItems:@[@"Log In", @"Try It"]];
    typeChooser.frame = CGRectMake(WIDTH_PADDING, TOP_PADDING, self.view.frame.size.width - WIDTH_PADDING * 2, SEG_CONTROL_HEIGHT);
    typeChooser.tintColor = [[ThemeManager sharedManager] themeColor];
    typeChooser.selectedSegmentIndex = 0;
    [typeChooser addTarget:self action:@selector(changeForm:) forControlEvents:UIControlEventValueChanged];
    [self.formView addSubview:typeChooser];
    
    CGFloat currentHeight = typeChooser.frame.origin.y + typeChooser.frame.size.height;
    
    CGRect formRect = CGRectMake(0, currentHeight + VERTICAL_PADDING, self.view.frame.size.width, self.formView.frame.size.height - currentHeight - VERTICAL_PADDING);
    
    // Set Up Login
    self.loginForm = [[UIView alloc] initWithFrame:formRect];
    
    currentHeight = VERTICAL_PADDING;
    
    CGRect paddingFrame = CGRectMake(0, 0, 15, 20);
    
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(WIDTH_PADDING, currentHeight, self.view.frame.size.width - WIDTH_PADDING * 2, 50)];
    self.usernameField.placeholder = @"UMN Email";
    self.usernameField.backgroundColor = INPUT_BACKGROUND;
    UIView *userPadding = [[UIView alloc] initWithFrame:paddingFrame];
    self.usernameField.leftView = userPadding;
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameField.delegate = self;
    
    currentHeight += self.usernameField.frame.size.height + VERTICAL_PADDING;
    
    UIView *passPadding = [[UIView alloc] initWithFrame:paddingFrame];
    
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(WIDTH_PADDING, currentHeight, self.view.frame.size.width - WIDTH_PADDING * 2, 50)];
    self.passwordField.placeholder = @"Password";
    self.passwordField.backgroundColor = INPUT_BACKGROUND;
    self.passwordField.leftView = passPadding;
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.delegate = self;
    self.passwordField.secureTextEntry = YES;
    
    currentHeight += self.passwordField.frame.size.height + (VERTICAL_PADDING * 2);
    
    UIButton *signInButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_PADDING, currentHeight, self.view.frame.size.width - WIDTH_PADDING * 2, 50)];
    [signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
    signInButton.backgroundColor = [[ThemeManager sharedManager] themeColor];
    signInButton.titleLabel.textColor = [UIColor whiteColor];
    [signInButton addTarget:self action:@selector(logIn) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.loginForm addSubview:self.usernameField];
    [self.loginForm addSubview:self.passwordField];
    [self.loginForm addSubview:signInButton];
    
    [self.formView addSubview:self.loginForm];
    
    // Setup Signup
    
    self.signupForm = [[UIView alloc] initWithFrame:formRect];
    
    currentHeight = 0;
    
    UITextField *createUsername = [[UITextField alloc] initWithFrame:CGRectMake(WIDTH_PADDING, currentHeight, self.view.frame.size.width - WIDTH_PADDING * 2, 40)];
    createUsername.placeholder = @"UMN Email";
    createUsername.backgroundColor = INPUT_BACKGROUND;
    createUsername.leftView = [[UIView alloc] initWithFrame:paddingFrame];
    createUsername.leftViewMode = UITextFieldViewModeAlways;
    createUsername.delegate = self;
    
    currentHeight += createUsername.frame.size.height + VERTICAL_PADDING;
    
    UITextField *createPassword = [[UITextField alloc] initWithFrame:CGRectMake(WIDTH_PADDING, currentHeight, self.view.frame.size.width - WIDTH_PADDING * 2, 40)];
    createPassword.placeholder = @"Create a Password";
    createPassword.backgroundColor = INPUT_BACKGROUND;
    createPassword.leftView = [[UIView alloc] initWithFrame:paddingFrame];
    createPassword.leftViewMode = UITextFieldViewModeAlways;
    createPassword.delegate = self;
    createPassword.secureTextEntry = YES;
    
    currentHeight += createPassword.frame.size.height + VERTICAL_PADDING;
    
    UITextField *confirmPassword = [[UITextField alloc] initWithFrame:CGRectMake(WIDTH_PADDING, currentHeight, self.view.frame.size.width - WIDTH_PADDING * 2, 40)];
    confirmPassword.placeholder = @"Confirm Password";
    confirmPassword.backgroundColor = INPUT_BACKGROUND;
    confirmPassword.leftView = [[UIView alloc] initWithFrame:paddingFrame];
    confirmPassword.leftViewMode = UITextFieldViewModeAlways;
    confirmPassword.delegate = self;
    confirmPassword.secureTextEntry = YES;
    
    currentHeight += confirmPassword.frame.size.height + VERTICAL_PADDING + 5;
    
    UIButton *createAccountButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_PADDING, currentHeight, self.view.frame.size.width - WIDTH_PADDING * 2, 50)];
    [createAccountButton setTitle:@"Try It" forState:UIControlStateNormal];
    createAccountButton.backgroundColor = [[ThemeManager sharedManager] themeColor];
    createAccountButton.titleLabel.textColor = [UIColor whiteColor];
    
    self.signupForm.backgroundColor = [UIColor whiteColor];
    
    [self.signupForm addSubview:createUsername];
    [self.signupForm addSubview:createPassword];
    [self.signupForm addSubview:confirmPassword];
    [self.signupForm addSubview:createAccountButton];
    
    
    
    [self.view addSubview:imgView];
    [self.view addSubview:self.formView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow: (NSNotification *)notification{
    
    [UIView animateWithDuration:[notification.userInfo [UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.formView.frame = CGRectMake(0, 0, self.formView.frame.size.width, self.formView.frame.size.height);

    }];
}

- (void)keyboardWillHide: (NSNotification *)notification{
    [UIView animateWithDuration:[notification.userInfo [UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.formView.frame = self.formStart;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeForm: (UISegmentedControl *)sender{
    if(sender.selectedSegmentIndex == 0){
        [self.signupForm removeFromSuperview];
        [self.formView addSubview:self.loginForm];
    }else{
        [self.loginForm removeFromSuperview];
        [self.formView addSubview:self.signupForm];
    }
}

- (void)logIn{
    [[ESAuthenticator sharedAuthenticator] loginWithUsername:self.usernameField.text andPassword:self.passwordField.text];
    [self dismissViewControllerAnimated:YES completion:^{
        self.callback();
    }];
} 

@end

