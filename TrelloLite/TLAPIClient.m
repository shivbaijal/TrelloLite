//
//  TLAPIClient.m
//  TrelloLite
//
//  Created by Shiv Baijal on 2014-09-15.
//  Copyright (c) 2014 Shiv Baijal. All rights reserved.
//

#import "TLAPIClient.h"

@implementation TLAPIClient

+ (instancetype)sharedInstance {
    static TLAPIClient *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.trello.com/1/"]];
    });
    return instance;
}

- (void)fetchOpenBoards:(TLAPICallback)callback {
    [self GET:[self URLStringWithPath:@"members/me/boards"] parameters:@{@"filter":@[@"open"], @"lists":@"open"} success:^(NSURLSessionDataTask *task, id responseObject) {
        callback(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        callback(nil, error);
    }];
}

- (void)fetchBoardWithID:(NSString *)boardID callback:(TLAPICallback)callback {
    [self GET:[self URLStringWithPath:[NSString stringWithFormat:@"boards/%@", boardID]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        callback(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        callback(nil, error);
    }];
}

- (void)fetchListsWithBoardID:(NSString *)boardID includingCards:(BOOL)includingCards callback:(TLAPICallback)callback {
    NSDictionary *cardsInfo;
    if (includingCards) {
        cardsInfo = @{@"cards":@"open"};
    }
    [self GET:[self URLStringWithPath:[NSString stringWithFormat:@"boards/%@/lists", boardID]] parameters:cardsInfo success:^(NSURLSessionDataTask *task, id responseObject) {
        callback(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        callback(nil, error);
    }];
}

- (void)fetchCardsWithListID:(NSString *)listID callback:(TLAPICallback)callback {
    [self GET:[self URLStringWithPath:[NSString stringWithFormat:@"lists/%@/cards", listID]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        callback(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        callback(nil, error);
    }];
}

- (void)archiveCardWithID:(NSString *)cardID callback:(TLAPICallback)callback {
    [self PUT:[self URLStringWithPath:[NSString stringWithFormat:@"cards/%@/closed", cardID]] parameters:@{@"value":@YES} success:^(NSURLSessionDataTask *task, id responseObject) {
        callback(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        callback(nil, error);
    }];
}

- (void)moveCardWithIDToTheBottomOfItsList:(NSString *)cardID callback:(TLAPICallback)callback {
    [self PUT:[self URLStringWithPath:[NSString stringWithFormat:@"cards/%@/pos", cardID]] parameters:@{@"value":@"bottom"} success:^(NSURLSessionDataTask *task, id responseObject) {
        callback(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        callback(nil, error);
    }];
}


- (NSString *)URLStringWithPath:(NSString *)path {
    return [NSString stringWithFormat:@"%@?key=%@&token=%@", path, self.key, self.token];
}


@end
