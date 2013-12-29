/**
* Created by Maurício Hanika on 21.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHChartGrid.h"
#import "UIColor+Colours.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHChartGrid ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHChartGrid
{
    CGFloat _xLabelsHeight;
    CGFloat _yLabelsWidth;
}

- (id)init
{
    self = [super init];

    if ( self != nil )
    {
        _tickOffset = 5.f;

        _showsHorizontalLines = YES;
        _showsVerticalLines = NO;

        _lineColor = [UIColor colorWithWhite:.875f alpha:1.f];
        _lineWidth = 1.f;

        _xLabelsHeight = 25.f;
        _yLabelsWidth = .0f;
    }

    return self;
}


- (void)drawInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    [_lineColor setFill];

    // Draw horizontal lines
    if ( _showsHorizontalLines )
    {
        CGFloat horizontalDelta = [_majorHorizontalDelta floatValue];
        for ( int i = 0, j = ( int ) ceil((CGRectGetHeight(rect) - _xLabelsHeight) / horizontalDelta); i < j; i++ )
        {
            CGRect line = CGRectMake(
                CGRectGetMinX(rect) + _yLabelsWidth,
                CGRectGetMinY(rect) + CGRectGetHeight(rect) - _xLabelsHeight - _tickOffset - (i * horizontalDelta),
                CGRectGetWidth(rect) - _yLabelsWidth,
                _lineWidth
            );
            CGContextFillRect(context, line);
        }
    }

    // Draw vertical lines
    if ( _showsVerticalLines )
    {
        CGFloat verticalDelta = _xLabels.count > 0 ?
            (CGRectGetWidth(rect) - _yLabelsWidth - _tickOffset) / (_xLabels.count - 1) :
            [_majorVerticalDelta floatValue];
        for ( int i = 0, j = ( int ) ceil((CGRectGetWidth(rect) - _yLabelsWidth - _tickOffset) / verticalDelta); i < j; i++ )
        {
            CGRect line = CGRectMake(
                CGRectGetMinX(rect) + _tickOffset + _yLabelsWidth + (i * verticalDelta),
                CGRectGetMinY(rect),
                _lineWidth,
                CGRectGetHeight(rect) - _xLabelsHeight
            );
            CGContextFillRect(context, line);
        }
    }

    // Draw labels
    if ( _xLabels.count > 0 )
    {
        CGFloat dx = (CGRectGetWidth(rect) - _tickOffset - _yLabelsWidth) / (_xLabels.count - 1);
        [_xLabels enumerateObjectsUsingBlock:^(NSString *label, NSUInteger index, BOOL *stop)
        {
            CGFloat x = CGRectGetMinX(rect) + _tickOffset + _yLabelsWidth + (index * dx);
            CGFloat y = CGRectGetHeight(rect) - _tickOffset;

            NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:@"OpenSans" size:11.f]};
            CGRect drawingRect =
                [label boundingRectWithSize:CGSizeMake(75.f, 100.f)
                                    options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attributes
                                    context:nil];

            CGRect textRect = CGRectMake(x - (drawingRect.size.width / 2.f), y, drawingRect.size.width, drawingRect.size.height);
            [label drawInRect:textRect withAttributes:attributes];
        }];
    }

    CGContextRestoreGState(context);
}

- (CGRect)chartRectForRect:(CGRect)rect
{
    rect.origin.x += _yLabelsWidth;
    rect.size.width -= _yLabelsWidth;
    rect.size.height -= _xLabelsHeight;

    return rect;
}

- (NSNumber *)minimumValue
{
    return [_plotRange firstObject];
}

- (NSNumber *)maximumValue
{
    return [_plotRange lastObject];
}

@end