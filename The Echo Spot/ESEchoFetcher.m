//
//  ESEchoFetcher.m
//  The Echo Spot
//
//  Created by Marc Cuva on 6/4/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESEchoFetcher.h"

@implementation ESEchoFetcher

+ (NSArray *)loadRecentEchos{
    
    NSError *err;
    NSURL *jsonUrl = [NSURL URLWithString:@"http://theechospot.com/echos.json"];
    NSData *json = [NSData dataWithContentsOfURL: jsonUrl options:NSDataReadingMappedIfSafe error:&err];
    if(err) {
        NSLog(@"%@", [err description]);
    }
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:&err];
    if(err){
        NSLog(@"%@", [err description]);
    }
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    for( NSDictionary *echo in jsonObject[@"echos"]){
        ESEcho *newEcho = [[ESEcho alloc] init];
        newEcho.title = echo[@"title"];
        newEcho.content = echo[@"content"];
        [returnArray addObject:newEcho];
    }
    
    return returnArray;
}

@end
