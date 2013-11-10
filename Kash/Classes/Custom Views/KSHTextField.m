/**
* Created by Maurício Hanika on 27.09.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHTextField.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHTextField ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHTextField
{
    NSMutableDictionary *_textColors;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if ( self != nil )
    {
        _textColors = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
    _textColors[@(UIControlStateNormal)] = textColor;
}

- (void)setTextColor:(UIColor *)textColor forControlState:(UIControlState)state
{
    if ( _textColors[@(UIControlStateNormal)] == nil )
    {
        _textColors[@(UIControlStateNormal)] = self.textColor;
    }

    _textColors[@(state)] = textColor;
    [self updateTextColor];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self updateTextColor];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    [self updateTextColor];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self updateTextColor];
}

- (void)updateTextColor
{
    if ( (self.state & UIControlStateHighlighted) == UIControlStateHighlighted && _textColors[@(UIControlStateHighlighted)] != nil )
    {
        self.textColor = _textColors[@(UIControlStateHighlighted)];
    }
    else if ( (self.state & UIControlStateDisabled) == UIControlStateDisabled && _textColors[@(UIControlStateDisabled)] != nil )
    {
        self.textColor = _textColors[@(UIControlStateDisabled)];
    }
    else if ( (self.state & UIControlStateSelected) == UIControlStateSelected && _textColors[@(UIControlStateSelected)] != nil )
    {
        self.textColor = _textColors[@(UIControlStateSelected)];
    }
    else
    {
        self.textColor = _textColors[@(UIControlStateNormal)];
    }
}


- (CGRect)textRectForBounds:(CGRect)bounds
{
    bounds = [super textRectForBounds:bounds];
    if ( self.clearButtonMode == UITextFieldViewModeAlways || self.clearButtonMode == UITextFieldViewModeUnlessEditing )
    {
        return bounds;
    }

    return [self rectByApplyingEdgeInsetsToRect:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    bounds = [super editingRectForBounds:bounds];
    if ( self.clearButtonMode == UITextFieldViewModeAlways || (self.clearButtonMode == UITextFieldViewModeWhileEditing && self.text.length > 0) )
    {
        return bounds;
    }

    return [self rectByApplyingEdgeInsetsToRect:bounds];
}

- (CGRect)rectByApplyingEdgeInsetsToRect:(CGRect)rect
{
    CGRect newRect = rect;
    newRect.origin.x += _textInsets.left;
    newRect.origin.y += _textInsets.top;
    newRect.size.width = newRect.size.width - _textInsets.left - _textInsets.right;
    newRect.size.height = newRect.size.height - _textInsets.top - _textInsets.bottom;

    return newRect;
}

@end