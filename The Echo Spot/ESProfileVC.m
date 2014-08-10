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
#import "ESEchoFetcher.h"
#import "ESEchoTableViewCell.h"
#import "ESCommentVC.h"

@interface ESProfileVC () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *partialBackgroundView;

@property (strong, nonatomic) UIImage *profileImageOrignal;
@property (strong,nonatomic)  UIImage *profileImageHalfBlurred;
@property (strong,nonatomic)  UIImage *profileImageFullBlurred;
@property (strong, nonatomic) UIImageView *profileImageViewOriginal;
@property (strong, nonatomic) UIImageView *profileImageViewHalfBlurred;
@property (strong, nonatomic) UIImageView *profileImageViewFullBlurred;

@property (strong, nonatomic) NSArray *echos;
@property (nonatomic) CGFloat openCellHeight;
@property (strong, nonatomic) NSIndexPath *openRow;
@property (strong, nonatomic) ESEcho *openEcho;
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
    profile.username = [ESEchoFetcher usernameForCurrentUser];
    
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
    
    self.echos = [ESEchoFetcher echosForUser:[[ESAuthenticator sharedAuthenticator] currentUser]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.echos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.echos[indexPath.row] == self.openEcho){
        return self.openCellHeight;
    }else{
        return 88;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Echo";
    ESEcho *echo = self.echos[indexPath.item];
    
    ESEchoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        cell = [[ESEchoTableViewCell alloc] initWithEcho:echo];
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, tableView.rowHeight);
        
        UITapGestureRecognizer *toggleEcho = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openEcho:)];
        
        [cell addGestureRecognizer:toggleEcho];
    }
    
    if(indexPath.row % 2 == 0)
    {
        cell.backgroundColor = [[ThemeManager sharedManager] lightBackgroundColor];
    }else{
        cell.backgroundColor = [[ThemeManager sharedManager] darkBackgroundColor];
    }
    
    
    if(self.echos[indexPath.row] == self.openEcho){
        cell.isOpen = YES;
    }else{
        cell.isOpen = NO;
    }
    
    cell.userInteractionEnabled = YES;
    
    return cell;
}

- (void)openEcho:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.tableView];
    
    NSIndexPath *row = [self.tableView indexPathForRowAtPoint:point];
    NSIndexPath *startRow = self.openRow;
    ESEchoTableViewCell *cell = (ESEchoTableViewCell *)[self.tableView cellForRowAtIndexPath:row];
    
    if([cell checkOpenEchosTap:[self.view convertPoint:point toView:cell]] && self.echos[row.item] == self.openEcho){
        [self performSegueWithIdentifier:@"showComments" sender:self];
    }else{
        
        if(self.echos[row.item] == self.openEcho){
            self.openEcho = nil;
            cell.isOpen = NO;
            self.openRow = nil;
        }else{
            self.openEcho = self.echos[row.item];
            cell.isOpen = YES;
            self.openRow = row;
            self.openCellHeight = [cell desiredHeight];
        }
        
        if(startRow != nil && row.row != startRow.row){
            [self.tableView reloadRowsAtIndexPaths:@[row, startRow] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[ESCommentVC class]]){
        ESCommentVC *destination = (ESCommentVC *)segue.destinationViewController;
        destination.echo = self.openEcho;
    }
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
