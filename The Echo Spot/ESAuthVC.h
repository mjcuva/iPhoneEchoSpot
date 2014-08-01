//
//  ESAuthVC.h
//  The Echo Spot
//
//  Created by Marc Cuva on 7/30/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completion)();

@interface ESAuthVC : UIViewController
@property (nonatomic, copy) completion callback;
@end
