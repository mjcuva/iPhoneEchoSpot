//
//  ESUser.m
//  The Echo Spot
//
//  Created by Marc Cuva on 6/4/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESUser.h"

@implementation ESUser

- (id)initWithName:(NSString *)name andID:(NSInteger)userID{
    if(self = [super init]){
        self.userID = userID;
        self.username = name;
    }
    return self;
}

@end
