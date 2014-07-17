//
//  Echo.h
//  The Echo Spot
//
//  Created by Marc Cuva on 6/4/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ESUser.h"
#import "ESCategory.h"

@interface ESEcho : NSObject

@property (strong, nonatomic) NSString *title;
@property (nonatomic) NSInteger echoID;
@property (strong, nonatomic) NSURL *imageURL;
@property (nonatomic) NSInteger votesUp;
@property (nonatomic) NSInteger votesDown;
@property (nonatomic) NSInteger activity;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSDate *created;
@property (strong, nonatomic) ESCategory *category;
@property (strong, nonatomic) ESUser *author;

@end
