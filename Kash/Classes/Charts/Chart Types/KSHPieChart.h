/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "KSHChart.h"

@protocol KSHPieChartDataSource;

@interface KSHPieChart : KSHChart

@property(nonatomic, assign) id <KSHChartDataSource, KSHPieChartDataSource> dataSource;

@end