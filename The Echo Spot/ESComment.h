//
//  ESComment.h
//  The Echo Spot
//
//  Created by Marc Cuva on 7/20/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESUser.h"

@interface ESComment : NSObject
@property (strong, nonatomic) NSString *comment_text;
@property (nonatomic) NSInteger commentID;
@property (nonatomic) NSInteger votesUp;
@property (nonatomic) NSInteger votesDown;
@property (nonatomic) NSArray *discussions;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) ESUser *author;
@end
