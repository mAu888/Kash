/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "KSHChartDataSource.h"

@class KSHPieChart;

@protocol KSHPieChartDataSource <KSHChartDataSource>

@required
- (UIColor *)pieChart:(KSHPieChart *)pieChart colorForSegmentAtIndex:(NSInteger)index;

@end