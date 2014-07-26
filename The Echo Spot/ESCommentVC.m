//
//  ESCommentVC.m
//  The Echo Spot
//
//  Created by Marc Cuva on 7/19/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESCommentVC.h"
#import "ESEchoView.h"
#import "ThemeManager.h"
#import "constants.h"
#import "ESEchoFetcher.h"
#import "ESComment.h"
#import "ESTableViewCell.h"
#import "ESDiscussion.h"

@interface ESCommentVC () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
@property (strong, nonatomic) ESEchoView *parentEchoView;
@property (strong, nonatomic) UITextView *commentReply;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIView *topReplyView;
@property (strong, nonatomic) UIButton *postButton;
@property (strong, nonatomic) UIButton *cancelButton;

@property (strong, nonatomic) UITableView *commentsTableView;

@property (strong, nonatomic) NSArray *comments;

@property (strong, nonatomic) NSIndexPath *openRow;
@property (strong, nonatomic) ESEcho *openComment;

@property (strong, nonatomic) UIView *discussionViews;

@property (strong, nonatomic) UITextView *activeTextView;

@property (strong, nonatomic) UITextView *addDiscussion;

@property (nonatomic) CGRect originalReplyFrame;
@end

@implementation ESCommentVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.tintColor = [[ThemeManager sharedManager] themeColor];
    
    self.commentsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    self.commentsTableView.dataSource = self;
    self.commentsTableView.delegate = self;
    

    
    self.parentEchoView = [[ESEchoView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [self.parentEchoView desiredHeight])];
    self.parentEchoView.echoTitle = self.echo.title;
    self.parentEchoView.echoContent = self.echo.content;
    self.parentEchoView.created = self.echo.created;
    self.parentEchoView.username = self.echo.author.username;
    self.parentEchoView.upvotes = self.echo.votesUp;
    self.parentEchoView.downvotes = self.echo.votesDown;
    self.parentEchoView.activity = self.echo.activity;
    
    self.parentEchoView.frame = CGRectMake(0, 0, self.view.frame.size.width, [self.parentEchoView desiredHeight]);
    
    
    self.commentReply = [[UITextView alloc] initWithFrame:CGRectMake(25, self.parentEchoView.frame.origin.x + self.parentEchoView.frame.size.height + 10, self.view.frame.size.width - 25, 50)];
    self.commentReply.backgroundColor = INPUT_BACKGROUND;
    self.commentReply.textContainerInset = UIEdgeInsetsMake(10, 10, 5, 10);
    self.commentReply.font = [UIFont systemFontOfSize:16];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setTextView:)];
    self.commentReply.userInteractionEnabled = YES;
    self.commentReply.tag = 1;
    [self.commentReply addGestureRecognizer:tap];
    
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, self.commentReply.frame.size.height + self.commentReply.frame.origin.y + 15, self.view.frame.size.width, 1)];
    separator.backgroundColor = [[ThemeManager sharedManager] themeColor];
    separator.alpha = .7;
    

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.parentEchoView.frame.size.height + self.commentReply.frame.size.height +25)];
    
    [headerView addSubview:self.parentEchoView];
    [headerView addSubview:self.commentReply];
    [headerView addSubview:separator];
    
    [self.view addSubview:self.commentsTableView];
    
    self.commentsTableView.tableHeaderView = headerView;
    self.commentsTableView.separatorColor = [[ThemeManager sharedManager] themeColor];
    
    dispatch_queue_t loadCommentsQueue = dispatch_queue_create("load comments", NULL);
    dispatch_async(loadCommentsQueue, ^{
        self.comments = [ESEchoFetcher loadCommentsForEcho:self.echo.echoID];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.commentsTableView reloadData];
        });
    });
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.comments count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ESTableViewCell *cell = [[ESTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    cell.echoContent = ((ESComment *)self.comments[indexPath.item]).comment_text;
    if(self.openComment == self.comments[indexPath.row]){
        ESComment *comment = self.comments[indexPath.row];
        self.discussionViews = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
        double height = 60;
        self.addDiscussion = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 1/8, 0, self.view.frame.size.width *7/8, 50)];
        self.addDiscussion.backgroundColor = INPUT_BACKGROUND;
        self.addDiscussion.alpha = 1;
        self.addDiscussion.opaque = YES;
        self.addDiscussion.textContainerInset = UIEdgeInsetsMake(10, 10, 5, 10);
        self.addDiscussion.font = [UIFont systemFontOfSize:16];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setTextView:)];
        self.addDiscussion.userInteractionEnabled = YES;
        [self.addDiscussion addGestureRecognizer:tap];
        for(ESDiscussion *discussion in comment.discussions){
            UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 1/8, height, self.view.frame.size.width * 7/8, 1)];
            separator.backgroundColor = [[ThemeManager sharedManager] themeColor];
            separator.alpha = .7;
            ESEchoView *discoView = [[ESEchoView alloc] initWithFrame:CGRectMake(0, height, self.view.frame.size.width * 7/8, 0)];
            [discoView displayDiscussion];
            discoView.echoContent = discussion.discussion_text;
            discoView.created = discussion.created;
            discoView.username = discussion.author.username;
            discoView.frame = CGRectMake(self.view.frame.size.width * 1/8, height, discoView.frame.size.width, [discoView desiredHeight]);
            height += discoView.frame.size.height;
            [self.discussionViews addSubview:discoView];
            [self.discussionViews addSubview:separator];
        }
        [self.discussionViews addSubview:self.addDiscussion];
        self.discussionViews.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
        return height + [cell desiredHeight];
    }else{
        return [cell desiredHeight];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CommentCell";
    ESComment *comment = self.comments[indexPath.item];
    
    ESTableViewCell *cell = [self.commentsTableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        cell = [[ESTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.isComment = YES;
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, tableView.rowHeight);
        
        UITapGestureRecognizer *toggleEcho = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openComment:)];
        
        [cell addGestureRecognizer:toggleEcho];
    }
    
    if(indexPath.row % 2 == 0){
        cell.backgroundColor = [[ThemeManager sharedManager] lightBackgroundColor];
    }else{
        cell.backgroundColor = [[ThemeManager sharedManager] darkBackgroundColor];
    }
    
    cell.echoContent = comment.comment_text;
    
    cell.created = comment.created;
    cell.username = comment.author.username;
    cell.upvotes = comment.votesUp;
    cell.downvotes = comment.votesDown;
    cell.activity = [comment.discussions count];
    
    if(self.openComment == self.comments[indexPath.item]){
        self.discussionViews.frame = CGRectMake(self.discussionViews.frame.origin.x, [cell desiredHeight], self.discussionViews.frame.size.width, self.discussionViews.frame.size.height);
        [cell addSubview:self.discussionViews];
    }
    
    cell.userInteractionEnabled = YES;
    
    return cell;
}

- (void)openComment: (UITapGestureRecognizer *)sender{
    
    CGPoint point = [sender locationInView:self.commentsTableView];
    NSIndexPath *row = [self.commentsTableView indexPathForRowAtPoint:point];
    NSIndexPath *startRow = self.openRow;
    
    ESTableViewCell *cell = (ESTableViewCell *)[self.commentsTableView cellForRowAtIndexPath:row];
    
    if(self.comments[row.item] == self.openComment){
        self.openComment = nil;
        self.openRow = nil;
        [self.discussionViews removeFromSuperview];
        self.discussionViews = nil;
    }else{
        if(self.discussionViews){
            [self.discussionViews removeFromSuperview];
            self.discussionViews = nil;
        }
        self.openComment = self.comments[row.item];
        self.openRow = row;
    }
    
    if(startRow != nil && row.row != startRow.row){
        [self.commentsTableView reloadRowsAtIndexPaths:@[row, startRow] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        [self.commentsTableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    if(self.openComment != nil){
        [self scrollToIndexPath:row withCell: cell];
    }
}

- (void)scrollToIndexPath: (NSIndexPath *)indexPath withCell: (ESTableViewCell *)cell{
    if(self.commentsTableView.contentSize.height - cell.frame.origin.y + self.commentsTableView.tableHeaderView.frame.size.height > self.commentsTableView.frame.size.height + self.commentsTableView.tableHeaderView.frame.size.height){
        [self.commentsTableView setContentOffset:CGPointMake(0, indexPath.row * cell.frame.size.height + self.commentsTableView.tableHeaderView.frame.size.height) animated:YES];
    }
}

- (void)keyboardWillShow: (NSNotification *)notification{
    
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    self.topReplyView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    self.topReplyView.backgroundColor = [[ThemeManager sharedManager] themeColor];
    [self.view addSubview:self.topReplyView];
    
    self.postButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 75, 0, 75, 44)];
    [self.postButton setTitle:@"Post" forState:UIControlStateNormal];
    [self.topReplyView addSubview:self.postButton];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - self.postButton.frame.size.width - 75, 0, 75, 44)];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.topReplyView addSubview:cancelButton];
    
    [cancelButton addTarget:self action:@selector(closeReply) forControlEvents:UIControlEventTouchUpInside];
    
    if(self.activeTextView.tag == 1){
        self.commentsTableView.contentOffset = CGPointZero;   
    }else{
        self.commentsTableView.contentOffset = CGPointMake(0, [self.activeTextView convertPoint:self.activeTextView.bounds.origin toView:self.commentsTableView].y);
    }
    self.commentsTableView.scrollEnabled = NO;
    
    self.originalReplyFrame = self.activeTextView.frame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // work
    self.activeTextView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kbSize.height - 44);
    self.topReplyView.frame = CGRectMake(self.topReplyView.frame.origin.x, self.view.frame.size.height - kbSize.height - 44, self.topReplyView.frame.size.width, 44);

    
    [UIView commitAnimations];
    

}

- (void)keyboardWillHide: (NSNotification *)notification{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // work
    self.activeTextView.frame = self.originalReplyFrame;
    self.topReplyView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44);
    
    
    [UIView commitAnimations];
    
    self.commentsTableView.scrollEnabled = YES;
    
    self.commentReply.contentOffset = CGPointZero;
    
}

- (void)setTextView: (UITapGestureRecognizer *)sender{
    self.activeTextView = (UITextView *)sender.view;
    [self.activeTextView becomeFirstResponder];
}

- (void)closeReply{
    [self.activeTextView endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
