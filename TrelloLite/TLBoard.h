//
//  TLBoard.h
//  TrelloLite
//
//  Created by Shiv Baijal on 2014-09-15.
//  Copyright (c) 2014 Shiv Baijal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface TLBoard : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *boardID;
@property (nonatomic, copy, readonly) NSString *name;

+ (NSArray *)boardsFromJSON:(id)JSON;

@end
