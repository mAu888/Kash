/**
* Created by Maurício Hanika on 29.09.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHColorCollectionCell.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHColorCollectionCell ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHColorCollectionCell
{

    UIView *_colorView;
}

- (id)init
{
    self = [self initWithFrame:CGRectZero];

    if ( self )
    {

    }

    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if ( self )
    {
        _colorView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        _colorView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _colorView.layer.cornerRadius = 5.f;
        _colorView.layer.shadowColor = [UIColor blackColor].CGColor;
        _colorView.layer.shadowOffset = CGSizeZero;
        _colorView.layer.shadowOpacity = .2f;
        _colorView.layer.shadowRadius = 5.f;
        _colorView.layer.shouldRasterize = YES;

        [self.contentView addSubview:_colorView];
    }

    return self;
}

- (void)setColor:(UIColor *)color
{
    _color = color;

    _colorView.backgroundColor = _color;
}


@end