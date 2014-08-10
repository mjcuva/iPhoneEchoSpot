//
//  ESCommentTableViewCell.h
//  The Echo Spot
//
//  Created by Marc Cuva on 8/10/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESComment.h"

@interface ESCommentTableViewCell : UITableViewCell

- (instancetype) initWithComment: (ESComment *)comment;

@property (strong, nonatomic) ESComment *comment;

- (CGFloat)desiredHeight;

- (BOOL)checkUpvoteTap: (CGPoint)tap;
- (BOOL)checkDownvoteTap: (CGPoint)tap;

@end
