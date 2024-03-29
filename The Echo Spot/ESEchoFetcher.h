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

typedef enum {
    sortTrending,
    sortVotes,
    sortRecent
} sortType;

+ (NSArray *)loadEchosOnPage:(int)page withSorting: (sortType) sorting;

+ (NSArray *)loadCommentsForEcho: (NSInteger)echoID;

+ (NSString *)usernameForCurrentUser;

+ (NSArray *)echosForUser:(int)user;

+ (BOOL)voteOnPostType: (NSString *)type withID: (int)echoID withValue: (int)voteType;

+ (BOOL)postComment: (NSString *)content onEchoID: (int)echoID anonymously: (BOOL)anon;

+ (BOOL)postDiscussion: (NSString *)content onCommentID: (int)commentID anonymously: (BOOL)anon;

+ (BOOL)postEchoWithData: (NSDictionary *)data;

@end
