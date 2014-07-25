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

@interface ESProfileVC () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *partialBackgroundView;
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
    
    CGRect headerFrame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    ESProfileView *profile = [[ESProfileView alloc] initWithFrame:headerFrame];
    profile.username = @"TEST";
    [self.view addSubview:profile];
    
    UIView *tableViewBackground = [[UIView alloc] initWithFrame:self.tableView.frame];
    tableViewBackground.backgroundColor = [UIColor clearColor];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.partialBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height)];
    self.partialBackgroundView.backgroundColor = [UIColor whiteColor];
    
    [tableViewBackground addSubview:self.partialBackgroundView];
    self.tableView.backgroundView = tableViewBackground;
    
    UIView *invisibleHeader = [[UIView alloc] initWithFrame:headerFrame];
    invisibleHeader.backgroundColor = [UIColor clearColor];

    self.tableView.tableHeaderView = invisibleHeader;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[UITableViewCell alloc] init];
}

- (IBAction)closeview:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollOffset = scrollView.contentOffset.y;
    self.partialBackgroundView.frame = CGRectMake(0, 250 - scrollOffset, 320, self.view.frame.size.height);
}

@end
