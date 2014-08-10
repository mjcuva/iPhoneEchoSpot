//
//  ESTableViewCell.h
//  The Echo Spot
//
//  Created by Marc Cuva on 6/7/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESEcho.h"

@interface ESEchoTableViewCell : UITableViewCell

@property (nonatomic, strong) ESEcho *echo;

@property (nonatomic) BOOL isComment;

@property (nonatomic) BOOL isOpen;

/**
 Designated initializer
*/
- (instancetype) initWithEcho: (ESEcho *)echo;

- (NSInteger)desiredHeight;

- (BOOL)checkOpenEchosTap: (CGPoint) point;

- (BOOL)checkUpvoteTap: (CGPoint)point;

- (BOOL)checkDownvoteTap: (CGPoint)point;

@end
