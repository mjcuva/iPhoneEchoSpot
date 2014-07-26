//
//  ESProfileView.m
//  The Echo Spot
//
//  Created by Marc Cuva on 7/25/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESProfileView.h"
#import "ThemeManager.h"

@interface ESProfileView()
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *profileImageView;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation ESProfileView

@synthesize profileImage = _profileImage;

- (UIImage *)profileImage{
    if(!_profileImage){
        return [UIImage imageNamed:@"blankProfileImage.png"];
    }
    return _profileImage;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [[ThemeManager sharedManager] themeColor];
        UIImage *backgroundImage = [UIImage imageNamed:@"profileBackground.png"];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        backgroundImageView.image = backgroundImage;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2, self.frame.size.height / 2 + 10, 0, 0)];
        self.nameLabel.textColor = [UIColor whiteColor];
        
        self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - self.profileImage.size.width / 2, self.frame.size.height/2 - self.profileImage.size.height, self.profileImage.size.width, self.profileImage.size.height)];
        self.profileImageView.image = self.profileImage;
        
        [self addSubview:backgroundImageView];
        [self addSubview:self.profileImageView];
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (void)setUsername:(NSString *)username{
    _username = username;
    self.nameLabel.text = username;
    [self.nameLabel sizeToFit];
    self.nameLabel.frame = CGRectMake(self.frame.size.width / 2 - self.nameLabel.frame.size.width / 2, self.nameLabel.frame.origin.y, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
}

- (void)setProfileImage:(UIImage *)profileImage{
    _profileImage = profileImage;
    self.profileImageView.image = profileImage;
}

@end
