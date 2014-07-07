//
//  ThemeManager.m
//  The Echo Spot
//
//  Created by Marc Cuva on 7/6/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ThemeManager.h"
#import "constants.h"

@interface ThemeManager()
@property (strong, nonatomic, readwrite) UIColor *themeColor;
@property (strong, nonatomic, readwrite) UIColor *lightBackgroundColor;
@property (strong, nonatomic, readwrite) UIColor *darkBackgroundColor;
@property (strong, nonatomic, readwrite) UIColor *fontColor;
@end

@implementation ThemeManager

+ (id)sharedManager{
    static ThemeManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void)configureTheme{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *theme = [defaults stringForKey:@"theme"];
    
    if([theme isEqualToString:@"greenwhite"]){
        self.themeColor = GREEN_COLOR;
        self.lightBackgroundColor = [UIColor whiteColor];
        self.darkBackgroundColor = [UIColor whiteColor];
        self.fontColor = [UIColor blackColor];
    }else if ([theme isEqualToString:@"redwhite"]){
        self.themeColor = SALMON_COLOR;
        self.lightBackgroundColor = [UIColor whiteColor];
        self.darkBackgroundColor = [UIColor whiteColor];
        self.fontColor = [UIColor blackColor];
    }else if([theme isEqualToString:@"greendark"]){
        self.themeColor = GREEN_COLOR;
        self.lightBackgroundColor = LIGHT_GRAY_COLOR;
        self.darkBackgroundColor = DARK_GRAY_COLOR;
        self.fontColor = [UIColor whiteColor];
    }
    
    [[UITableView appearance] setTintColor:self.themeColor];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:self.themeColor } forState:UIControlStateNormal];
}

- (UIColor *)fontColor{
    if(_fontColor != nil){
        return _fontColor;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *theme = [defaults stringForKey:@"theme"];
    if([theme isEqualToString:@"greenwhite"] || [theme isEqualToString:@"redwhite"]){
        return [UIColor blackColor];
    }else{
        return [UIColor whiteColor];
    }
}

- (UIColor *)navBarColor{
    if(self.lightBackgroundColor != [UIColor whiteColor]){
        return [UIColor whiteColor];
    }else{
        return self.themeColor;
    }
}

@end
