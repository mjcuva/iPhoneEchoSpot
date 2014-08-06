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
#import "ESAuthenticator.h"
#import "ESAuthVC.h"

@interface ESCommentVC () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
@property (strong, nonatomic) ESEchoView *parentEchoView;
@property (strong, nonatomic) UITextView *commentReply;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIView *topReplyView;
@property (strong, nonatomic) UIButton *postButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UISwitch *anonSwitch;

@property (strong, nonatomic) UITableView *commentsTableView;

@property (strong, nonatomic) NSArray *comments;

@property (strong, nonatomic) NSIndexPath *openRow;
@property (strong, nonatomic) ESComment *openComment;

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
    self.parentEchoView.image = self.echo.image;
    
    self.parentEchoView.frame = CGRectMake(0, 0, self.view.frame.size.width, [self.parentEchoView desiredHeight]);
    
    UITapGestureRecognizer *voteGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(vote:)];
    [self.parentEchoView addGestureRecognizer:voteGesture];
    
    
    self.commentReply = [[UITextView alloc] initWithFrame:CGRectMake(25, self.parentEchoView.frame.origin.x + self.parentEchoView.frame.size.height + 10, self.view.frame.size.width - 25, 50)];
    self.commentReply.backgroundColor = INPUT_BACKGROUND;
    self.commentReply.textContainerInset = UIEdgeInsetsMake(10, 10, 5, 10);
    self.commentReply.font = [UIFont systemFontOfSize:16];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setTextView:)];
    self.commentReply.userInteractionEnabled = YES;
    self.commentReply.tag = 0;
    [self.commentReply addGestureRecognizer:tap];
    
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, self.commentReply.frame.size.height + self.commentReply.frame.origin.y + 15, self.view.frame.size.width, 1)];
    separator.backgroundColor = [[ThemeManager sharedManager] themeColor];
    separator.alpha = .7;
    
    UIView *headerView;
    if([[ESAuthenticator sharedAuthenticator] isLoggedIn]){
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.parentEchoView.frame.size.height + self.commentReply.frame.size.height + 25)];
        separator.frame = CGRectMake(0, self.commentReply.frame.size.height + self.commentReply.frame.origin.y + 15, self.view.frame.size.width, 1);

    }else{
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.parentEchoView.frame.size.height + 15)];
        separator.frame = CGRectMake(0, self.parentEchoView.frame.origin.y + self.parentEchoView.frame.size.height + 15, self.view.frame.size.width, 1);
    }
    
    [headerView addSubview:separator];
    [headerView addSubview:self.parentEchoView];
    
    if([[ESAuthenticator sharedAuthenticator] isLoggedIn]){
        [headerView addSubview:self.commentReply];   
    }

    
    [self.view addSubview:self.commentsTableView];
    
    self.commentsTableView.tableHeaderView = headerView;
    self.commentsTableView.separatorColor = [[ThemeManager sharedManager] themeColor];
    
    [self loadData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)loadData{
    dispatch_queue_t loadCommentsQueue = dispatch_queue_create("load comments", NULL);
    dispatch_async(loadCommentsQueue, ^{
        self.comments = [ESEchoFetcher loadCommentsForEcho:self.echo.echoID];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.commentsTableView reloadData];
        });
    });
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.comments count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ESTableViewCell *cell = [[ESTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    cell.echoContent = ((ESComment *)self.comments[indexPath.item]).comment_text;
    cell.isComment = YES;
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
        self.addDiscussion.tag = 1;
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
        if([[ESAuthenticator sharedAuthenticator] isLoggedIn]){
            [self.discussionViews addSubview:self.addDiscussion];   
        }
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, tableView.rowHeight);
        
        UITapGestureRecognizer *toggleEcho = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openComment:)];
        
        [cell addGestureRecognizer:toggleEcho];
    }
    
    if(indexPath.row % 2 == 1){
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
    cell.voteStatus = comment.voteStatus;
    
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
    
    ESComment *tappedComment = self.comments[row.item];
    
    
    if([cell checkUpvoteTap:[self.commentsTableView convertPoint:point toView:cell]]){
        if([[ESAuthenticator sharedAuthenticator] isLoggedIn]){
            [self voteOnCell:cell comment:tappedComment withValue:1];
        }else{
            [self performSegueWithIdentifier:@"showAuth" sender:^{
                [self voteOnCell:cell comment:tappedComment withValue:1];                
            }];
        }
    }else if([cell checkDownvoteTap:[self.commentsTableView convertPoint:point toView:cell]]){
        if([[ESAuthenticator sharedAuthenticator] isLoggedIn]){
            [self voteOnCell:cell comment:tappedComment withValue:-1];
        }else{
            [self performSegueWithIdentifier:@"showAuth" sender:^{
                [self voteOnCell:cell comment:tappedComment withValue:-1];                
            }];
        }
    }else{
    
        if(self.comments[row.item] == self.openComment){
            [self closeComment];
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
//            [self scrollToIndexPath:row withCell: cell];
        }
    }
}

- (void)voteOnCell: (ESTableViewCell *)cell comment: (ESComment *)comment withValue: (int)vote{
    if(vote == 1){
        int voteResult = 1;
        if(cell.voteStatus == 1){
            voteResult = 0;
            cell.upvotes -= 1;
        }else if(cell.voteStatus == -1){
            cell.downvotes -= 1;
            cell.upvotes += 1;
        }else{
            cell.upvotes += 1;
        }
        
        cell.voteStatus = voteResult;
        comment.voteStatus = voteResult;
        
        [ESEchoFetcher voteOnPostType:@"Comment" withID:(int)comment.commentID withValue:1];
    }else{
        
        int voteResult = -1;
        if(cell.voteStatus == -1){
            voteResult = 0;
            cell.downvotes -= 1;
        }else if(cell.voteStatus == 1){
            cell.upvotes -= 1;
            cell.downvotes += 1;
        }else{
            cell.downvotes += 1;
        }
        
        cell.voteStatus = voteResult;
        comment.voteStatus = voteResult;
        [ESEchoFetcher voteOnPostType:@"Comment" withID:(int)comment.commentID withValue:-1];
    }
}



- (void)closeComment{
    self.openComment = nil;
    self.openRow = nil;
    [self.discussionViews removeFromSuperview];
    self.discussionViews = nil;
    [self.addDiscussion removeFromSuperview];
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
    
    
    UILabel *anonLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 44)];
    anonLabel.text = @"Anonymous";
    anonLabel.textColor = [UIColor whiteColor];
    
    self.anonSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(anonLabel.frame.size.width + 5, 0, 75, 44)];
    self.anonSwitch.center = CGPointMake(self.anonSwitch.center.x, self.topReplyView.frame.size.height / 2);
    
    [self.topReplyView addSubview:anonLabel];
    [self.topReplyView addSubview:self.anonSwitch];
    
    self.postButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 75, 0, 75, 44)];
    [self.postButton setTitle:@"Post" forState:UIControlStateNormal];
    [self.postButton addTarget:self action:@selector(postReply) forControlEvents:UIControlEventTouchUpInside];
    [self.topReplyView addSubview:self.postButton];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - self.postButton.frame.size.width - 75, 0, 75, 44)];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.topReplyView addSubview:cancelButton];
    
    [cancelButton addTarget:self action:@selector(closeReply) forControlEvents:UIControlEventTouchUpInside];
    
    self.commentsTableView.scrollEnabled = NO;
    
    self.originalReplyFrame = self.activeTextView.frame;
    
    if(self.activeTextView.tag == 1){
        [[[UIApplication sharedApplication] keyWindow] insertSubview:self.activeTextView aboveSubview:self.commentsTableView];
        self.activeTextView.center = [self.activeTextView.superview convertPoint:self.activeTextView.center fromView:self.discussionViews];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:NO];
    
    // work
    if(self.activeTextView.tag == 0){
        self.commentsTableView.contentOffset = CGPointZero;
        self.activeTextView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kbSize.height - 44);
    }else{
        self.activeTextView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - kbSize.height - 44);
    }
    self.topReplyView.frame = CGRectMake(self.topReplyView.frame.origin.x, self.view.frame.size.height - kbSize.height - 44, self.topReplyView.frame.size.width, 44);

    
    [UIView commitAnimations];
    

}

- (void)keyboardWillHide: (NSNotification *)notification{
    
    if(self.activeTextView.tag == 1){
        [self.activeTextView removeFromSuperview];
        [self.discussionViews addSubview:self.activeTextView];
        self.activeTextView.center = [self.activeTextView.superview convertPoint:self.activeTextView.center fromView:self.commentsTableView.superview];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:NO];
    
    // work
    self.activeTextView.frame = self.originalReplyFrame;
    self.topReplyView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44);
    
    
    [UIView commitAnimations];
    
    self.commentsTableView.scrollEnabled = YES;
    
    self.commentReply.contentOffset = CGPointZero;
    
}

- (void)postReply{
    if(self.activeTextView.tag == 0){
        BOOL success = [ESEchoFetcher postComment:self.activeTextView.text onEchoID:(int)self.echo.echoID anonymously:self.anonSwitch.selected];
        if(!success){
            NSLog(@"OOPS");
        }
        self.activeTextView.text = @"";
        [self closeReply];
        [self loadData];
    }else if(self.activeTextView.tag == 1){
        [self closeReply];
        BOOL success = [ESEchoFetcher postDiscussion:self.activeTextView.text onCommentID:(int)self.openComment.commentID anonymously:self.anonSwitch.selected];
        if(!success){
            NSLog(@"OOPS");
        }
        [self closeComment];
        self.activeTextView.text = @"";
        [self loadData];
    }
}

- (void)setTextView: (UITapGestureRecognizer *)sender{
    self.activeTextView = (UITextView *)sender.view;
    [self.activeTextView becomeFirstResponder];
}

- (void)closeReply{
    [self.activeTextView endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self.view.window endEditing:YES];
    }
    
    [super viewWillDisappear:animated];
}

- (void)vote: (UITapGestureRecognizer *)sender{
    
    CGPoint point = [sender locationInView:self.parentEchoView];
    
    if([self.parentEchoView checkUpvoteTap:point]){
        if([[ESAuthenticator sharedAuthenticator] isLoggedIn]){
            [self voteWithValue:1];
        }else{
            [self performSegueWithIdentifier:@"showAuth" sender:^{
                [self voteWithValue:1];
            }];
        }
    }else if([self.parentEchoView checkDownvoteTap:point]){
        if([[ESAuthenticator sharedAuthenticator] isLoggedIn]){
            [self voteWithValue:-1];
        }else{
            [self performSegueWithIdentifier:@"showAuth" sender:^{
                [self voteWithValue:-1];
            }];
        }
    
    }
}

- (void)voteWithValue: (int)vote{
    if(vote == 1){
        int voteResult = 1;
        if(self.parentEchoView.voteStatus == 1){
            voteResult = 0;
            self.parentEchoView.upvotes -= 1;
        }else if(self.parentEchoView.voteStatus == -1){
            self.parentEchoView.downvotes -= 1;
            self.parentEchoView.upvotes += 1;
        }else{
            self.parentEchoView.upvotes += 1;
        }
        
        self.parentEchoView.voteStatus = voteResult;
        self.echo.voteStatus = voteResult;
        
        [ESEchoFetcher voteOnPostType:@"Echo" withID:(int)self.echo.echoID withValue:1];
    }else{
        
        int voteResult = -1;
        if(self.parentEchoView.voteStatus == -1){
            voteResult = 0;
            self.parentEchoView.downvotes -= 1;
        }else if(self.parentEchoView.voteStatus == 1){
            self.parentEchoView.upvotes -= 1;
            self.parentEchoView.downvotes += 1;
        }else{
            self.parentEchoView.downvotes += 1;
        }
        
        self.parentEchoView.voteStatus = voteResult;
        self.echo.voteStatus = voteResult;
        [ESEchoFetcher voteOnPostType:@"Echo" withID:(int)self.echo.echoID withValue:-1];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showAuth"]){
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        ESAuthVC *root = (ESAuthVC *)nav.viewControllers[0];
        [root setCallback:sender];
    }

}

@end
