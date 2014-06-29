
//  ESTableViewCell.m
//  The Echo Spot
//
//  Created by Marc Cuva on 6/7/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESTableViewCell.h"
#import "AutosizingLabel.h"

@interface ESTableViewCell()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) AutosizingLabel *detailLabel;
@property (strong, nonatomic) UIImageView *upvote;
@property (strong, nonatomic) UIImageView *downvote;
@property (strong, nonatomic) UIImageView *comment;
@end

@implementation ESTableViewCell

#define TOP_PADDING 5
#define DETAIL_PADDING 10
#define END_PADDING 40

#define BUTTON_OFFSET 15

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, TOP_PADDING, self.frame.size.width - 20, 44)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.text = self.echoTitle;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
//        [self.titleLabel sizeToFit];
        
        self.detailLabel = [[AutosizingLabel alloc] initWithFrame:CGRectMake(15, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + DETAIL_PADDING, self.frame.size.width - 25, 0)];
        self.detailLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        self.detailLabel.textColor = [UIColor whiteColor];
        
        self.upvote = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upvote.png"]];
        self.downvote = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downvote.png"]];
        self.comment = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment.png"]];
        
        [self updateControlFrames];
        
        
//        [self.upvote setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
//        [self.downvote setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
//        [self.comment setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.upvote];
        [self.contentView addSubview:self.downvote];
        [self.contentView addSubview:self.comment];
        
        
    }
    return self;
}

- (void)updateControlFrames{
    
    NSLog(@"Y: %f", [self desiredHeight] - self.upvote.frame.size.height - 30);
    NSLog(@"Desired Height %i", [self desiredHeight]);
    NSLog(@"Height %f", self.frame.size.height);
    
    self.upvote.frame = CGRectMake(5, [self desiredHeight] - self.upvote.frame.size.height - BUTTON_OFFSET, self.upvote.frame.size.width, self.upvote.frame.size.height);
    self.downvote.frame = CGRectMake(self.upvote.frame.size.width + 10, [self desiredHeight] - self.downvote.frame.size.height - BUTTON_OFFSET, self.downvote.frame.size.width, self.downvote.frame.size.height);
    self.comment.frame = CGRectMake(self.upvote.frame.size.width + self.downvote.frame.size.width + 15, [self desiredHeight] - self.comment.frame.size.height - BUTTON_OFFSET, self.comment.frame.size.width, self.comment.frame.size.height);
}

- (void)setEchoTitle:(NSString *)echoTitle{
    _echoTitle = echoTitle;
    self.titleLabel.text = echoTitle;
    [self updateControlFrames];
}

- (void)setEchoContent:(NSString *)echoContent{
    _echoContent = echoContent;
    self.detailLabel.text = echoContent;
    [self updateControlFrames];
}

- (NSInteger)desiredHeight{
    if([self.echoContent isEqualToString:@""]){
        return 88;
    }
    return self.titleLabel.frame.size.height + self.detailLabel.frame.size.height + TOP_PADDING + DETAIL_PADDING + END_PADDING;
}

@end
