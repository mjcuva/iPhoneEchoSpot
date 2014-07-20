//
//  ESDiscussion.h
//  The Echo Spot
//
//  Created by Marc Cuva on 7/20/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESUser.h"

@interface ESDiscussion : NSObject
@property (nonatomic) NSInteger discussionID;
@property (strong, nonatomic) NSString *discussion_text;
@property (strong, nonatomic) ESUser *author;
@property (strong, nonatomic) NSDate *created;
@end
