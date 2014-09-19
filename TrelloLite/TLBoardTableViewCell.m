//
//  TLBoardTableViewCell.m
//  TrelloLite
//
//  Created by Shiv Baijal on 2014-09-16.
//  Copyright (c) 2014 Shiv Baijal. All rights reserved.
//

#import "TLBoardTableViewCell.h"

@implementation TLBoardTableViewCell

@synthesize board = _board;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.font = [UIFont boldSystemFontOfSize:18];
        self.layoutMargins = UIEdgeInsetsZero;
    }
    return self;
}


- (void)setBoard:(TLBoard *)board {
    if (_board != board) {
        _board = board;
        self.textLabel.text = board.name;
    }
}

- (TLBoard *)board {
    return _board;
}

@end
