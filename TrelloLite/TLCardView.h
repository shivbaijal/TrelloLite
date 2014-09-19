//
//  TLCardView.h
//  TrelloLite
//
//  Created by Shiv Baijal on 2014-09-16.
//  Copyright (c) 2014 Shiv Baijal. All rights reserved.
//

#import "MDCSwipeToChooseView.h"
#import "TLCard.h"

@interface TLCardView : MDCSwipeToChooseView

@property (nonatomic, strong) TLCard *card;

- (void)prepareForReuse;

@end
