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
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"testechos" ofType:@"json"];
    NSError *err;
    NSData *json = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&err];
    if(err) {
        NSLog(@"%@", [err description]);
    }
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:&err];
    if(err){
        NSLog(@"%@", [err description]);
    }
    NSLog(@"%@", [jsonObject[@"echos"] description]);
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    for( NSDictionary *echo in jsonObject[@"echos"]){
        ESEcho *newEcho = [[ESEcho alloc] init];
        newEcho.title = echo[@"title"];
        newEcho.content = echo[@"content"];
        [returnArray addObject:newEcho];
    }
    
    NSLog(@"%@", [returnArray description]);
    
    return returnArray;
}

@end
