/**
* Created by Maurício Hanika on 18.10.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <QuartzCore/QuartzCore.h>
#import "KSHBadgeCell.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHBadgeCell ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHBadgeCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];

    if ( self != nil )
    {
        _badgeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _badgeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.shadowColor = [UIColor colorWithWhite:.0f alpha:.667f];
        _badgeLabel.shadowOffset = CGSizeMake(.0f, 1.f);
        [self.contentView addSubview:_badgeLabel];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [_badgeLabel sizeToFit];
    CGRect frame = CGRectMake(
        CGRectGetMaxX(self.contentView.bounds) - CGRectGetWidth(_badgeLabel.frame) - 10.f,
        (CGRectGetHeight(self.contentView.bounds) - CGRectGetHeight(_badgeLabel.frame) - 4.f) / 2.f,
        CGRectGetWidth(_badgeLabel.frame) + 10.f,
        CGRectGetHeight(_badgeLabel.frame) + 4.f
    );
    _badgeLabel.frame = CGRectIntegral(frame);
    _badgeLabel.layer.cornerRadius = CGRectGetHeight(frame) / 2.f;
}

- (void)setBadgeColor:(UIColor *)badgeColor
{
    _badgeLabel.layer.backgroundColor = badgeColor.CGColor;
}

@end