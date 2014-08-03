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
@property (strong, nonatomic) UITextField *createEmail;
@property (strong, nonatomic) UITextField *createPassword;
@property (strong, nonatomic) UITextField *confirmPassword;

// Login
@property (strong, nonatomic) UIView *loginForm;
@property (strong, nonatomic) UITextField *emailField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UILabel *errorLabel;

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
    
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(WIDTH_PADDING, currentHeight, self.view.frame.size.width - WIDTH_PADDING * 2, 50)];
    self.emailField.placeholder = @"UMN Email";
    self.emailField.backgroundColor = INPUT_BACKGROUND;
    UIView *userPadding = [[UIView alloc] initWithFrame:paddingFrame];
    self.emailField.leftView = userPadding;
    self.emailField.leftViewMode = UITextFieldViewModeAlways;
    self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailField.delegate = self;
    
    currentHeight += self.emailField.frame.size.height + VERTICAL_PADDING;
    
    UIView *passPadding = [[UIView alloc] initWithFrame:paddingFrame];
    
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(WIDTH_PADDING, currentHeight, self.view.frame.size.width - WIDTH_PADDING * 2, 50)];
    self.passwordField.placeholder = @"Password";
    self.passwordField.backgroundColor = INPUT_BACKGROUND;
    self.passwordField.leftView = passPadding;
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.delegate = self;
    self.passwordField.secureTextEntry = YES;
    
    currentHeight += self.passwordField.frame.size.height + (VERTICAL_PADDING);
    
    self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.errorLabel.text = @"Invalid Login";
    self.errorLabel.textColor = [UIColor redColor];
    [self.errorLabel sizeToFit];
    self.errorLabel.center = CGPointMake(self.formView.frame.size.width / 2, currentHeight + VERTICAL_PADDING);
    self.errorLabel.hidden = YES;
    
    currentHeight += self.errorLabel.frame.size.height + VERTICAL_PADDING / 2;
    
    UIButton *signInButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_PADDING, currentHeight, self.view.frame.size.width - WIDTH_PADDING * 2, 50)];
    [signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
    signInButton.backgroundColor = [[ThemeManager sharedManager] themeColor];
    signInButton.titleLabel.textColor = [UIColor whiteColor];
    [signInButton addTarget:self action:@selector(logIn) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.loginForm addSubview:self.emailField];
    [self.loginForm addSubview:self.passwordField];
    [self.loginForm addSubview:self.errorLabel];
    [self.loginForm addSubview:signInButton];
    
    [self.formView addSubview:self.loginForm];
    
    // Setup Signup
    
    self.signupForm = [[UIView alloc] initWithFrame:formRect];
    
    currentHeight = 0;
    
    self.createEmail = [[UITextField alloc] initWithFrame:CGRectMake(WIDTH_PADDING, currentHeight, self.view.frame.size.width - WIDTH_PADDING * 2, 40)];
    self.createEmail.placeholder = @"UMN Email";
    self.createEmail.backgroundColor = INPUT_BACKGROUND;
    self.createEmail.leftView = [[UIView alloc] initWithFrame:paddingFrame];
    self.createEmail.leftViewMode = UITextFieldViewModeAlways;
    self.createEmail.delegate = self;
    
    currentHeight += self.createEmail.frame.size.height + VERTICAL_PADDING;
    
    self.createPassword = [[UITextField alloc] initWithFrame:CGRectMake(WIDTH_PADDING, currentHeight, self.view.frame.size.width - WIDTH_PADDING * 2, 40)];
    self.createPassword.placeholder = @"Create a Password";
    self.createPassword.backgroundColor = INPUT_BACKGROUND;
    self.createPassword.leftView = [[UIView alloc] initWithFrame:paddingFrame];
    self.createPassword.leftViewMode = UITextFieldViewModeAlways;
    self.createPassword.delegate = self;
    self.createPassword.secureTextEntry = YES;
    
    currentHeight += self.createPassword.frame.size.height + VERTICAL_PADDING;
    
    self.confirmPassword = [[UITextField alloc] initWithFrame:CGRectMake(WIDTH_PADDING, currentHeight, self.view.frame.size.width - WIDTH_PADDING * 2, 40)];
    self.confirmPassword.placeholder = @"Confirm Password";
    self.confirmPassword.backgroundColor = INPUT_BACKGROUND;
    self.confirmPassword.leftView = [[UIView alloc] initWithFrame:paddingFrame];
    self.confirmPassword.leftViewMode = UITextFieldViewModeAlways;
    self.confirmPassword.delegate = self;
    self.confirmPassword.secureTextEntry = YES;
    
    currentHeight += self.confirmPassword.frame.size.height + VERTICAL_PADDING + 5;
    
    UIButton *createAccountButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_PADDING, currentHeight, self.view.frame.size.width - WIDTH_PADDING * 2, 50)];
    [createAccountButton setTitle:@"Try It" forState:UIControlStateNormal];
    createAccountButton.backgroundColor = [[ThemeManager sharedManager] themeColor];
    createAccountButton.titleLabel.textColor = [UIColor whiteColor];
    [createAccountButton addTarget:self action:@selector(signup) forControlEvents:UIControlEventTouchUpInside];
    
    self.signupForm.backgroundColor = [UIColor whiteColor];
    
    [self.signupForm addSubview:self.createEmail];
    [self.signupForm addSubview:self.createPassword];
    [self.signupForm addSubview:self.confirmPassword];
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

- (void)shakeView: (UIView *)view{
    CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-10.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f) ] ] ;
    anim.autoreverses = YES ;
    anim.repeatCount = 2.0f ;
    anim.duration = 0.07f ;
    
    [ view.layer addAnimation:anim forKey:nil ] ;
}

- (void)logIn{
    BOOL success = [[ESAuthenticator sharedAuthenticator] loginWithUsername:self.emailField.text andPassword:self.passwordField.text];
    if (success) {
        [self dismissViewControllerAnimated:YES completion:^{
            self.callback();
        }];
    }else{
        self.errorLabel.hidden = NO;
        [self shakeView:self.loginForm];

    }
} 

- (void)signup{
    if([self.createPassword.text isEqualToString:self.confirmPassword.text]){
        BOOL success = [[ESAuthenticator sharedAuthenticator] createAccountWithUsername:self.createEmail.text andPassword:self.createPassword.text];
        if(success){
            [self dismissViewControllerAnimated:YES completion:^{
                self.callback();
            }];
        }else{
            [self shakeView:self.signupForm];
        }
    }else{
        [self shakeView:self.signupForm];
    }
}

@end

