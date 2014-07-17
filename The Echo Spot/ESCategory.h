//
//  ESCategory.h
//  The Echo Spot
//
//  Created by Marc Cuva on 7/13/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESCategory : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger catID;

- (id) initWithName: (NSString *)name andCatID: (NSInteger)catID;
@end
