//
//  TLAPIClient.h
//  TrelloLite
//
//  Created by Shiv Baijal on 2014-09-15.
//  Copyright (c) 2014 Shiv Baijal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

typedef void (^TLAPICallback)(id responseObject, NSError *error);

@interface TLAPIClient : AFHTTPSessionManager

@property (nonatomic, copy) NSString *key;

@property (nonatomic, copy) NSString *token;


+ (instancetype)sharedInstance;

- (void)fetchOpenBoards:(TLAPICallback)callback;
- (void)fetchBoardWithID:(NSString *)boardID callback:(TLAPICallback)callback;
- (void)fetchListsWithBoardID:(NSString *)boardID includingCards:(BOOL)includingCards callback:(TLAPICallback)callback;

//may not need this
- (void)fetchCardsWithListID:(NSString *)listID callback:(TLAPICallback)callback;

- (void)archiveCardWithID:(NSString *)cardID callback:(TLAPICallback)callback;
- (void)moveCardWithIDToTheBottomOfItsList:(NSString *)cardID callback:(TLAPICallback)callback;

@end
