/**
* Created by Maurício Hanika on 15.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHChartsViewController.h"
#import "KSHDataAccessLayer.h"
#import "KSHExpense.h"
#import "KSHExpenseStatistics.h"
#import "KSHChartView.h"
#import "KSHChartDataSource.h"
#import "KSHChart.h"
#import "KSHChartGrid.h"
#import "KSHLineChart.h"
#import "UIColor+Colours.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHChartsViewController () <KSHChartDataSource>

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHChartsViewController
{
    KSHDataAccessLayer *_dataAccessLayer;
    NSArray *_weeklyStatistics;
}

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer
{
    self = [super init];

    if ( self != nil )
    {
        _dataAccessLayer = dataAccessLayer;

        self.title = NSLocalizedString(@"Charts", nil);
        self.edgesForExtendedLayout = UIRectEdgeNone;

        // Tab item ------------------------------------------------------------
        self.tabBarItem.title = NSLocalizedString(@"Charts", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"chart"];
    }

    return self;
}

- (void)loadView
{
    KSHChartGrid *grid = [[KSHChartGrid alloc] init];
    grid.majorHorizontalDelta = @(40.f);
    grid.majorVerticalDelta = @(40.f);
    grid.showsVerticalLines = YES;

    KSHLineChart *chart = ( KSHLineChart * ) [KSHChart chartWithType:KSHLineChartType];
    chart.dataSource = self;
    chart.grid = grid;
    chart.lineColor = [UIColor chartreuseColor];

    KSHChartView *view = [[KSHChartView alloc] init];
    view.contentInsets = UIEdgeInsetsMake(20.f, 14.f, 20.f, 14.f);
    view.chart = chart;

    self.view = view;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Gather data ---------------------------------------------------------
    KSHExpenseStatistics *stats = [[KSHExpenseStatistics alloc] initWithDataAccessLayer:_dataAccessLayer];
    _weeklyStatistics = [stats weeklyExpensesFromDate:[NSDate dateWithTimeIntervalSinceNow:-3025000]
                                               toDate:[NSDate dateWithTimeIntervalSinceNow:60*60*24*7]];

    [(KSHChartView *)self.view reloadData];
}


#pragma mark - KSHChartDataSource

- (NSInteger)numberOfValuesInChart:(KSHChart *)chart
{
    return [_weeklyStatistics count];
}

- (NSNumber *)chart:(KSHChart *)chart valueForIndex:(NSInteger)index
{
    return _weeklyStatistics[( NSUInteger ) index];
}

- (NSString *)titleForValueAtIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"%d KW", 20 + index];
}

@end