//
//  ESTableViewCell.m
//  The Echo Spot
//
//  Created by Marc Cuva on 6/7/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESTableViewCell.h"

@interface ESTableViewCell()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@end

@implementation ESTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, self.frame.size.width, 44)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.text = self.echoTitle;
        [self.titleLabel sizeToFit];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 40, self.frame.size.width, self.frame.size.height - self.titleLabel.frame.size.height)];
        self.detailLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        self.detailLabel.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
        
        
    }
    return self;
}

- (void)setEchoTitle:(NSString *)echoTitle{
    _echoTitle = echoTitle;
    self.titleLabel.text = echoTitle;
    [self.titleLabel sizeToFit];
}

- (void)setEchoContent:(NSString *)echoContent{
    _echoContent = echoContent;
    self.detailLabel.text = echoContent;
    [self.detailLabel sizeToFit];
}

@end
