//
//  ESCommentTableViewCell.m
//  The Echo Spot
//
//  Created by Marc Cuva on 8/10/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESCommentTableViewCell.h"
#import "ESEchoView.h"

@interface ESCommentTableViewCell()
@property (strong, nonatomic) ESEchoView *commentView;
@end

@implementation ESCommentTableViewCell

- (id)initWithComment:(ESComment *)comment{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Comment"];
    if (self) {
        self.commentView = [[ESEchoView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.comment = comment;
        [self configureView];
        [self.contentView addSubview:self.commentView];
        
    }
    return self;
}

- (void)configureView{
    self.commentView.echoContent = self.comment.comment_text;
    self.commentView.created = self.comment.created;
    self.commentView.username = self.comment.author.username;
    self.commentView.upvotes = self.comment.votesUp;
    self.commentView.downvotes = self.comment.votesDown;
    self.commentView.activity = self.comment.activity;
    self.commentView.voteStatus = self.comment.voteStatus;
    [self.commentView displayComment];
}

- (void)setComment:(ESComment *)comment{
    _comment = comment;
    [self configureView];
}

- (CGFloat)desiredHeight{
    return [self.commentView desiredHeight];
}

- (BOOL)checkUpvoteTap: (CGPoint) tap{
    return [self.commentView checkUpvoteTap:tap];
}

- (BOOL)checkDownvoteTap: (CGPoint)tap{
    return [self.commentView checkDownvoteTap:tap];
}


@end
