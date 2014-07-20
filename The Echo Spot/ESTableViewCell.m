
//  ESTableViewCell.m
//  The Echo Spot
//
//  Created by Marc Cuva on 6/7/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESTableViewCell.h"
#import "ESEchoView.h"


@interface ESTableViewCell()
@property (strong, nonatomic) ESEchoView *echoView;
@end

@implementation ESTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.echoView = [[ESEchoView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.echoView.echoTitle = self.echoTitle;
        self.echoView.echoContent = self.echoContent;
        self.echoView.created = self.created;
        self.echoView.username = self.username;
        [self.contentView addSubview:self.echoView];
    }
    return self;
}

- (NSInteger)desiredHeight{
    return [self.echoView desiredHeight];
}

- (void)setEchoTitle:(NSString *)echoTitle{
    _echoTitle = echoTitle;
    self.echoView.echoTitle = _echoTitle;
}

- (void)setEchoContent:(NSString *)echoContent{
    _echoContent = echoContent;
    self.echoView.echoContent = _echoContent;
}

- (void)setCreated:(NSDate *)created{
    _created = created;
    self.echoView.created = _created;
}

- (void)setUsername:(NSString *)username{
    _username = username;
    self.echoView.username = _username;
}

- (void)setUpvotes:(NSInteger)upvotes{
    _upvotes = upvotes;
    self.echoView.upvotes = _upvotes;
}


- (void)setDownvotes:(NSInteger)downvotes{
    _downvotes = downvotes;
    self.echoView.downvotes = _downvotes;
}

- (void)setActivity:(NSInteger)activity{
    _activity = activity;
    self.echoView.activity = _activity;
}

- (BOOL)checkOpenEchosTap:(CGPoint)point{
    return [self.echoView checkOpenEchosTap:point];
}

@end
