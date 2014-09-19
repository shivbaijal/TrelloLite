//
//  TLCard.h
//  TrelloLite
//
//  Created by Shiv Baijal on 2014-09-15.
//  Copyright (c) 2014 Shiv Baijal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface TLCard : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *cardID;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *description;

@end
