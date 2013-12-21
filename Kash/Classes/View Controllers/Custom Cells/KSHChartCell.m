/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHChartCell.h"
#import "UIColor+Colours.h"
#import "KSHChartDataSource.h"
#import "KSHPieChartDataSource.h"
#import "KSHPieChart.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHChartCell () <KSHPieChartDataSource>

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHChartCell
{
    NSArray *_items;
    KSHChartView *_chartView;
}

- (id)initWithChartType:(KSHChartType)chartType reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];

    if ( self != nil )
    {
        self.backgroundColor = [UIColor creamColor];

        KSHChart *chart = [KSHChart chartWithType:chartType];
        chart.dataSource = self;

        _chartView = [[KSHChartView alloc] initWithFrame:self.contentView.bounds];
        _chartView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _chartView.chart = chart;
        [self.contentView addSubview:_chartView];
    }

    return self;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    [_chartView reloadData];
}


#pragma mark - KSHChartDataSource

- (UIColor *)pieChart:(KSHPieChart *)pieChart colorForSegmentAtIndex:(NSInteger)index
{
    NSArray *colors = [[UIColor brickRedColor] colorSchemeOfType:ColorSchemeComplementary];
    return colors[( NSUInteger ) (index % colors.count)];
}

- (NSInteger)numberOfValuesInChart:(KSHChart *)chart
{
    return _items.count;
}

- (NSNumber *)chart:(KSHChart *)chart valueForIndex:(NSInteger)index
{
    return _items[( NSUInteger ) index];
}


@end