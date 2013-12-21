/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>

@protocol KSHChartDataSource;
@protocol KSHChartDelegate;
@class KSHChartGrid;
@class KSHChart;

typedef NS_ENUM(NSUInteger, KSHChartType)
{
    KSHPieChartType,
    KSHLineChartType
};

////////////////////////////////////////////////////////////////////////////////
@interface KSHChartView : UIView

/**
 * Insets for the chart to be drawn. The insets affect the whole chart view. By default the chart has no insets.
 */
@property(nonatomic, assign) UIEdgeInsets contentInsets;

/**
 * The actual chart to be drawn.
 */
@property(nonatomic, strong) KSHChart *chart;

- (void)reloadData;

@end