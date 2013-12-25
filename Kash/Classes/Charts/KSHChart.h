/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "KSHChartView.h"
#import "KSHChartDrawable.h"

@protocol KSHChartDataSource;
@protocol KSHChartDelegate;
@class KSHChartGrid;

@interface KSHChart : NSObject

+ (instancetype)chartWithType:(KSHChartType)chartType;

/**
 * The layer containing the chart to be drawn.
 */
- (CALayer *)layerForRect:(CGRect)rect;

/**
 * Animation for the chart.
 */
- (void)animate;

@property(nonatomic, assign) id <KSHChartDataSource> dataSource;
@property(nonatomic, assign) id <KSHChartDelegate> delegate;

/**
 * The grid applied to the chart.
 */
@property(nonatomic, strong) KSHChartGrid *grid;

@end