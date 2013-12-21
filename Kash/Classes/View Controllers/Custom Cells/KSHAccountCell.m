/**
* Created by Maurício Hanika on 29.09.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHAccountCell.h"
#import "KSHAccount.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHAccountCell ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHAccountCell
{

    UIView *_colorView;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];

    if ( self != nil)
    {
        CGFloat diameter = 10.f;
        _colorView = [[UIView alloc]
            initWithFrame:CGRectMake(
                14.f,
                roundf((CGRectGetHeight(self.bounds) - diameter) / 2.f),
                diameter,
                diameter)];
        _colorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:_colorView];
    }

    return self;
}

- (void)setAccount:(KSHAccount *)account
{
    self.textLabel.text = account.name;
    _colorView.backgroundColor = account.color;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _colorView.layer.cornerRadius = roundf(CGRectGetWidth(_colorView.frame) / 2.f);
    self.textLabel.frame = CGRectMake(
        CGRectGetMaxX(_colorView.frame) + 10.f,
        CGRectGetMinY(self.textLabel.frame),
        CGRectGetWidth(self.textLabel.frame),
        CGRectGetHeight(self.textLabel.frame)
    );
}

@end