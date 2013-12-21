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

- (void)drawInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    // Normalize the coordinate system
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, rect.size.height);
    CGContextConcatCTM(context, flipVertical);

    [[UIColor lightGrayColor] setFill];

    CGFloat horizontalDelta = [_majorHorizontalDelta floatValue];
    for ( int i = 0, j = ( int ) ceil(CGRectGetHeight(rect) / horizontalDelta); i < j; i++ )
    {
        CGRect line = CGRectMake(.0f, i * horizontalDelta, CGRectGetWidth(rect), 1.f);
        CGContextFillRect(context, line);
    }

    CGContextRestoreGState(context);
}

@end