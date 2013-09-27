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

- (CGRect)textRectForBounds:(CGRect)bounds
{
    bounds = [super editingRectForBounds:bounds];
    if ( self.clearButtonMode == UITextFieldViewModeAlways || self.clearButtonMode == UITextFieldViewModeUnlessEditing )
    {
        return bounds;
    }

    return [self rectByApplyingEdgeInsetsToRect:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    bounds = [super editingRectForBounds:bounds];
    if ( self.clearButtonMode == UITextFieldViewModeAlways || self.clearButtonMode == UITextFieldViewModeWhileEditing )
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