//
//  TLBoard.m
//  TrelloLite
//
//  Created by Shiv Baijal on 2014-09-15.
//  Copyright (c) 2014 Shiv Baijal. All rights reserved.
//

#import "TLBoard.h"

@implementation TLBoard

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"boardID":@"id",
             @"name":@"name"
    };
}


+ (NSArray *)boardsFromJSON:(id)JSON {
    NSArray *boardsJSONArray = JSON;
    NSMutableArray *boards = [@[] mutableCopy];
    for (NSDictionary *boardDictionary in boardsJSONArray) {
        NSError *error = nil;
        TLBoard *board = [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:boardDictionary error:&error];
        [boards addObject:board];
    }
    return boards;
}

@end
