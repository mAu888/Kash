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

        // Gather data ---------------------------------------------------------
        KSHExpenseStatistics *stats = [[KSHExpenseStatistics alloc] initWithDataAccessLayer:_dataAccessLayer];
        _weeklyStatistics = [stats weeklyExpensesFromDate:[NSDate dateWithTimeIntervalSinceNow:-3025000]
                                                   toDate:[NSDate date]];


    }

    return self;
}

- (void)loadView
{
    KSHChartView *view = [[KSHChartView alloc] init];
    view.dataSource = self;
    [view setChartType:KSHLineChartType];

    self.view = view;
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


@end