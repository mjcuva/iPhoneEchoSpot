
//  ESTableViewCell.m
//  The Echo Spot
//
//  Created by Marc Cuva on 6/7/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESEchoTableViewCell.h"
#import "ESEchoView.h"


@interface ESEchoTableViewCell()
@property (strong, nonatomic) ESEchoView *echoView;
@end

@implementation ESEchoTableViewCell

- (instancetype)initWithEcho: (ESEcho *)echo{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Echo"];
    if(self){
        self.echoView = [[ESEchoView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self.contentView addSubview:self.echoView];
        self.echo = echo;
        [self configureView];
    }
    return self;
}

- (void)configureView{
    self.echoView.echoTitle = self.echo.title;
    if(self.isOpen){
        self.echoView.echoContent = self.echo.content;
    }else{
        self.echoView.echoContent = @"";
    }
    self.echoView.created = self.echo.created;
    self.echoView.username = self.echo.author.username;
    self.echoView.upvotes = self.echo.votesUp;
    self.echoView.downvotes = self.echo.votesDown;
    self.echoView.voteStatus = self.echo.voteStatus;
    self.echoView.activity = self.echo.activity;
    self.echoView.image = self.echo.image;
}

- (void)setEcho:(ESEcho *)echo{
    _echo = echo;
    [self configureView];
}

- (void)setIsOpen:(BOOL)isOpen{
    _isOpen = isOpen;
    [self configureView];
}

- (NSInteger)desiredHeight{
    return [self.echoView desiredHeight];
}

- (BOOL)checkOpenEchosTap:(CGPoint)point{
    return [self.echoView checkOpenEchosTap:point];
}

- (BOOL)checkUpvoteTap:(CGPoint)point{
    return [self.echoView checkUpvoteTap:point];
}

- (BOOL)checkDownvoteTap:(CGPoint)point{
    return [self.echoView checkDownvoteTap:point];
}

- (void)setIsComment:(BOOL)isComment{
    _isComment = YES;
    [self.echoView displayComment];
}

@end
