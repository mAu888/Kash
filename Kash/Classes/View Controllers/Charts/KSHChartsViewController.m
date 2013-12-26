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
#import "KSHNumberFormatter.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHChartsViewController () <KSHChartDataSource, KSHChartDelegate>

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHChartsViewController
{
    KSHDataAccessLayer *_dataAccessLayer;
    NSArray *_weeklyStatistics;
    KSHChartView *_chartView;
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
    [super loadView];

    KSHChartGrid *grid = [[KSHChartGrid alloc] init];
    grid.tickOffset = .0f;
    grid.majorHorizontalDelta = @(40.f);

    KSHLineChart *chart = ( KSHLineChart * ) [KSHChart chartWithType:KSHLineChartType];
    chart.dataSource = self;
    chart.delegate = self;
    chart.grid = grid;
    chart.lineColor = [UIColor chartreuseColor];

    _chartView = [[KSHChartView alloc]
        initWithFrame:CGRectMake(.0f, .0f, CGRectGetWidth(self.view.bounds), 202.f)];
    _chartView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _chartView.contentInsets = UIEdgeInsetsMake(20.f, 14.f, 20.f, 14.f);
    _chartView.chart = chart;
    [self.view addSubview:_chartView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Gather data ---------------------------------------------------------
    KSHExpenseStatistics *stats = [[KSHExpenseStatistics alloc] initWithDataAccessLayer:_dataAccessLayer];
    _weeklyStatistics = [stats weeklyExpensesFromDate:[NSDate dateWithTimeIntervalSinceNow:-3025000]
                                               toDate:[NSDate date]];

    [_chartView reloadData];
    [_chartView.chart animate];
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
    NSNumberFormatter *formatter = [KSHNumberFormatter sharedInstance].currencyNumberFormatter;
    return [formatter stringFromNumber:_weeklyStatistics[( NSUInteger ) index]];
}


#pragma mark - KSHChartDelegate

- (CGPoint)chart:(KSHChart *)chart anchorPointForLabelAtIndex:(NSInteger)index
{
    NSNumber *previousValue = index > 0 ? _weeklyStatistics[( NSUInteger ) (index - 1)] : nil;
    NSNumber *currentValue = _weeklyStatistics[( NSUInteger ) index];
    NSNumber *nextValue = _weeklyStatistics.count > index + 1 ? _weeklyStatistics[( NSUInteger ) (index + 1)] : nil;

    if ( index == 0 && [currentValue compare:nextValue] == NSOrderedDescending )
    {
        return CGPointMake(.0f, 1.f);
    }
    else if ( index == 0 && [currentValue compare:nextValue] == NSOrderedAscending )
    {
        return CGPointMake(.0f, .0f);
    }
    else if ( index == _weeklyStatistics.count - 1 && [currentValue compare:previousValue] == NSOrderedAscending )
    {
        return CGPointMake(1.f, .0f);
    }
    else if ( index == _weeklyStatistics.count - 1 && [currentValue compare:previousValue] == NSOrderedDescending )
    {
        return CGPointMake(1.f, .0f);
    }
    else if ( previousValue != nil && nextValue != nil )
    {
        if ( [currentValue compare:previousValue] == NSOrderedDescending && [currentValue compare:nextValue] == NSOrderedDescending )
        {
            return CGPointMake(.5f, 1.f);
        }
        else if ( [currentValue compare:previousValue] == NSOrderedDescending && [currentValue compare:nextValue] == NSOrderedAscending )
        {
            return CGPointMake(.5f, .0f);
        }
        else if ( [currentValue compare:previousValue] == NSOrderedAscending && [currentValue compare:nextValue] == NSOrderedAscending )
        {
            return CGPointMake(.5f, .0f);
        }
        else if ( [currentValue compare:previousValue] == NSOrderedAscending && [currentValue compare:nextValue] == NSOrderedDescending )
        {
            return CGPointMake(.5f, .0f);
        }
    }

    return CGPointMake(.5f, .5f);
}

@end