//
//  ESEchoFetcher.m
//  The Echo Spot
//
//  Created by Marc Cuva on 6/4/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESEchoFetcher.h"
#import "ESCategory.h"
#import "ESComment.h"
#import "ESDiscussion.h"
#import "constants.h"
#import "ESAuthenticator.h"

@implementation ESEchoFetcher

typedef enum {
    sortTrending,
    sortVotes,
    sortRecent
} sortType;

+ (NSArray *)getDataForURL: (NSString *)url{
    NSError *err;
    NSURL *jsonUrl = [NSURL URLWithString:url];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSData *json = [NSData dataWithContentsOfURL: jsonUrl options:NSDataReadingMappedIfSafe error:&err];
   [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(err) {
        NSLog(@"Error Loading URL: %@", [err description]);
        return nil;
    }
    
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:&err];
    if(err){
        NSLog(@"%@", [err description]);
    }
    return jsonObject;
}

+ (NSArray *)loadEchosOnPage:(int)page{
    
    NSArray *jsonObject = [self getDataForURL:[self echoURLWithUser:[[ESAuthenticator sharedAuthenticator] currentUser] index:page sortType:sortTrending]];
    
    if(jsonObject == nil){
        return nil;
    }
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    for( NSDictionary *echo in jsonObject){
        ESEcho *newEcho = [[ESEcho alloc] init];
        newEcho.title = echo[@"title"];
        newEcho.echoID = [echo[@"id"] intValue];
        newEcho.imageURL = [NSURL URLWithString:echo[@"imageURL"]];
        
        if([echo[@"votes_up"] isKindOfClass:[NSNull class]]){
            newEcho.votesUp = 0;
        }else{
            newEcho.votesUp = [echo[@"votes_up"] intValue];
        }
        
        if([echo[@"votes_down"] isKindOfClass:[NSNull class]]){
            newEcho.votesDown = 0;
        }else{
             newEcho.votesDown = [echo[@"votes_down"] intValue];   
        }
        
        newEcho.activity = [echo[@"activity"] intValue];
        newEcho.content = echo[@"content"];
        newEcho.created = [NSDate dateWithTimeIntervalSince1970:[echo[@"created_at"] doubleValue]];
        newEcho.category = [[ESCategory alloc] initWithName:echo[@"category"][@"name"] andCatID:[echo[@"category"][@"id"] intValue]];
        NSLog(@"%@ %i", newEcho.title, [echo[@"voted_on"] intValue]);
        newEcho.voteStatus = [echo[@"voted_on"] intValue];
        
        if(echo[@"user"] == [NSNull null]){
            newEcho.author = [ESUser deletedUser];
        }else if([echo[@"anonymous"] boolValue] == 1){
            newEcho.author = [ESUser anonymousUser];
        }else{
            newEcho.author = [[ESUser alloc] initWithName:echo[@"user"][@"username"] andID:[echo[@"user"][@"id"] intValue]];
        }
        [returnArray addObject:newEcho];
    }
    
    return returnArray;
}

+ (NSArray *)loadCommentsForEcho: (NSInteger)echoID{
    NSArray *jsonObject = [self getDataForURL:[self commentURLWithUser:0 echoID:(int)echoID sortType:sortTrending]];
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *comment in jsonObject) {
        ESComment *newComment = [[ESComment alloc] init];
        newComment.comment_text = comment[@"content"];
        newComment.commentID = [comment[@"id"] intValue];
        if([comment[@"anonymous"] boolValue] == 1){
            newComment.author = [ESUser anonymousUser];
        }else{
            newComment.author = [[ESUser alloc] initWithName:comment[@"user"][@"username"] andID:[comment[@"user"][@"id"] intValue]];    
        }

        if([comment[@"votes_down"] isKindOfClass:[NSNull class]]){
            newComment.votesDown = 0;
        }else{
            newComment.votesDown = [comment[@"votes_down"] intValue];
        }
        
        if([comment[@"votes_up"] isKindOfClass:[NSNull class]]){
            newComment.votesUp = 0;
        }else{
            newComment.votesUp = [comment[@"votes_up"] intValue];
        }
        
        newComment.created = [NSDate dateWithTimeIntervalSince1970:[comment[@"created_at"] intValue]];
        NSMutableArray *discussions = [[NSMutableArray alloc] init];
        for(NSDictionary *discussion in comment[@"discussions"]){
            ESDiscussion *newDiscussion = [[ESDiscussion alloc] init];
            newDiscussion.discussionID = [discussion[@"id"] intValue];
            newDiscussion.discussion_text = discussion[@"content"];
            if([discussion[@"anonymous"] boolValue] == 1){
                newDiscussion.author = [ESUser anonymousUser];
            }else{
                newDiscussion.author = [[ESUser alloc] initWithName:discussion[@"user"][@"username"] andID:[discussion[@"user"][@"id"] intValue]];
            }
            newDiscussion.created = [NSDate dateWithTimeIntervalSince1970:[discussion[@"created_at"] intValue]];
            [discussions addObject:newDiscussion];
        }
        newComment.discussions = discussions;
        
        [returnArray addObject:newComment];
        
    }
    
    return returnArray;
}

+ (NSString *)nameForSortType: (sortType)type{
    return @"votes_up";
}

+ (NSString *)echoURLWithUser: (int)userID index: (int)index sortType: (sortType)sortType{
    NSString *sort = [self nameForSortType:sortType];
    return [NSString stringWithFormat:@"%@echo/%i/%i/%@", BASE_URL, userID, index, sort];
}

+ (NSString *)commentURLWithUser: (int)userID echoID: (int)echoID sortType: (sortType)sortType{
    NSString *sort = [self nameForSortType:sortType];
    return [NSString stringWithFormat:@"%@comment/%i/%i/%@", BASE_URL, echoID, userID, sort];
}

@end
