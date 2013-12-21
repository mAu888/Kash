/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "KSHChartView.h"
#import "KSHChartDrawable.h"

@protocol KSHChartDataSource;
@protocol KSHChartDelegate;

@interface KSHChart : NSObject <KSHChartDrawable>

+ (instancetype)chartWithType:(KSHChartType)chartType;

@property(nonatomic, assign) id <KSHChartDataSource> dataSource;
@property(nonatomic, assign) id <KSHChartDelegate> delegate;

@end