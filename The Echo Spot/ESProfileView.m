//
//  ESProfileView.m
//  The Echo Spot
//
//  Created by Marc Cuva on 7/25/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESProfileView.h"

@interface ESProfileView()
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *profileImageView;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation ESProfileView

- (UIImage *)profileImage{
    if(!_profileImage){
        // Return placeholder
    }
    return _profileImage;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor orangeColor];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2, self.frame.size.height / 2, 0, 0)];
        self.nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (void)setUsername:(NSString *)username{
    _username = username;
    self.nameLabel.text = username;
    [self.nameLabel sizeToFit];
    self.nameLabel.frame = CGRectMake(self.frame.size.width / 2 - self.nameLabel.frame.size.width / 2, self.frame.size.height / 2, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
}

@end
