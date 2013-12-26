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
        self.clipsToBounds = YES;

        _contentInsets = UIEdgeInsetsZero;
    }

    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGRect insetRect = UIEdgeInsetsInsetRect(rect, _contentInsets);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    // Draw the grid first
    [_chart.grid drawInRect:insetRect];

    // Draw the chart
    [self.layer addSublayer:[_chart layerForRect:insetRect]];

    CGContextRestoreGState(context);
}

- (void)reloadData
{
    [self setNeedsDisplay];
}

@end