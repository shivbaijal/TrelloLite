//
//  TLCard.m
//  TrelloLite
//
//  Created by Shiv Baijal on 2014-09-15.
//  Copyright (c) 2014 Shiv Baijal. All rights reserved.
//

#import "TLCard.h"

@implementation TLCard

@synthesize description = _description;

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"cardID":@"id",
             @"name":@"name",
             @"description":@"desc"
    };
}

@end
