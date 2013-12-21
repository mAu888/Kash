/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHChartView.h"
#import "KSHChart.h"
#import "KSHChartDataSource.h"
#import "KSHChartDelegate.h"
#import "KSHChartGrid.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHChartView ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHChartView
{
    KSHChart *_chart;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if ( self != nil )
    {
        self.backgroundColor = [UIColor whiteColor];

        _contentInsets = UIEdgeInsetsZero;
    }

    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    rect = UIEdgeInsetsInsetRect(rect, _contentInsets);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    // Draw the grid first
    [_chart.grid drawInRect:rect];

    // Draw the chart
    [_chart drawInRect:rect];

    CGContextRestoreGState(context);
}

- (void)reloadData
{
    [self setNeedsDisplay];
}

@end