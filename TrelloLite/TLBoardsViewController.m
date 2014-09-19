//
//  ViewController.m
//  TrelloLite
//
//  Created by Shiv Baijal on 2014-09-15.
//  Copyright (c) 2014 Shiv Baijal. All rights reserved.
//

#import "TLBoardsViewController.h"
#import "TLAPIClient.h"
#import "TLBoard.h"
#import "TLBoardTableViewCell.h"
#import "TLCardsViewController.h"
#import "SVProgressHUD.h"

@interface TLBoardsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (assign) BOOL loading;
@property (strong) NSArray *boards;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TLBoardsViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Boards";
        
        self.boards = @[];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorInset = UIEdgeInsetsZero;
        self.tableView.layoutMargins = UIEdgeInsetsZero;
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [SVProgressHUD show];
    [self fetchBoards];
}

#pragma mark - Get Data

- (void)fetchBoards {
    if (self.loading) {
        return;
    }
    self.loading = YES;

    __weak typeof(self) weakSelf = self;
    [[TLAPIClient sharedInstance] fetchOpenBoards:^(id responseObject, NSError *error) {
        if (responseObject) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                NSArray *boardsArray = responseObject;
                NSMutableArray *updatedBoards = [@[] mutableCopy];
                for (NSDictionary *boardDictionary in boardsArray) {
                    NSError *error = nil;
                    TLBoard *board = [MTLJSONAdapter modelOfClass:[TLBoard class] fromJSONDictionary:boardDictionary error:&error];
                    [updatedBoards addObject:board];
                }
                weakSelf.boards = [updatedBoards copy];
                weakSelf.loading = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    [SVProgressHUD dismiss];
                });
            });
        } else {
            weakSelf.loading = NO;
        }
    }];
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.boards count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *boardCellID = @"boardCell";

    TLBoardTableViewCell *cell = (TLBoardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:boardCellID];
    
    if (!cell) {
        cell = [[TLBoardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:boardCellID];
    }
    cell.board = [self.boards objectAtIndex:indexPath.row];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TLCardsViewController *cardsVC = [[TLCardsViewController alloc] init];
    cardsVC.board = ((TLBoard *)[self.boards objectAtIndex:indexPath.row]);
    [self.navigationController pushViewController:cardsVC animated:YES];
}


@end
