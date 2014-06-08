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
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < 10; i++){
        ESEcho *echo = [[ESEcho alloc] init];
        echo.title = [NSString stringWithFormat:@"Test %i", i];
        echo.content = [NSString stringWithFormat: @"This is echo number: %i", i];
        echo.author = [[ESUser alloc] init];
        
        [returnArray addObject:echo];
    }
    
    return returnArray;
}

@end
