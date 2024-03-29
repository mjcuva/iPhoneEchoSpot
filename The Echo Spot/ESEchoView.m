//
//  ESEchoView.m
//  The Echo Spot
//
//  Created by Marc Cuva on 7/19/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESEchoView.h"
#import "AutosizingLabel.h"
#import "ThemeManager.h"
#import "NSDate+TimeAgo.h"
#import "constants.h"

@interface ESEchoView()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) AutosizingLabel *detailLabel;
@property (strong, nonatomic) UIImageView *upvote;
@property (strong, nonatomic) UIImageView *downvote;
@property (strong, nonatomic) UIImageView *comment;
@property (strong, nonatomic) UILabel *openCommentsLabel;
@property (strong, nonatomic) UILabel *upvoteCount;
@property (strong, nonatomic) UILabel *downvoteCount;
@property (strong, nonatomic) UILabel *commentCount;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *userLabel;
@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIButton *openComments;

@property (nonatomic) BOOL discussion;
@property (nonatomic) BOOL isComment;
@end

@implementation ESEchoView

#define TOP_PADDING 10
#define DETAIL_PADDING 10
#define END_PADDING 45

#define BUTTON_LEFT_MARGIN 20
#define BUTTON_OFFSET 5
#define BUTTON_SEPERATION 35

#define TIME_LABEL_OFFSET 35

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, TOP_PADDING, self.frame.size.width - 50, 44)];
        self.titleLabel.textColor = [[ThemeManager sharedManager] fontColor];
        self.titleLabel.text = self.echoTitle;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        
        self.detailLabel = [[AutosizingLabel alloc] initWithFrame:CGRectMake(15, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + DETAIL_PADDING, self.frame.size.width - 50, 0)];
        self.detailLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        self.detailLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.detailLabel.textColor = [[ThemeManager sharedManager] fontColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.detailLabel.frame.origin.y + self.detailLabel.frame.size.height + 10, self.frame.size.width, 0)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill; 
        self.imageView.clipsToBounds = YES;
        
        UIImage *upvoteImage = [[UIImage imageNamed:@"upvote.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *downvoteImage = [[UIImage imageNamed:@"downvote.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *commentImage = [[UIImage imageNamed:@"comment.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.upvote = [[UIImageView alloc] initWithImage:upvoteImage];
        self.downvote = [[UIImageView alloc] initWithImage:downvoteImage];
        self.comment = [[UIImageView alloc] initWithImage:commentImage];
        
        self.openCommentsLabel = [[UILabel alloc] init];
        [self.openCommentsLabel setText:@"Show Comments"];
        self.openCommentsLabel.font = [UIFont systemFontOfSize:12];
        self.openCommentsLabel.textColor = [[ThemeManager sharedManager] detailFontColor];
        self.openCommentsLabel.layer.borderColor = [[ThemeManager sharedManager] detailFontColor].CGColor;
        self.openCommentsLabel.layer.borderWidth = 1.0;
        self.openCommentsLabel.layer.cornerRadius = 8;
        self.openCommentsLabel.textAlignment = NSTextAlignmentCenter;
        
        self.upvoteCount = [[UILabel alloc] init];
        self.upvoteCount.text = [NSString stringWithFormat:@"%d", (int)self.upvotes];
        self.upvoteCount.textColor = GREEN_COLOR;
        [self.upvoteCount sizeToFit];
        
        self.downvoteCount = [[UILabel alloc] init];
        self.downvoteCount.text = [NSString stringWithFormat:@"%d", (int)self.downvotes];
        self.downvoteCount.textColor = [UIColor colorWithRed:240/255.0f green:119/255.0f blue:116/255.0f alpha:1.0f];
        [self.downvoteCount sizeToFit];
        
        self.commentCount = [[UILabel alloc] init];
        self.commentCount.text = [NSString stringWithFormat:@"%d", (int)self.activity];
        self.commentCount.textColor = [[ThemeManager sharedManager] fontColor];
        [self.commentCount sizeToFit];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.text = [self.created timeAgoSimple];
        [self.timeLabel sizeToFit];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        
        self.userLabel = [[UILabel alloc] init];
        self.userLabel.text = self.username;
        self.userLabel.font = [UIFont systemFontOfSize:13];
        [self.userLabel sizeToFit];
        
        [self updateControlFrames];
        
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.detailLabel];
        [self addSubview:self.imageView];
        [self addSubview:self.upvote];
        [self addSubview:self.downvote];
        [self addSubview:self.comment];
        [self addSubview:self.openCommentsLabel];
        [self addSubview:self.upvoteCount];
        [self addSubview:self.downvoteCount];
        [self addSubview:self.commentCount];
        [self addSubview:self.timeLabel];
        [self addSubview:self.userLabel];
    }
    return self;
}

- (void)updateControlFrames{
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, [self desiredHeight]);
    
    CGFloat buttonOFF = BUTTON_OFFSET;
    
//    if([self.echoContent isEqualToString:@""]){
//        self.imageView.frame = CGRectMake(0, self.detailLabel.frame.origin.y + self.detailLabel.frame.size.height - DETAIL_PADDING, self.frame.size.width, self.imageView.frame.size.height);
//    }else{
//        self.imageView.frame = CGRectMake(0, self.detailLabel.frame.origin.y + self.detailLabel.frame.size.height + 10, self.frame.size.width, self.imageView.frame.size.height);
//    }
    
    self.imageView.frame = CGRectMake(0, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 10, self.frame.size.width, self.imageView.frame.size.height);

    
    if(self.discussion){
        self.detailLabel.frame = CGRectMake(15, TOP_PADDING, self.frame.size.width - 25, self.detailLabel.frame.size.height);
    }else if(self.isComment){
//        self.detailLabel.backgroundColor = [UIColor blackColor];
        self.detailLabel.frame = CGRectMake(15, TOP_PADDING, self.frame.size.width - 45, self.detailLabel.frame.size.height);
        buttonOFF += 20;
    }else{
        self.detailLabel.frame = CGRectMake(15, self.imageView.frame.origin.y + self.imageView.frame.size.height + DETAIL_PADDING, self.frame.size.width - 25, self.detailLabel.frame.size.height);
    }
    
    if(self.voteStatus == 1){
        self.upvote.image = [UIImage imageNamed:@"upvoted"];
        self.downvote.image = [UIImage imageNamed:@"downvote"];
    }else if(self.voteStatus == -1){
        self.downvote.image = [UIImage imageNamed:@"downvoted"];
        self.upvote.image = [UIImage imageNamed:@"upvote"];
    }else if(self.voteStatus == 0){
        self.downvote.image = [UIImage imageNamed:@"downvote"];
        self.upvote.image = [UIImage imageNamed:@"upvote"];
    }

    
    self.upvote.frame = CGRectMake(BUTTON_LEFT_MARGIN, [self desiredHeight] - self.upvote.frame.size.height - buttonOFF, self.upvote.frame.size.width, self.upvote.frame.size.height);
    self.downvote.frame = CGRectMake(self.upvote.frame.size.width + BUTTON_LEFT_MARGIN + BUTTON_SEPERATION, [self desiredHeight] - self.downvote.frame.size.height - buttonOFF, self.downvote.frame.size.width, self.downvote.frame.size.height);
    self.comment.frame = CGRectMake(self.upvote.frame.size.width + self.downvote.frame.size.width + (BUTTON_LEFT_MARGIN + BUTTON_SEPERATION * 2), [self desiredHeight] - self.comment.frame.size.height - buttonOFF, self.comment.frame.size.width, self.comment.frame.size.height);
    
    self.openCommentsLabel.frame = CGRectMake(self.comment.frame.origin.x, self.comment.frame.origin.y, 105, self.comment.frame.size.height);
    
    int commentLabelOffset = 0;
    
    if(!self.isOpen && !self.discussion){
        self.openCommentsLabel.hidden = YES;
        self.comment.hidden = NO;
        self.commentCount.hidden = NO;
        commentLabelOffset = self.comment.frame.origin.x + self.comment.frame.size.width + 5;
    }else if(self.isOpen){
        self.comment.hidden = YES;
        self.openCommentsLabel.hidden = NO;
        self.commentCount.hidden = YES;
        commentLabelOffset = self.openCommentsLabel.frame.origin.x + self.openCommentsLabel.frame.size.width + 5;
    }
    
    self.upvoteCount.frame = CGRectMake(self.upvote.frame.origin.x + self.upvote.frame.size.width + 5, self.upvote.frame.origin.y, self.upvoteCount.frame.size.width, self.upvoteCount.frame.size.height);
    self.downvoteCount.frame = CGRectMake(self.downvote.frame.origin.x + self.downvote.frame.size.width + 5, self.downvote.frame.origin.y, self.downvoteCount.frame.size.width, self.downvoteCount.frame.size.height);
    self.commentCount.frame = CGRectMake(commentLabelOffset, self.comment.frame.origin.y, self.commentCount.frame.size.width, self.commentCount.frame.size.height);
    
    if(self.discussion){
        self.timeLabel.frame = CGRectMake(15, self.commentCount.frame.origin.y, self.timeLabel.frame.size.width, self.timeLabel.frame.size.height);
        buttonOFF += 10;
    }else{
        self.timeLabel.frame = CGRectMake(self.frame.size.width - self.timeLabel.frame.size.width - 10, TOP_PADDING + 3, self.timeLabel.frame.size.width, self.timeLabel.frame.size.height);
    }
    
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

- (void)setUpvotes:(NSInteger)upvotes{
    _upvotes = upvotes;
    self.upvoteCount.text = [@(upvotes) stringValue];
    [self.upvoteCount sizeToFit];
    [self updateControlFrames];
}

- (void)setDownvotes:(NSInteger)downvotes{
    _downvotes = downvotes;
    self.downvoteCount.text = [@(downvotes) stringValue];
    [self.downvoteCount sizeToFit];
    [self updateControlFrames];
}

- (void)setActivity:(NSInteger)activity{
    _activity = activity;
    self.commentCount.text = [@(activity) stringValue];
    [self.commentCount sizeToFit];
    [self updateControlFrames];
}

- (void)setVoteStatus:(NSInteger)voteStatus{
    _voteStatus = voteStatus;
    [self updateControlFrames];
}

- (void)setImage:(UIImage *)image{
    _image = image;
    if(image != nil){
        self.imageView.image = image;
        self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, 100);
        [self updateControlFrames];
    }else{
        self.imageView.image = nil;
        self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, 0);
        [self updateControlFrames];
    }
}

- (NSInteger)desiredHeight{
    if([self.echoContent isEqualToString:@""]){
        int padding = 0;
        if(self.imageView.frame.size.height > 0){
            padding = 30;
        }
        return 88 + self.imageView.frame.size.height + padding;
    }
    if(self.discussion){
        return self.detailLabel.frame.size.height + TOP_PADDING + END_PADDING + self.imageView.frame.size.height + 10;
    }else if(self.isComment){
        return self.detailLabel.frame.size.height + TOP_PADDING + END_PADDING + self.imageView.frame.size.height + 20;
    }else{

        return self.titleLabel.frame.size.height + self.detailLabel.frame.size.height + TOP_PADDING + DETAIL_PADDING + END_PADDING + self.imageView.frame.size.height;
    }
}

- (BOOL)checkOpenEchosTap:(CGPoint)point{
        return CGRectContainsPoint(CGRectMake(self.openCommentsLabel.frame.origin.x - 15, self.openCommentsLabel.frame.origin.y - 15, self.openCommentsLabel.frame.size.width + self.commentCount.frame.size.width + 30, self.comment.frame.size.height + self.commentCount.frame.size.height + 30), point);
}

- (BOOL)checkUpvoteTap:(CGPoint)point{
    return CGRectContainsPoint(CGRectMake(self.upvote.frame.origin.x - 15, self.upvote.frame.origin.y - 15, self.upvote.frame.size.width + self.upvoteCount.frame.size.width + 30, self.upvote.frame.size.height + self.upvoteCount.frame.size.height + 30), point);
}

- (BOOL)checkDownvoteTap:(CGPoint)point{
    return CGRectContainsPoint(CGRectMake(self.downvote.frame.origin.x - 15, self.downvote.frame.origin.y - 15, self.downvote.frame.size.width + self.downvoteCount.frame.size.width + 30, self.downvote.frame.size.height + self.downvoteCount.frame.size.height + 30), point);
}

- (void)displayDiscussion{
    self.upvoteCount.hidden = YES;
    self.downvoteCount.hidden = YES;
    self.commentCount.hidden = YES;
    self.upvote.hidden = YES;
    self.downvote.hidden = YES;
    self.comment.hidden = YES;
    self.discussion = YES;
}

- (void)displayComment{
    self.isComment = YES;
}

@end
