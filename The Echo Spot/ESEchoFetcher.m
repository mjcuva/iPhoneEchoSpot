//
//  ESEchoFetcher.m
//  The Echo Spot
//
//  Created by Marc Cuva on 6/4/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESEchoFetcher.h"
#import "ESCategory.h"

@implementation ESEchoFetcher

+ (NSArray *)loadRecentEchos{
    
    NSError *err;
    NSURL *jsonUrl = [NSURL URLWithString:@"http://theechospot.com/echos.json"];
    NSData *json = [NSData dataWithContentsOfURL: jsonUrl options:NSDataReadingMappedIfSafe error:&err];
    if(err) {
        NSLog(@"%@", [err description]);
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"testechos" ofType:@"json"];
        json = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:NULL];
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"testechos" ofType:@"json"];
    json = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:NULL];
    
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:&err];
    if(err){
        NSLog(@"%@", [err description]);
    }
    
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

@end
