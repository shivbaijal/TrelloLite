//
//  TLAPIClient.m
//  TrelloLite
//
//  Created by Shiv Baijal on 2014-09-15.
//  Copyright (c) 2014 Shiv Baijal. All rights reserved.
//

#import "TLAPIClient.h"
#import "TLBoard.h"
#import "TLList.h"

@implementation TLAPIClient

+ (instancetype)sharedInstance {
    static TLAPIClient *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.trello.com/1/"]];
    });
    return instance;
}


- (void)fetchOpenBoardsWithSuccess:(TLSuccessBlock)success failure:(TLFailureBlock)failure {
    NSString *relativeURLString = [NSString stringWithFormat:@"members/me/boards?key=%@&token=%@", self.key, self.token];
    NSDictionary *params = @{@"filter":@[@"open"], @"lists":@"open"};
    [self GET:relativeURLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}


- (void)fetchListsWithBoardID:(NSString *)boardID includingCards:(BOOL)includingCards success:(TLSuccessBlock)success failure:(TLFailureBlock)failure {
    NSString *relativeURLString = [NSString stringWithFormat:@"boards/%@/lists?key=%@&token=%@", boardID, self.key, self.token];
    NSDictionary *params;
    if (includingCards) {
        params = @{@"cards":@"open"};
    }
    [self GET:relativeURLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            success(responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failure(error);
    }];
}


- (void)archiveCardWithID:(NSString *)cardID success:(TLSuccessBlock)success failure:(TLFailureBlock)failure {
    NSString *relativeURLString = [NSString stringWithFormat:@"cards/%@/closed?key=%@&token=%@", cardID, self.key, self.token];
    NSDictionary *params = @{@"value":@YES};
    [self PUT:relativeURLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}


- (void)moveCardWithIDToTheBottomOfItsList:(NSString *)cardID success:(TLSuccessBlock)success failure:(TLFailureBlock)failure {
    NSString *relativeURLString = [NSString stringWithFormat:@"cards/%@/pos?key=%@&token=%@", cardID, self.key, self.token];
    NSDictionary *params = @{@"value":@"bottom"};
    [self PUT:relativeURLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

@end
