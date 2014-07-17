//
//  Echo.m
//  The Echo Spot
//
//  Created by Marc Cuva on 6/4/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESEcho.h"

@implementation ESEcho

- (NSString *)description{
    return [NSString stringWithFormat:@"{title: %@, content: %@, Author Name: %@}", self.title, self.content, self.author.username];
}

@end
