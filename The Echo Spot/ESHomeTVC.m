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

@interface ESHomeTVC()
@property (strong, nonatomic) NSArray *echos;
@property (strong, nonatomic) ESEcho *openEcho;

@property (nonatomic) CGFloat lastScrollViewOffset;

// Dirty Hack
@property (strong, nonatomic) NSIndexPath *openRow;
@end

@implementation ESHomeTVC

- (void)viewDidLoad{
    self.echos = [ESEchoFetcher loadRecentEchos];
    if(self.echos.count % 2 == 1){
        self.view.backgroundColor = [UIColor colorWithRed:43/255.0f green:43/255.0f blue:45/255.0f alpha:1.0f];
    }else{
        self.view.backgroundColor = [UIColor colorWithRed:61/255.0f green:62/255.0f blue:63/255.0f alpha:1.0f];
    }
    
#warning We should find a way to make transparency work
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
    // Kind of a gross hack
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Trending", @"Recent", @"Votes"]];
    segmentedControl.tintColor = [UIColor clearColor];
    segmentedControl.layer.cornerRadius = 5;
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self setToolbarItems:@[flexibleSpace, button, flexibleSpace]];
    
    self.openEcho = nil;
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 20)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view.window.rootViewController.view addSubview:view];
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.echos.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.echos[indexPath.row] == self.openEcho){
        return 200;
    }else{
        return 88;
    }
}

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
    }else{
        cell.echoContent = @"";
    }
    
    return cell;
}

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
    }
    
    if(startRow != nil && row.row != startRow.row){
        [self.tableView reloadRowsAtIndexPaths:@[row, startRow] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    if(self.openEcho != nil){
        [self.tableView scrollToRowAtIndexPath:row atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
