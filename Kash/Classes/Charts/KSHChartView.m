/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHChartView.h"
#import "KSHChart.h"
#import "KSHPieChart.h"
#import "KSHChartDataSource.h"
#import "KSHChartDelegate.h"
#import "KSHLineChart.h"

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
    }

    return self;
}

- (void)setChartType:(KSHChartType)chartType
{
    switch ( chartType )
    {
        case KSHPieChartType:
        {
            _chart = [[KSHPieChart alloc] init];
        }
            break;

        case KSHLineChartType:
        {
            _chart = [[KSHLineChart alloc] init];
        }
            break;
    }

    _chart.dataSource = self.dataSource;
    _chart.delegate = self.delegate;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    // Draw the chart
    [_chart drawInRect:rect];

    CGContextRestoreGState(context);
}

- (void)reloadData
{
    [self setNeedsDisplay];
}

- (void)setDataSource:(id <KSHChartDataSource>)dataSource
{
    _dataSource = dataSource;
    _chart.dataSource = _dataSource;
}

- (void)setDelegate:(id <KSHChartDelegate>)delegate
{
    _delegate = delegate;
    _chart.delegate = delegate;
}


@end