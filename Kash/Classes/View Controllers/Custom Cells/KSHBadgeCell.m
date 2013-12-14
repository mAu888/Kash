/**
* Created by Maurício Hanika on 18.10.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <QuartzCore/QuartzCore.h>
#import <Colours/UIColor+Colours.h>
#import "KSHBadgeCell.h"
#import "KSHExpenseItem.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHBadgeCell ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHBadgeCell
{
    UIImageView *_badgeImageView;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];

    if ( self != nil )
    {
        UIImage *image = [[UIImage imageNamed:@"red-circle.png"]
            resizableImageWithCapInsets:UIEdgeInsetsMake(11.f, 11.f, 10.f, 10.f)];
        _badgeImageView = [[UIImageView alloc]
            initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [self.contentView addSubview:_badgeImageView];

        UIFontDescriptor *footnoteDescriptor =
            [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleFootnote];

        _badgeLabel = [[UILabel alloc] initWithFrame:_badgeImageView.bounds];
        _badgeLabel.font = [UIFont fontWithName:@"OpenSans" size:[footnoteDescriptor pointSize]];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.shadowColor = [UIColor colorWithWhite:.0f alpha:.667f];
        _badgeLabel.shadowOffset = CGSizeMake(.0f, 1.f);
        [_badgeImageView addSubview:_badgeLabel];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat paddingRight = self.accessoryType == UITableViewCellAccessoryNone ? 20.f : 10.f;

    [_badgeLabel sizeToFit];
    CGRect frame = CGRectMake(
        CGRectGetMaxX(self.contentView.bounds) - CGRectGetWidth(_badgeLabel.frame) - paddingRight,
        (CGRectGetHeight(self.contentView.bounds) - CGRectGetHeight(_badgeLabel.frame) - 4.f) / 2.f,
        CGRectGetWidth(_badgeLabel.frame) + 10.f,
        CGRectGetHeight(_badgeLabel.frame) + 4.f
    );

    _badgeImageView.frame = CGRectIntegral(frame);
    _badgeLabel.center = CGPointMake(
        roundf(CGRectGetWidth(_badgeImageView.bounds) / 2.f),
        roundf(CGRectGetHeight(_badgeImageView.bounds) / 2.f)
    );
}

@end