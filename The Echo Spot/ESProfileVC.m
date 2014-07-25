//
//  ESProfileVC.m
//  The Echo Spot
//
//  Created by Marc Cuva on 7/23/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESProfileVC.h"
#import "ThemeManager.h"

@interface ESProfileVC ()

@end

@implementation ESProfileVC

- (void)viewDidLoad{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [[ThemeManager sharedManager] navBarColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}


- (IBAction)closeview:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
