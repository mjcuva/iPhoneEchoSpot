//
//  ESAuthenticator.m
//  The Echo Spot
//
//  Created by Marc Cuva on 7/27/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESAuthenticator.h"

@implementation ESAuthenticator

static BOOL loggedIn = NO;

+ (id)sharedAuthenticator{
    static ESAuthenticator *sharedAuthenticator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAuthenticator = [[self alloc] init];
    });
    return sharedAuthenticator;
}

- (BOOL)isLoggedIn{
    // Check token
    return loggedIn;
}

- (BOOL)loginWithUsername: (NSString *)username andPassword: (NSString *)password{
    // Login returning success
    // actually log in
    loggedIn = YES;
    return YES;
}

- (BOOL)logout{
    // Logout returning success
    loggedIn = NO;
    return YES;
}

@end
