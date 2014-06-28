//
//  AutosizingLabel.m
//  The Echo Spot
//
//  Created by Marc Cuva on 6/28/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "AutosizingLabel.h"

@implementation AutosizingLabel

#define MIN_HEIGHT 10

- (void)calculateSize{
    NSDictionary *attributes = @{NSFontAttributeName: self.font};
    
    CGRect size = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, 2000.0)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attributes
                                            context:nil];
    
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    [self setAdjustsFontSizeToFitWidth:NO];
    [self setNumberOfLines:0];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.size.height)];
}

- (void)setText:(NSString *)text{
    [super setText:text];
    [self calculateSize];
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    [self calculateSize];
}

@end
