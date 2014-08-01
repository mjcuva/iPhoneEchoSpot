//
//  ESProfileVC.m
//  The Echo Spot
//
//  Created by Marc Cuva on 7/23/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESProfileVC.h"
#import "ThemeManager.h"
#import "ESProfileView.h"
#import "UIImage+StackBlur.h"
#import "ESAuthenticator.h"

@interface ESProfileVC () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *partialBackgroundView;


@property (strong, nonatomic) UIImage *profileImageOrignal;
@property (strong,nonatomic)  UIImage *profileImageHalfBlurred;
@property (strong,nonatomic)  UIImage *profileImageFullBlurred;
@property (strong, nonatomic) UIImageView *profileImageViewOriginal;
@property (strong, nonatomic) UIImageView *profileImageViewHalfBlurred;
@property (strong, nonatomic) UIImageView *profileImageViewFullBlurred;
@end

@implementation ESProfileVC

- (void)viewDidLoad{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [[ThemeManager sharedManager] navBarColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    CGRect headerFrame = CGRectMake(0, 0, 320, 176);
    ESProfileView *profile = [[ESProfileView alloc] initWithFrame:headerFrame];
    profile.username = @"cuvax001";
    
    UIGraphicsBeginImageContextWithOptions(profile.bounds.size, profile.opaque, 0.0);
    [profile.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    self.profileImageOrignal = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGRect profileImageFrame = CGRectMake(0, 0, self.view.frame.size.width, 176);
    
    self.profileImageHalfBlurred = [self.profileImageOrignal stackBlur:15];
    self.profileImageViewHalfBlurred = [[UIImageView alloc] initWithFrame:profileImageFrame];
    self.profileImageViewHalfBlurred.image = self.profileImageHalfBlurred;
    
    self.profileImageFullBlurred = [self.profileImageOrignal stackBlur:30];
    self.profileImageViewFullBlurred = [[UIImageView alloc] initWithFrame:profileImageFrame];
    self.profileImageViewFullBlurred.image = self.profileImageFullBlurred;
    
    self.profileImageViewOriginal = [[UIImageView alloc] initWithImage:self.profileImageOrignal];
    self.profileImageViewOriginal.frame = CGRectMake(0, 0, self.view.frame.size.width, 176);
    
    [self.view addSubview:self.profileImageViewFullBlurred];
    [self.view addSubview:self.profileImageViewHalfBlurred];
    [self.view addSubview:self.profileImageViewOriginal];
    
    UIView *tableViewBackground = [[UIView alloc] initWithFrame:self.tableView.frame];
    tableViewBackground.backgroundColor = [UIColor clearColor];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.partialBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 176, self.view.frame.size.width, self.view.frame.size.height)];
    self.partialBackgroundView.backgroundColor = [UIColor whiteColor];
    
    [tableViewBackground addSubview:self.partialBackgroundView];
    self.tableView.backgroundView = tableViewBackground;
    
    UIView *invisibleHeader = [[UIView alloc] initWithFrame:headerFrame];
    invisibleHeader.backgroundColor = [UIColor clearColor];

    self.tableView.tableHeaderView = invisibleHeader;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[UITableViewCell alloc] init];
}

- (IBAction)closeview {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)logoutButton{
    UIAlertView *logoutConfirm = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Logout", nil];
    [logoutConfirm show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [[ESAuthenticator sharedAuthenticator] logout];
        [self closeview];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollOffset = scrollView.contentOffset.y;
    
    if(scrollOffset < 176 / 2){
        self.profileImageViewOriginal.alpha = 1 - (scrollOffset / (150 / 2));
    }else if(scrollOffset < 176){
        self.profileImageViewHalfBlurred.alpha = 1 - (scrollOffset / 150);
    }
    
    self.partialBackgroundView.frame = CGRectMake(0, 250 - scrollOffset, 320, self.view.frame.size.height);
}

@end
