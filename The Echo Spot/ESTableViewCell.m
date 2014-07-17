
//  ESTableViewCell.m
//  The Echo Spot
//
//  Created by Marc Cuva on 6/7/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESTableViewCell.h"
#import "AutosizingLabel.h"
#import "constants.h"
#import "ThemeManager.h"
#import "NSDate+TimeAgo.h"

@interface ESTableViewCell()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) AutosizingLabel *detailLabel;
@property (strong, nonatomic) UIImageView *upvote;
@property (strong, nonatomic) UIImageView *downvote;
@property (strong, nonatomic) UIImageView *comment;
@property (strong, nonatomic) UILabel *upvoteCount;
@property (strong, nonatomic) UILabel *downvoteCount;
@property (strong, nonatomic) UILabel *commentCount;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *userLabel;
@end

@implementation ESTableViewCell

#define TOP_PADDING 10
#define DETAIL_PADDING 10
#define END_PADDING 40

#define BUTTON_LEFT_MARGIN 20
#define BUTTON_OFFSET 10
#define BUTTON_SEPERATION 35

#define TIME_LABEL_OFFSET 35

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, TOP_PADDING, self.frame.size.width - 50, 44)];
        self.titleLabel.textColor = [[ThemeManager sharedManager] fontColor];
        self.titleLabel.text = self.echoTitle;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        
        self.detailLabel = [[AutosizingLabel alloc] initWithFrame:CGRectMake(15, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + DETAIL_PADDING, self.frame.size.width - 25, 0)];
        self.detailLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        self.detailLabel.textColor = [[ThemeManager sharedManager] fontColor];
        
        UIImage *upvoteImage = [[UIImage imageNamed:@"upvote.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImage *downvoteImage = [[UIImage imageNamed:@"downvote.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImage *commentImage = [[UIImage imageNamed:@"comment.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.upvote = [[UIImageView alloc] initWithImage:upvoteImage];
        self.downvote = [[UIImageView alloc] initWithImage:downvoteImage];
        self.comment = [[UIImageView alloc] initWithImage:commentImage];
        
        self.upvoteCount = [[UILabel alloc] init];
        self.upvoteCount.text = @"0";
        self.upvoteCount.textColor = GREEN_COLOR;
        [self.upvoteCount sizeToFit];
        
        self.downvoteCount = [[UILabel alloc] init];
        self.downvoteCount.text = @"0";
        self.downvoteCount.textColor = [UIColor colorWithRed:240/255.0f green:119/255.0f blue:116/255.0f alpha:1.0f];
        [self.downvoteCount sizeToFit];
        
        self.commentCount = [[UILabel alloc] init];
        self.commentCount.text = @"0";
        self.commentCount.textColor = [[ThemeManager sharedManager] fontColor];
        [self.commentCount sizeToFit];
        
        
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.text = [self.created timeAgoSimple];
        [self.timeLabel sizeToFit];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel.frame = CGRectMake(self.frame.size.width - TIME_LABEL_OFFSET, TOP_PADDING + 3, self.timeLabel.frame.size.width, self.timeLabel.frame.size.height);
        
        self.userLabel = [[UILabel alloc] init];
        self.userLabel.text = self.username;
        self.userLabel.font = [UIFont systemFontOfSize:13];
        [self.userLabel sizeToFit];
        
        [self updateControlFrames];
        
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.upvote];
        [self.contentView addSubview:self.downvote];
        [self.contentView addSubview:self.comment];
        [self.contentView addSubview:self.upvoteCount];
        [self.contentView addSubview:self.downvoteCount];
        [self.contentView addSubview:self.commentCount];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.userLabel];
    }
    
    return self;
}

- (void)updateControlFrames{
    
    self.detailLabel.frame = CGRectMake(15, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + DETAIL_PADDING, self.frame.size.width - 25, self.detailLabel.frame.size.height);

    self.upvote.frame = CGRectMake(BUTTON_LEFT_MARGIN, [self desiredHeight] - self.upvote.frame.size.height - BUTTON_OFFSET, self.upvote.frame.size.width, self.upvote.frame.size.height);
    self.downvote.frame = CGRectMake(self.upvote.frame.size.width + BUTTON_LEFT_MARGIN + BUTTON_SEPERATION, [self desiredHeight] - self.downvote.frame.size.height - BUTTON_OFFSET, self.downvote.frame.size.width, self.downvote.frame.size.height);
    self.comment.frame = CGRectMake(self.upvote.frame.size.width + self.downvote.frame.size.width + (BUTTON_LEFT_MARGIN + BUTTON_SEPERATION * 2), [self desiredHeight] - self.comment.frame.size.height - BUTTON_OFFSET, self.comment.frame.size.width, self.comment.frame.size.height);
    
    self.upvoteCount.frame = CGRectMake(self.upvote.frame.origin.x + self.upvote.frame.size.width + 10, self.upvote.frame.origin.y, self.upvoteCount.frame.size.width, self.upvoteCount.frame.size.height);
    self.downvoteCount.frame = CGRectMake(self.downvote.frame.origin.x + self.downvote.frame.size.width + 10, self.downvote.frame.origin.y, self.downvoteCount.frame.size.width, self.downvoteCount.frame.size.height);
    self.commentCount.frame = CGRectMake(self.comment.frame.origin.x + self.comment.frame.size.width + 10, self.comment.frame.origin.y, self.commentCount.frame.size.width, self.commentCount.frame.size.height);
    
    self.userLabel.frame = CGRectMake(self.frame.size.width - self.userLabel.frame.size.width - 10, self.commentCount.frame.origin.y, self.userLabel.frame.size.width, self.userLabel.frame.size.height);
    
    self.commentCount.textColor = [[ThemeManager sharedManager] detailFontColor];
    self.userLabel.textColor = [[ThemeManager sharedManager] detailFontColor];
    self.timeLabel.textColor = [[ThemeManager sharedManager] detailFontColor];
}

- (void)setEchoTitle:(NSString *)echoTitle{
    _echoTitle = echoTitle;
    self.titleLabel.text = echoTitle;
    [self updateControlFrames];
    self.titleLabel.textColor = [[ThemeManager sharedManager] fontColor];
    [self.titleLabel sizeToFit];
}

- (void)setEchoContent:(NSString *)echoContent{
    _echoContent = echoContent;
    self.detailLabel.text = echoContent;
    [self updateControlFrames];
    self.detailLabel.textColor = [[ThemeManager sharedManager] fontColor];
}

- (void)setCreated:(NSDate *)created{
    _created = created;
    self.timeLabel.text = [_created timeAgoSimple];
    [self updateControlFrames];
    self.timeLabel.textColor = [UIColor blackColor];
    [self.timeLabel sizeToFit];
}

- (void)setUsername:(NSString *)username{
    _username = username;
    self.userLabel.text = _username;
    [self.userLabel sizeToFit];
    [self updateControlFrames];
}

- (NSInteger)desiredHeight{
    if([self.echoContent isEqualToString:@""]){
        return 88;
    }
    return self.titleLabel.frame.size.height + self.detailLabel.frame.size.height + TOP_PADDING + DETAIL_PADDING + END_PADDING;
}

@end
