//
//  TLCardView.m
//  TrelloLite
//
//  Created by Shiv Baijal on 2014-09-16.
//  Copyright (c) 2014 Shiv Baijal. All rights reserved.
//

#import "TLCardView.h"

@interface TLCardView ()

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation TLCardView

@synthesize card = _card;

- (id)initWithFrame:(CGRect)frame options:(MDCSwipeToChooseViewOptions *)options {
    self = [super initWithFrame:frame options:options];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:32.0];
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.nameLabel];
        
    }
    return self;
}

- (void)setCard:(TLCard *)card {
    if (_card != card) {
        _card = card;
        self.nameLabel.text = card.name;

        CGFloat nameLabelHeight = [self heightForLabelWithText:self.nameLabel.text
                                                         width:CGRectGetWidth(self.frame)-32
                                                          font:self.nameLabel.font];
        
        //if height is too large, adjust the font size
        if (nameLabelHeight > CGRectGetHeight(self.frame) - 64) {
            self.nameLabel.frame = CGRectMake(16, 32, CGRectGetWidth(self.frame)-32, CGRectGetHeight(self.frame) - 64);
            self.nameLabel.adjustsFontSizeToFitWidth = YES;
        } else {
            self.nameLabel.frame = CGRectMake(16, (CGRectGetHeight(self.frame) - nameLabelHeight)/2.0f, CGRectGetWidth(self.frame)-32, nameLabelHeight);
        }
    }
}

- (TLCard *)card {
    return _card;
}

- (CGFloat)heightForLabelWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font {
    return [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{NSFontAttributeName:font}
                                   context:nil].size.height;
}

- (void)prepareForReuse {
    self.likedView.alpha = 0;
    self.nopeView.alpha = 0;
    self.transform = CGAffineTransformIdentity;
}


@end
