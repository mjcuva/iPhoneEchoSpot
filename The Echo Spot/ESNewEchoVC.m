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
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
