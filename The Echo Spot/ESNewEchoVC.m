//
//  ESNewEchoVC.m
//  The Echo Spot
//
//  Created by Marc Cuva on 6/29/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESNewEchoVC.h"
#import "constants.h"

@interface ESNewEchoVC ()

@end

@implementation ESNewEchoVC

- (void)viewDidLoad{
    self.navigationItem.title = @"Create Echo";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = DARK_GRAY_COLOR;
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
