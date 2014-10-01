//
//  TLCardsViewController.m
//  TrelloLite
//
//  Created by Shiv Baijal on 2014-09-16.
//  Copyright (c) 2014 Shiv Baijal. All rights reserved.
//

#import "TLCardsViewController.h"
#import "MDCSwipeToChoose.h"
#import "TLAPIClient.h"
#import "TLList.h"
#import "TLCard.h"
#import "TLCardView.h"
#import "SVProgressHUD.h"

@interface TLCardsViewController () <MDCSwipeToChooseDelegate>

@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) NSArray *lists;
@property (nonatomic, strong) TLCardView *firstCardView;
@property (nonatomic, strong) TLCardView *secondCardView;

@end

@implementation TLCardsViewController

#pragma mark - Lifecycle

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"Cards";
        
        self.cards = [NSMutableArray array];
        self.lists = [NSMutableArray array];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.firstCardView = [[TLCardView alloc] initWithFrame:[self cardViewFrame] options:[self swipeOptions]];
    [self.view addSubview:self.firstCardView];
    
    self.view.backgroundColor = [UIColor colorWithRed:35/225.0f green:113/255.0f blue:159/255.0f alpha:1.0];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [SVProgressHUD show];
    [self fetchCards];
}

#pragma mark - Custom Setter

- (void)setBoard:(TLBoard *)board{
    _board = board;
    self.title = board.name;
}

#pragma mark - Get Data

- (void)fetchCards {
    __weak typeof(self) weakSelf = self;
    [[TLAPIClient sharedInstance] fetchListsWithBoardID:self.board.boardID includingCards:YES success:^(id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            weakSelf.lists = [TLList listsFromJSON:responseObject];
            weakSelf.cards = [((TLList *)[weakSelf.lists firstObject]).cards mutableCopy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf addCardsToView];
                [SVProgressHUD dismiss];
            });
        });
    } failure:^(NSError *error) {
    }];
}

#pragma mark - MDCSwipeToChooseDelegate + Helper Methods

- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    __weak typeof(self) weakSelf = self;
    if (direction == MDCSwipeDirectionLeft) {
        [[TLAPIClient sharedInstance] moveCardWithIDToTheBottomOfItsList:self.firstCardView.card.cardID success:^(id responseObject) {
            [weakSelf.cards addObject:weakSelf.firstCardView.card];
            [weakSelf updateCardViews];
        } failure:^(NSError *error) {
            
        }];
    } else {
        [[TLAPIClient sharedInstance] archiveCardWithID:self.firstCardView.card.cardID success:^(id responseObject) {
            [weakSelf updateCardViews];
        } failure:^(NSError *error) {
            
        }];
    }
}

#pragma mark - TLCardView methods

- (void)addCardsToView {
    if ([self.cards count] > 0) {
        self.firstCardView.card = [self poppedNextCard];
        if ([self.cards count] > 0) {
            self.secondCardView = [[TLCardView alloc] initWithFrame:[self cardViewFrame] options:[self swipeOptions]];
            self.secondCardView.card = [self poppedNextCard];
            [self.view insertSubview:self.secondCardView belowSubview:self.firstCardView];
        }
    }
}


- (void)updateCardViews {
    if ([self.cards count] > 0) {
        TLCardView *cardToReuse = [self reusableFirstCardView];
        cardToReuse.card = [self poppedNextCard];
        
        self.firstCardView = self.secondCardView;
        self.secondCardView = cardToReuse;
        self.secondCardView.alpha = 0;
        
        [self.view insertSubview:self.secondCardView belowSubview:self.firstCardView];
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.secondCardView.alpha = 1.f;
                         } completion:nil];
    }

}


- (TLCard *)poppedNextCard {
    TLCard *poppedCard = [self.cards firstObject];
    [self.cards removeObjectAtIndex:0];
    return poppedCard;
}


- (TLCardView *)reusableFirstCardView {
    [self.firstCardView prepareForReuse];
    self.firstCardView.frame = [self cardViewFrame];
    self.firstCardView.center = [self cardViewCenterPoint];
    return self.firstCardView;
}


- (MDCSwipeToChooseViewOptions *)swipeOptions {
    MDCSwipeToChooseViewOptions *options = [[MDCSwipeToChooseViewOptions alloc]  init];
    options.delegate = self;
    options.likedText = @"Done";
    options.nopeText = @"Later";
    return options;
}


- (CGRect)cardViewFrame {
    return CGRectMake(16, 96, CGRectGetWidth(self.view.frame) - 32, CGRectGetHeight(self.view.frame) - 128);
}


- (CGPoint)cardViewCenterPoint {
    CGRect frame = [self cardViewFrame];
    CGPoint center;
    center.x = CGRectGetMinX(frame) + (CGRectGetWidth(frame) / 2.0);
    center.y = CGRectGetMinY(frame) + (CGRectGetHeight(frame) / 2.0);
    return center;
}

@end
