//
//  ESTableViewCell.h
//  The Echo Spot
//
//  Created by Marc Cuva on 6/7/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESTableViewCell : UITableViewCell
@property (strong, nonatomic) NSString *echoTitle;
@property (strong, nonatomic) NSString *echoContent;
@property (strong, nonatomic) NSDate *created;
@property (strong, nonatomic) NSString *username;

- (NSInteger)desiredHeight;

- (BOOL)checkOpenEchosTap: (CGPoint) point;

@end
