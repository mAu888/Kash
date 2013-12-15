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
        _colorView = [[UIView alloc]
            initWithFrame:CGRectMake(CGRectGetWidth(
                self.contentView.bounds) - CGRectGetHeight(self.contentView.bounds) - 5.f,
                5.f,
                CGRectGetHeight(self.contentView.bounds) - 10.f,
                CGRectGetHeight(self.contentView.bounds) - 10.f)];
        _colorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _colorView.layer.cornerRadius = 5.f;
        _colorView.layer.shadowOpacity = .2f;
        _colorView.layer.shadowColor = [UIColor blackColor].CGColor;
        _colorView.layer.shadowRadius = 3.f;
        _colorView.layer.shadowOffset = CGSizeZero;
        _colorView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_colorView.frame].CGPath;
        _colorView.layer.shouldRasterize = YES;
        [self.contentView addSubview:_colorView];
    }

    return self;
}

- (void)setAccount:(KSHAccount *)account
{
    self.textLabel.text = account.name;
    _colorView.backgroundColor = account.color;
}

@end