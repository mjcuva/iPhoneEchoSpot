//
//  ThemeManager.h
//  The Echo Spot
//
//  Created by Marc Cuva on 7/6/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeManager : NSObject

+ (id)sharedManager;

@property (readonly) UIColor *themeColor;
@property (readonly) UIColor *lightBackgroundColor;
@property (readonly) UIColor *darkBackgroundColor;
@property (nonatomic, readonly) UIColor *fontColor;
@property (nonatomic, readonly) UIColor *navBarColor;

- (void)configureTheme;

@end
