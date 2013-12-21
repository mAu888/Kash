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
#import "KSHChartGrid.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHChartView ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHChartView
{
    KSHChart *_chart;
    KSHChartGrid *_grid;
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

- (void)setGrid:(KSHChartGrid *)grid
{
    _grid = grid;
}

- (void)setChartType:(KSHChartType)chartType
{
    _chart = [KSHChart chartWithType:chartType];
    _chart.dataSource = self.dataSource;
    _chart.delegate = self.delegate;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    // Draw the grid first
    [_grid drawInRect:rect];

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