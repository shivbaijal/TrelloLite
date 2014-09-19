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

@property (assign) BOOL loading;
@property (strong) NSMutableArray *cards;
@property (strong) NSMutableArray *lists;
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
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    
    __weak typeof(self) weakSelf = self;
    [[TLAPIClient sharedInstance] fetchListsWithBoardID:self.board.boardID includingCards:YES callback:^(id responseObject, NSError *error) {
        if (responseObject) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                NSArray *listsArray = responseObject;
                NSMutableArray *updatedLists = [@[] mutableCopy];
                for (NSDictionary *listDictionary in listsArray) {
                    NSError *error = nil;
                    TLList *list = [MTLJSONAdapter modelOfClass:[TLList class] fromJSONDictionary:listDictionary error:&error];
                    [updatedLists addObject:list];
                }
                weakSelf.lists = updatedLists;
                weakSelf.cards = [((TLList *)[weakSelf.lists firstObject]).cards mutableCopy];
                weakSelf.loading = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf addCardsToView];
                    [SVProgressHUD dismiss];
                });
            });
        } else {
            weakSelf.loading = NO;
        }
    }];
}

- (void)addCardsToView {
    if ([self.cards count] > 0) {
        self.firstCardView.card = [self.cards firstObject];
        [self.cards removeObjectAtIndex:0];
        
        if ([self.cards count] > 0) {
            self.secondCardView = [[TLCardView alloc] initWithFrame:[self cardViewFrame] options:[self swipeOptions]];
            self.secondCardView.card = [self.cards firstObject];
            [self.cards removeObjectAtIndex:0];
            [self.view insertSubview:self.secondCardView belowSubview:self.firstCardView];
        }
    }
}

#pragma mark - MDCSwipeToChooseDelegate + Helper Methods


- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    if (direction == MDCSwipeDirectionLeft) {
        [[TLAPIClient sharedInstance] moveCardWithIDToTheBottomOfItsList:self.firstCardView.card.cardID callback:^(id responseObject, NSError *error) {
            if (responseObject) {
                [self.cards addObject:self.firstCardView.card];
                [self updateCardViews];
            } else {
            }
        }];
    } else {
        [[TLAPIClient sharedInstance] archiveCardWithID:self.firstCardView.card.cardID callback:^(id responseObject, NSError *error) {
            if (responseObject) {
                [self updateCardViews];
            } else {
            }
        }];
    }

}

- (void)updateCardViews {
    if ([self.cards count] > 0) {
        TLCardView *cardToReuse = self.firstCardView;
        [cardToReuse prepareForReuse]; //is this necessary
        cardToReuse.transform = CGAffineTransformIdentity;
        cardToReuse.frame = [self cardViewFrame];
        cardToReuse.center = [self cardViewCenterPoint];
        cardToReuse.card = [self.cards firstObject];
        
        [self.cards removeObjectAtIndex:0];
        
        self.firstCardView = self.secondCardView;
        self.secondCardView = cardToReuse;
        self.secondCardView.alpha = 0;

        [self.view insertSubview:self.secondCardView belowSubview:self.firstCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.secondCardView.alpha = 1.f;
                         } completion:nil];
    }

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
