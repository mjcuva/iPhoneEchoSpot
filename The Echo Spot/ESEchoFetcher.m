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

@implementation ESEchoFetcher

+ (NSDictionary *)getDataForURL: (NSString *)url orResource: (NSString *)resource{
    NSError *err;
    NSURL *jsonUrl = [NSURL URLWithString:url];
    NSData *json = [NSData dataWithContentsOfURL: jsonUrl options:NSDataReadingMappedIfSafe error:&err];
    if(err) {
        NSLog(@"%@", [err description]);
        NSString *filePath = [[NSBundle mainBundle] pathForResource:resource ofType:@"json"];
        json = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:NULL];
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:resource ofType:@"json"];
    json = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:NULL];
    
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:&err];
    if(err){
        NSLog(@"%@", [err description]);
    }
    return jsonObject;
}

+ (NSArray *)loadRecentEchos{
    
    NSDictionary *jsonObject = [self getDataForURL:@"http://theechospot.com/echos.json" orResource:@"testechos"];
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    for( NSDictionary *echo in jsonObject[@"echos"]){
        ESEcho *newEcho = [[ESEcho alloc] init];
        newEcho.title = echo[@"title"];
        newEcho.echoID = [echo[@"id"] intValue];
        newEcho.imageURL = [NSURL URLWithString:echo[@"imageURL"]];
        newEcho.votesUp = [echo[@"votes_up"] intValue];
        newEcho.votesDown = [echo[@"votes_down"] intValue];
        newEcho.activity = [echo[@"activity"] intValue];
        newEcho.content = echo[@"content"];
        newEcho.created = [NSDate dateWithTimeIntervalSince1970:[echo[@"created"] intValue]];
        newEcho.category = [[ESCategory alloc] initWithName:echo[@"category"][@"name"] andCatID:[echo[@"category"][@"id"] intValue]];
        newEcho.author = [[ESUser alloc] initWithName:echo[@"user"][@"userName"] andID:[echo[@"user"][@"id"] intValue]];
        [returnArray addObject:newEcho];
    }
    
    return returnArray;
}

+ (NSArray *)loadCommentsForEcho: (NSInteger)echoID{
    NSDictionary *jsonObject = [self getDataForURL:@"http://theechospot.com/echos.json" orResource:@"testcomments"];
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *comment in jsonObject[@"comments"]) {
        ESComment *newComment = [[ESComment alloc] init];
        newComment.comment_text = comment[@"comment_text"];
        newComment.commentID = [comment[@"id"] intValue];
        newComment.author = [[ESUser alloc] initWithName:comment[@"user"][@"username"] andID:[comment[@"user"][@"id"] intValue]];
        newComment.votesDown = [comment[@"votes_down"] intValue];
        newComment.votesUp = [comment[@"votes_up"] intValue];
        newComment.created = [NSDate dateWithTimeIntervalSince1970:[comment[@"created"] intValue]];
        NSMutableArray *discussions = [[NSMutableArray alloc] init];
        for(NSDictionary *discussion in comment[@"discussions"]){
            ESDiscussion *newDiscussion = [[ESDiscussion alloc] init];
            newDiscussion.discussionID = [discussion[@"id"] intValue];
            newDiscussion.discussion_text = discussion[@"discussion_text"];
            newDiscussion.author = [[ESUser alloc] initWithName:discussion[@"user"][@"username"] andID:[discussion[@"user"][@"id"] intValue]];
            newDiscussion.created = [NSDate dateWithTimeIntervalSince1970:[discussion[@"created"] intValue]];
            [discussions addObject:newDiscussion];
        }
        newComment.discussions = discussions;
        
        [returnArray addObject:newComment];
        
    }
    
    return returnArray;
}

@end
