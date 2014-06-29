//
//  ESHomeTVC.m
//  The Echo Spot
//
//  Created by Marc Cuva on 5/31/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESHomeTVC.h"
#import "ESEcho.h"
#import "ESEchoFetcher.h"
#import "ESTableViewCell.h"
#import "constants.h"

@interface ESHomeTVC()
@property (strong, nonatomic) NSArray *echos;
@property (strong, nonatomic) ESEcho *openEcho;

@property (nonatomic) CGFloat lastScrollViewOffset;

// Dirty Hack
@property (strong, nonatomic) NSIndexPath *openRow;
@property NSInteger openCellHeight;
@end

@implementation ESHomeTVC

#define CONTROL_HEIGHT 30

// Percent width
#define CONTROL_WIDTH .85 * self.view.frame.size.width

// padding from top of control to top of view
#define CONTROL_PADDING 10

#define VIEW_ZERO (-CONTROL_HEIGHT - CONTROL_PADDING * 2)

#pragma mark - Set Up Views

- (void)viewDidLoad{
    
    UIImage *image = [UIImage imageNamed:@"Logo.png"];
    NSLog(@"%@", [image description]);
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    
    self.echos = [ESEchoFetcher loadRecentEchos];
    if(self.echos.count % 2 == 1){
        self.view.backgroundColor = DARK_GRAY_COLOR;
    }else{
        self.view.backgroundColor = LIGHT_GRAY_COLOR;
    }
    
#warning We should find a way to make transparency work
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
    // Kind of a gross hack
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Trending", @"Recent", @"Votes"]];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.layer.cornerRadius = 5;
    segmentedControl.frame = CGRectMake((self.view.frame.size.width - CONTROL_WIDTH) / 2, -CONTROL_HEIGHT - CONTROL_PADDING, CONTROL_WIDTH, CONTROL_HEIGHT);

    [self.tableView setContentInset:UIEdgeInsetsMake(segmentedControl.frame.size.height + CONTROL_PADDING * 2, 0, 0, 0)];
    
    [self.tableView addSubview:segmentedControl];
    
    self.openEcho = nil;
    
}

- (void)viewDidAppear:(BOOL)animated{
//    self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);
//    NSLog(@"%@", self.tableView.contentOffset.y);
    [self performSelector:@selector(hideControl) withObject:nil afterDelay:0];
}

- (void)hideControl{
//    self.tableView.contentOffset = CGPointMake(0, 0);
//    [UIView animateWithDuration:.2 delay:0 options:(UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAutoreverse ) animations:^{
//        self.tableView.contentOffset = CGPointMake(0, -20);
//    } completion:^(BOOL success){
//        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//            self.tableView.contentOffset = CGPointMake(0, 0);
//        } completion:^(BOOL success){}];
//    }];
    self.tableView.contentOffset = CGPointMake(0, 0);

}

#pragma mark - UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.echos.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.echos[indexPath.row] == self.openEcho){
        return self.openCellHeight;
    }else{
        return 88;
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"EchoCell";
    ESEcho *echo = self.echos[indexPath.item];
    
    ESTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        cell = [[ESTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, tableView.rowHeight);
        
        UITapGestureRecognizer *toggleEcho = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openEcho:)];
        
        [cell addGestureRecognizer:toggleEcho];
    }
    
    
    if(indexPath.row % 2 == 0)
    {
        cell.backgroundColor = [UIColor colorWithRed:43/255.0f green:43/255.0f blue:45/255.0f alpha:1.0f];
    }else{
        cell.backgroundColor = [UIColor colorWithRed:61/255.0f green:62/255.0f blue:63/255.0f alpha:1.0f];
    }
    
    
# warning Might be issue with resizing height
    cell.echoTitle = echo.title;
    
    if(self.echos[indexPath.row] == self.openEcho){
        cell.echoContent = echo.content;
//        self.openCellHeight = [cell desiredHeight];
    }else{
        cell.echoContent = @"";
    }
    
    return cell;
}

#pragma mark - Expand Echos

- (void)openEcho:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.tableView];
    NSIndexPath *row = [self.tableView indexPathForRowAtPoint:point];
    NSIndexPath *startRow = self.openRow;
    ESTableViewCell *cell = (ESTableViewCell *)[self.tableView cellForRowAtIndexPath:row];
    
    if(self.echos[row.item] == self.openEcho){
        self.openEcho = nil;
        cell.echoContent = @"";
        self.openRow = nil;
    }else{
        self.openEcho = self.echos[row.item];
        cell.echoContent = self.openEcho.content;
        self.openRow = row;
        self.openCellHeight = [cell desiredHeight];
    }
    
    if(startRow != nil && row.row != startRow.row){
        [self.tableView reloadRowsAtIndexPaths:@[row, startRow] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    if(self.openEcho != nil){
        NSLog(@"Cell 1: %f", cell.frame.size.height);
        [self scrollToIndexPath:row withCell: cell];
    }
}

- (void)scrollToIndexPath:(NSIndexPath *)indexPath withCell:(ESTableViewCell *)cell{
    if(self.tableView.contentSize.height - cell.frame.origin.y > self.tableView.frame.size.height){
        [self.tableView setContentOffset:CGPointMake(0, indexPath.row * cell.frame.size.height) animated:YES];
    }else{
//        [self.tableView setContentOffset:CGPointMake(0, indexPath.row * cell.frame.size.height) animated:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(scrollView.contentOffset.y < -(CONTROL_HEIGHT / 2)){
        [UIView animateWithDuration:.3 animations:^{
            [scrollView setContentOffset: CGPointMake(0, VIEW_ZERO)];
        }];
    }else if(scrollView.contentOffset.y > -(CONTROL_HEIGHT / 2) && scrollView.contentOffset.y < 0){
        [UIView animateWithDuration:.3 animations:^{
            [scrollView setContentOffset:CGPointZero animated:YES];
        }];
    }
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    if(self.lastScrollViewOffset < scrollView.contentOffset.y && self.navigationController.navigationBar.hidden == NO && scrollView.contentOffset.y != 0){
//        // Hide
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//        [self.navigationController setToolbarHidden:YES animated:YES];
//    }else if(self.lastScrollViewOffset > scrollView.contentOffset.y && self.navigationController.navigationBar.hidden == YES){
//        // Show
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//        [self.navigationController setToolbarHidden:NO animated:YES];
//    }
//    
//    if(scrollView.contentOffset.y < 0){
//        self.lastScrollViewOffset = 0;
//    }else{
//        self.lastScrollViewOffset = scrollView.contentOffset.y;
//    }
//    NSLog(@"%f", self.lastScrollViewOffset);
//    
//}

@end
