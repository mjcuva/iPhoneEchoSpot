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

+ (int)horribleProgrammingCurrentUser{
    return currentUser;
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
    if(![userID isEqualToString:@""]){
        currentUser = [userID intValue];
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)loginWithUsername: (NSString *)username andPassword: (NSString *)password{

    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"EchoSpot" accessGroup:nil];
    
    username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    password = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *post = [NSString stringWithFormat:@"email=%@&password=%@", username, password];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[self loginURL]]];
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
    
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([str rangeOfCharacterFromSet:notDigits].location == NSNotFound){
        [keychainItem setObject:str forKey:(__bridge id)kSecAttrAccount];
        currentUser = [str intValue];
        return YES;
    }else{
        return NO;
    }
}

- (NSString *)loginURL{
    return [NSString stringWithFormat:@"%@%@", BASE_URL, LOGIN_URL];
}

- (BOOL)logout{
    // Logout returning success
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"EchoSpot" accessGroup:nil];
    [keychainItem resetKeychainItem];
    return YES;
}

@end
