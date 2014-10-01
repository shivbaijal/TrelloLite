//
//  TLList.m
//  TrelloLite
//
//  Created by Shiv Baijal on 2014-09-15.
//  Copyright (c) 2014 Shiv Baijal. All rights reserved.
//

#import "TLList.h"
#import "TLCard.h"

@implementation TLList

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"listID":@"id",
             @"name":@"name",
             @"cards":@"cards"
    };
}


+ (NSValueTransformer *)cardsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[TLCard class]];
}


+ (NSArray *)listsFromJSON:(id)JSON {
    NSArray *listsJSONArray = JSON;
    NSMutableArray *lists = [@[] mutableCopy];
    for (NSDictionary *listDictionary in listsJSONArray) {
        NSError *error = nil;
        TLList *list = [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:listDictionary error:&error];
        [lists addObject:list];
    }
    return lists;
}

@end
