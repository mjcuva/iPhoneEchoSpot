//
//  ESCategory.m
//  The Echo Spot
//
//  Created by Marc Cuva on 7/13/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESCategory.h"

@implementation ESCategory

- (id) initWithName: (NSString *)name andCatID: (NSInteger)catID{
    if(self = [super init]){
        self.name = name;
        self.catID = catID;
    }
    return self;
}

@end
