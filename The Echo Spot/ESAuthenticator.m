//
//  ESAuthenticator.m
//  The Echo Spot
//
//  Created by Marc Cuva on 7/27/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESAuthenticator.h"
#import "KeychainItemWrapper.h"

@implementation ESAuthenticator

+ (id)sharedAuthenticator{
    static ESAuthenticator *sharedAuthenticator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAuthenticator = [[self alloc] init];
    });
    return sharedAuthenticator;
}

- (BOOL)isLoggedIn{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"EchoSpot" accessGroup:nil];
    NSString *userID = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    
    // Need to check if valid id and access key
    if([userID isEqualToString:@"1"]){
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)loginWithUsername: (NSString *)username andPassword: (NSString *)password{
    // Login returning success
    // actually log in
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"EchoSpot" accessGroup:nil];
    
    // Set to actual id
    [keychainItem setObject:@"1" forKey:(__bridge id)kSecAttrAccount];
    return YES;
}

- (BOOL)logout{
    // Logout returning success
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"EchoSpot" accessGroup:nil];
    [keychainItem resetKeychainItem];
    return YES;
}

@end
