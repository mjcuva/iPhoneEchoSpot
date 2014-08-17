//
//  ESAuthenticator.m
//  The Echo Spot
//
//  Created by Marc Cuva on 7/27/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESAuthenticator.h"
#import "KeychainItemWrapper.h" 
#import "constants.h"

@implementation ESAuthenticator

static int currentUser = 0;

- (int)currentUser{
    if([self isLoggedIn]){
        return currentUser;
    }else{
        return 0;
    }
}

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
    if(![userID isEqualToString:@""] && [self isValidUser:[userID intValue]]){
        currentUser = [userID intValue];
        return YES;
    }else{
        [self logout];
        return NO;
    }
}

- (BOOL)isValidUser: (int)userID{
    NSString *urlString = [NSString stringWithFormat:@"%@user/%i", BASE_URL, userID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *json = [NSData dataWithContentsOfURL: url options:NSDataReadingMappedIfSafe error:NULL];
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:NULL];
    if([jsonObject isKindOfClass:[NSNull class]]){
        return NO;
    }else{
        return YES;
    }
}

- (NSString *)loginWithUsername: (NSString *)username andPassword: (NSString *)password{

    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"EchoSpot" accessGroup:nil];
    
    username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    password = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *response = [self postRequestWithUsername:username password:password andURL:[self loginURL]];
    
    NSLog(@"%@", response);
        
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([response rangeOfCharacterFromSet:notDigits].location == NSNotFound){
        [keychainItem setObject:response forKey:(__bridge id)kSecAttrAccount];
        currentUser = [response intValue];
        return response;
    }else{
        return response;
    }
}

- (NSString *)createAccountWithUsername: (NSString *)username andPassword: (NSString *)password{
    
    username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    password = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *response = [self postRequestWithUsername:username password:password andURL:[self signupURL]];
    if ([response isEqualToString:[username componentsSeparatedByString:@"@"][0]]) {
        return response;
    }else{
        return response;
    }
}

- (NSString *)postRequestWithUsername: (NSString *)username password: (NSString *)password andURL: (NSString *)url{
    NSString *post = [NSString stringWithFormat:@"email=%@&password=%@", username, password];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(error){
        NSLog(@"%@", [error description]);
    }
    NSString *str=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    return str;
}

- (NSString *)loginURL{
    return [NSString stringWithFormat:@"%@%@", BASE_URL, LOGIN_URL];
}

- (NSString *)signupURL{
    return [NSString stringWithFormat:@"%@%@", BASE_URL, SIGNUP_URL];
}

- (BOOL)logout{
    // Logout returning success
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"EchoSpot" accessGroup:nil];
    [keychainItem resetKeychainItem];
    return YES;
}

@end
