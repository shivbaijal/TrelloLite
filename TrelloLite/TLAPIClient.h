//
//  TLAPIClient.h
//  TrelloLite
//
//  Created by Shiv Baijal on 2014-09-15.
//  Copyright (c) 2014 Shiv Baijal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

typedef void (^TLSuccessBlock)(id responseObject);
typedef void (^TLFailureBlock)(NSError *error);

@interface TLAPIClient : AFHTTPSessionManager

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *token;


+ (instancetype)sharedInstance;

- (void)fetchOpenBoardsWithSuccess:(TLSuccessBlock)success
                           failure:(TLFailureBlock)failure;

- (void)fetchListsWithBoardID:(NSString *)boardID
               includingCards:(BOOL)includingCards
                      success:(TLSuccessBlock)success
                      failure:(TLFailureBlock)failure;

- (void)archiveCardWithID:(NSString *)cardID
                  success:(TLSuccessBlock)success
                  failure:(TLFailureBlock)failure;

- (void)moveCardWithIDToTheBottomOfItsList:(NSString *)cardID
                                   success:(TLSuccessBlock)success
                                   failure:(TLFailureBlock)failure;

@end
