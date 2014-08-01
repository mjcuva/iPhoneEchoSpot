//
//  ESHomeTVC.m
//  The Echo Spot
//
//  Created by Marc Cuva on 5/31/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESHomeTVC.h"
#import "ESEcho.h"
#import "ESEchoFetcher.h"
#import "ESTableViewCell.h"
#import "constants.h"
#import "ThemeManager.h"
#import "ESCommentVC.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "ESAuthenticator.h"
#import "ESAuthVC.h"

@interface ESHomeTVC()
@property (strong, nonatomic) NSArray *echos;
@property (strong, nonatomic) ESEcho *openEcho;

@property (nonatomic) CGFloat lastScrollViewOffset;

@property (strong, nonatomic) UISegmentedControl *segmentedControl;

// Dirty Hack
@property (strong, nonatomic) NSIndexPath *openRow;
@property NSInteger openCellHeight;
@property int currentPage;
@end

@implementation ESHomeTVC

#define CONTROL_HEIGHT 30

// Percent width
#define CONTROL_WIDTH .85 * self.view.frame.size.width

// padding from top of control to top of view
#define CONTROL_PADDING 10

#define VIEW_ZERO CONTROL_HEIGHT + CONTROL_PADDING * 2

#pragma mark - Set Up Views


- (void)viewDidLoad{
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];
    
    UIImage *image = [[UIImage imageNamed:@"Logo.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(self.view.frame.size.width / 2, 80);
    [self.tableView addSubview:indicator];
    [indicator startAnimating];
    
    [self loadDataWithCompletion:^{
        
        [indicator stopAnimating];
        [indicator removeFromSuperview];
        __weak ESHomeTVC *weakself = self;
        
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            // append data to data source, insert new cells at the end of table view
            [weakself loadNextPage];
            // call [tableView.infiniteScrollingView stopAnimating] when done
        }];
    }];
    
    self.navigationController.navigationBar.translucent = NO;
    
    // Kind of a gross hack
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Trending", @"Recent", @"Votes"]];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.layer.cornerRadius = 5;
    self.segmentedControl.frame = CGRectMake((self.view.frame.size.width - CONTROL_WIDTH) / 2, CONTROL_PADDING, CONTROL_WIDTH, CONTROL_HEIGHT);


    UIView *wrapperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, CONTROL_HEIGHT + CONTROL_PADDING * 2)];
    [wrapperView addSubview:self.segmentedControl];
    self.tableView.tableHeaderView = wrapperView;
    
    self.openEcho = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLayout) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.currentPage = 0;
}

- (void)loadNextPage{
    __weak ESHomeTVC *weakSelf = self;
    
    int64_t delayInSeconds = 2.0f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
     dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
         [weakSelf.tableView beginUpdates];
         weakSelf.currentPage = self.currentPage + 1;
         weakSelf.echos = [weakSelf.echos arrayByAddingObjectsFromArray:[ESEchoFetcher loadEchosOnPage:self.currentPage]];
         NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:10];
         for(int i = (int)weakSelf.echos.count - 20; i < weakSelf.echos.count; i++){
             [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
         }
         [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
         [weakSelf.tableView endUpdates];
         [weakSelf.tableView.infiniteScrollingView stopAnimating];
     });
}

- (void)updateLayout{
    [[ThemeManager sharedManager] configureTheme];
    self.navigationController.navigationBar.barTintColor = [[ThemeManager sharedManager] navBarColor];
    self.tableView.backgroundColor = [[ThemeManager sharedManager] darkBackgroundColor];
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    if([[ThemeManager sharedManager] navBarColor] == [UIColor whiteColor]){
        self.tableView.separatorColor = [UIColor clearColor];
        self.navigationController.navigationBar.tintColor = [[ThemeManager sharedManager] themeColor];
        UIImage *image = [[UIImage imageNamed:@"Logo.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        self.tableView.tintColor = [UIColor whiteColor];
        self.segmentedControl.tintColor = [[ThemeManager sharedManager] themeColor];
        [self.segmentedControl setTitleTextAttributes:@{ NSFontAttributeName:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]], NSForegroundColorAttributeName:[UIColor blackColor] } forState:UIControlStateNormal];
    }else{
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        UIImage *image = [[UIImage imageNamed:@"Logo.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.tableView.separatorColor = [UIColor colorWithWhite:.93 alpha:1];
        self.tableView.tintColor = [[ThemeManager sharedManager] themeColor];
        self.segmentedControl.tintColor = [[ThemeManager sharedManager] themeColor];
        [self.segmentedControl setTitleTextAttributes:@{ NSFontAttributeName:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]], NSForegroundColorAttributeName:[[ThemeManager sharedManager] themeColor] } forState:UIControlStateNormal];
    }
    
    [self.tableView reloadData];
    
    [self performSelector:@selector(hideControl) withObject:nil afterDelay:0];
}

- (void)hideControl{

    self.tableView.contentOffset = CGPointMake(0, CONTROL_PADDING * 2 + CONTROL_HEIGHT);

}

#pragma mark - UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.echos.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.echos[indexPath.row] == self.openEcho){
        return self.openCellHeight;
    }else{
        return 88;
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"EchoCell";
    ESEcho *echo = self.echos[indexPath.item];
    
    ESTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        cell = [[ESTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, tableView.rowHeight);
        
        UITapGestureRecognizer *toggleEcho = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openEcho:)];
        
        [cell addGestureRecognizer:toggleEcho];
    }
    
    if(indexPath.row % 2 == 0)
    {
        cell.backgroundColor = [[ThemeManager sharedManager] lightBackgroundColor];
    }else{
        cell.backgroundColor = [[ThemeManager sharedManager] darkBackgroundColor];
    }
    
    
    cell.echoTitle = echo.title;
    
    if(self.echos[indexPath.row] == self.openEcho){
        cell.echoContent = echo.content;
    }else{
        cell.echoContent = @"";
    }
    
    cell.created = echo.created;
    cell.username = echo.author.username;
    cell.upvotes = echo.votesUp;
    cell.downvotes = echo.votesDown;
    cell.activity = echo.activity;
    
    cell.userInteractionEnabled = YES;
    
    return cell;
}

#pragma mark - Expand Echos

- (void)openEcho:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.tableView];
    
    NSIndexPath *row = [self.tableView indexPathForRowAtPoint:point];
    NSIndexPath *startRow = self.openRow;
    ESTableViewCell *cell = (ESTableViewCell *)[self.tableView cellForRowAtIndexPath:row];
    
    if([cell checkOpenEchosTap:[self.view convertPoint:point toView:cell]] && self.echos[row.item] == self.openEcho){
        [self performSegueWithIdentifier:@"showComments" sender:self];
    }else{
    
        if(self.echos[row.item] == self.openEcho){
            self.openEcho = nil;
            cell.echoContent = @"";
            self.openRow = nil;
        }else{
            self.openEcho = self.echos[row.item];
            cell.echoContent = self.openEcho.content;
            self.openRow = row;
            self.openCellHeight = [cell desiredHeight];
        }
        
        if(startRow != nil && row.row != startRow.row){
            [self.tableView reloadRowsAtIndexPaths:@[row, startRow] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
            [self scrollToIndexPath:row withCell: cell];
    }
}

- (void)scrollToIndexPath:(NSIndexPath *)indexPath withCell:(ESTableViewCell *)cell{
    if(self.tableView.contentSize.height - VIEW_ZERO - cell.frame.origin.y > self.tableView.frame.size.height){
        [self.tableView setContentOffset:CGPointMake(0, indexPath.row * 88 + VIEW_ZERO) animated:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(scrollView.contentOffset.y < (CONTROL_HEIGHT / 2) + CONTROL_PADDING){
        [UIView animateWithDuration:.3 animations:^{
            [scrollView setContentOffset: CGPointMake(0, 0)];
        }];
    }else if(scrollView.contentOffset.y > (CONTROL_HEIGHT / 2) + CONTROL_PADDING && scrollView.contentOffset.y < CONTROL_PADDING * 2 + CONTROL_HEIGHT){
        [UIView animateWithDuration:.3 animations:^{
            [scrollView setContentOffset:CGPointMake(0, VIEW_ZERO) animated:YES];
        }];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[ESCommentVC class]]){
        ESCommentVC *destination = (ESCommentVC *)segue.destinationViewController;
        destination.echo = self.openEcho;
    }else if([segue.identifier isEqualToString:@"showAuth"]){
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        ESAuthVC *root = (ESAuthVC *)nav.viewControllers[0];
        [root setCallback:sender];
    }
}

- (IBAction)openProfile:(UIBarButtonItem *)sender {
    if([[ESAuthenticator sharedAuthenticator] isLoggedIn]){
        [self performSegueWithIdentifier:@"showProfile" sender:self];
    }else{
        [self performSegueWithIdentifier:@"showAuth" sender:^{
            [self performSegueWithIdentifier:@"showProfile" sender:nil];
        }];
    }
}

- (IBAction)createEcho:(UIBarButtonItem *)sender {
    if([[ESAuthenticator sharedAuthenticator] isLoggedIn]){
        [self performSegueWithIdentifier:@"showNewEcho" sender:self];
    }else{
        [self performSegueWithIdentifier:@"showAuth" sender:^{
            [self performSegueWithIdentifier:@"showNewEcho" sender:nil];
        }];
    }
}

- (IBAction)refresh:(UIRefreshControl *)sender {
    [self loadDataWithCompletion:^{
        [self.refreshControl endRefreshing];
    }];
}

- (void)loadDataWithCompletion: (void (^)(void))completion{
    dispatch_queue_t loadEchosQueue = dispatch_queue_create("load echos", NULL);
    dispatch_async(loadEchosQueue, ^{
        self.echos = [ESEchoFetcher loadEchosOnPage:0];
        self.currentPage = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            if(completion)
                completion();
        });
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

@end
