/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "KSHChartView.h"

@protocol KSHChartDataSource;
@protocol KSHChartDelegate;

@interface KSHChart : NSObject

+ (instancetype)chartWithType:(KSHChartType)chartType;

/**
 * No, we're not a subclass of UIView, but the chart view delegates the drawing of different chart types to subclasses
 * of KSHChart. They should know how to draw themselves within a given rectangle.
 *
 * @param CGRect rect
 */
- (void)drawInRect:(CGRect)rect;

@property(nonatomic, assign) id <KSHChartDataSource> dataSource;
@property(nonatomic, assign) id <KSHChartDelegate> delegate;

@end