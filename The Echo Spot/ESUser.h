//
//  ESUser.h
//  The Echo Spot
//
//  Created by Marc Cuva on 6/4/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESUser : NSObject

@property (strong, nonatomic) NSString *username;
@property (nonatomic) NSInteger userID;
@property (strong, nonatomic) NSSet *echos;


- (id)initWithName: (NSString *)name andID: (NSInteger) userID;

+ (ESUser *)anonymousUser;

+ (ESUser *)deletedUser;

@end
