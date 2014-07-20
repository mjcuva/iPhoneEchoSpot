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

@interface ESCommentVC () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) ESEchoView *parentEchoView;
@property (strong, nonatomic) UITextView *commentReply;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIView *topReplyView;
@property (strong, nonatomic) UIButton *postButton;
@property (strong, nonatomic) UIButton *cancelButton;

@property (strong, nonatomic) UITableView *commentsTableView;

@property (strong, nonatomic) NSArray *comments;
@end

@implementation ESCommentVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.tintColor = [[ThemeManager sharedManager] themeColor];
    
    self.commentsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
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
    
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, self.commentReply.frame.size.height + self.commentReply.frame.origin.y + 15, self.view.frame.size.height, 1)];
    separator.backgroundColor = [[ThemeManager sharedManager] themeColor];
    separator.alpha = .7;
    

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.parentEchoView.frame.size.height + self.commentReply.frame.size.height +25)];
    
    [headerView addSubview:self.parentEchoView];
    [headerView addSubview:self.commentReply];
    [headerView addSubview:separator];
    
    [self.view addSubview:self.commentsTableView];
    
    self.commentsTableView.tableHeaderView = headerView;
    
    self.comments = [ESEchoFetcher loadCommentsForEcho:self.echo.echoID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.comments count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[UITableViewCell alloc] init];
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
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // work
    self.commentReply.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kbSize.height - 44);
    self.topReplyView.frame = CGRectMake(self.topReplyView.frame.origin.x, self.view.frame.size.height - kbSize.height - 44, self.topReplyView.frame.size.width, 44);

    
    [UIView commitAnimations];
}

- (void)keyboardWillHide: (NSNotification *)notification{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // work
    self.commentReply.frame = CGRectMake(25, self.parentEchoView.frame.origin.x + self.parentEchoView.frame.size.height + 10, self.view.frame.size.width - 25, 50);
    self.topReplyView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44);
    
    
    [UIView commitAnimations];
    
    self.commentReply.contentOffset = CGPointZero;
    
}

- (void)closeReply{
    [self.commentReply endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
