//
//  ESAppDelegate.m
//  The Echo Spot
//
//  Created by Marc Cuva on 5/29/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESAppDelegate.h"
#import <HockeySDK/HockeySDK.h>

@implementation ESAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"228358785274394fec3175c9903a1f2c"];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator
     authenticateInstallation];

    
    // Override point for customization after application launch.
    
//    [[UIView appearance] setTintColor:[UIColor colorWithRed:0.149 green:0.906 blue:0.584 alpha:1]]; /*#26e795*/
    [[UIView appearance] setTintColor:[UIColor colorWithRed:0/255.0f green:231/255.0f blue:161/255.0f alpha:1.0f]];
    
    [[UISegmentedControl appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{ NSFontAttributeName:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]],
                                                               NSForegroundColorAttributeName:[UIColor blackColor] } forState:UIControlStateNormal];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];

    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
