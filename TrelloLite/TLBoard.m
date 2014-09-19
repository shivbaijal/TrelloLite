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

@end
