/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>

@protocol KSHChartDataSource;
@protocol KSHChartDelegate;

typedef NS_ENUM(NSUInteger, KSHChartType)
{
    KSHPieChartType,
    KSHLineChartType
};

@interface KSHChartView : UIView

@property(nonatomic, assign) id <KSHChartDataSource> dataSource;
@property(nonatomic, assign) id <KSHChartDelegate> delegate;

- (void)setChartType:(KSHChartType)chartType;

- (void)reloadData;
@end