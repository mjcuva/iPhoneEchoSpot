//
//  ESEchoFetcher.h
//  The Echo Spot
//
//  Created by Marc Cuva on 6/4/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESEcho.h"

@interface ESEchoFetcher : NSObject

+ (NSArray *)loadEchosOnPage:(int)page;

+ (NSArray *)loadCommentsForEcho: (NSInteger)echoID;

+ (NSString *)usernameForCurrentUser;

+ (NSArray *)echosForUser:(int)user;

+ (BOOL)voteOnPostType: (NSString *)type withID: (int)echoID withValue: (int)voteType;

@end
