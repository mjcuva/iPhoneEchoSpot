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

@interface ESHomeTVC()
@property (strong, nonatomic) NSArray *echos;
@end

@implementation ESHomeTVC

- (void)viewDidLoad{
    self.echos = [ESEchoFetcher loadRecentEchos];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.echos.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"EchoCell";
    ESEcho *echo = self.echos[indexPath.item];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.text = echo.title;
    cell.detailTextLabel.text = echo.content;
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    if(indexPath.item % 2 == 0)
    {
        cell.backgroundColor = [UIColor colorWithRed:43/255.0f green:43/255.0f blue:45/255.0f alpha:1.0f];
    }else{
        cell.backgroundColor = [UIColor colorWithRed:61/255.0f green:62/255.0f blue:63/255.0f alpha:1.0f];
    }
    return cell;
}

@end
