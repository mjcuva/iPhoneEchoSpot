//
//  ESAuthenticator.h
//  The Echo Spot
//
//  Created by Marc Cuva on 7/27/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESAuthenticator : NSObject

/**
 Gets shared instance of class to use for all authentication. Should never instantiate class directly.
 @return Static instance of class
*/
+ (id)sharedAuthenticator;

/**
 Checks if a user is logged in
 @return YES if valid user is logged in
*/
- (BOOL)isLoggedIn;

/**
 Logs user in if user and password valid
 @param username
        Username string entered by user
 @param password
        Password string entered by user
 @return YES if login was successful
*/
- (BOOL)loginWithUsername: (NSString *)username andPassword: (NSString *)password;

- (BOOL)createAccountWithUsername: (NSString *)username andPassword: (NSString *)password;

/**
 Logs out user
 @return YES if logout was successful
*/
- (BOOL)logout;

- (int)currentUser;

+ (int)horribleProgrammingCurrentUser;

@end
