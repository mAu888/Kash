/**
* Created by Maurício Hanika on 14.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Colours/UIColor+Colours.h>
#import "KSHSubtitleView.h"
#import "UILabel+KSHAdditions.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHSubtitleView ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHSubtitleView
{

}

- (id)init
{
    self = [super init];

    if ( self != nil )
    {
        [self sizeToFit];

        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont fontWithName:@"OpenSans" size:18.f];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];

        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:12.f];
        _detailTextLabel.textAlignment = NSTextAlignmentCenter;
        _detailTextLabel.textColor = [UIColor coolGrayColor];
        [self addSubview:_detailTextLabel];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize size = [_textLabel sizeConstrainedToSize:self.bounds.size];
    _textLabel.frame = CGRectMake(.0f, .0f, CGRectGetWidth(self.bounds), size.height);

    size = [_detailTextLabel sizeConstrainedToSize:CGSizeMake(
        CGRectGetWidth(self.bounds),
        CGRectGetHeight(self.bounds) - size.height
    )];
    _detailTextLabel.frame = CGRectMake(.0f, CGRectGetMaxY(_textLabel.frame), CGRectGetWidth(self.bounds), size.height);
}


- (CGSize)sizeThatFits:(CGSize)size
{
    if ( size.height < 44.f )
    {
        size.height = 44.f;
    }

    if ( size.width < 100.f )
    {
        size.width = 100.f;
    }

    return size;
}

@end