//
//  ESEchoView.h
//  The Echo Spot
//
//  Created by Marc Cuva on 7/19/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESEchoView : UIView
@property (strong, nonatomic) NSString *echoTitle;
@property (strong, nonatomic) NSString *echoContent;
@property (strong, nonatomic) NSDate *created;
@property (strong, nonatomic) NSString *username;

@property (nonatomic) NSInteger upvotes;
@property (nonatomic) NSInteger downvotes;
@property (nonatomic) NSInteger activity;

- (NSInteger)desiredHeight;

- (BOOL)checkOpenEchosTap:(CGPoint)point;
@end
