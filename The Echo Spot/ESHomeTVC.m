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

#warning Kind of a dirty hack
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
    self.tabBarController.tabBar.translucent = NO;
    
    self.openEcho = nil;
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
    
    if(startRow != nil && row != startRow){
        [self.tableView reloadRowsAtIndexPaths:@[row, startRow] withRowAnimation:UITableViewRowAnimationAutomatic];        
    }else{
        [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

    
}

@end
