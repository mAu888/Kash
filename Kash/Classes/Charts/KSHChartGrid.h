/**
* Created by Maurício Hanika on 21.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "KSHChartDrawable.h"


////////////////////////////////////////////////////////////////////////////////
@interface KSHChartGrid : NSObject <KSHChartDrawable>

@property(nonatomic, assign) BOOL showsHorizontalLines;
@property(nonatomic, assign) BOOL showsVerticalLines;

@property(nonatomic, assign) CGFloat lineWidth;
@property(nonatomic, strong) UIColor *lineColor;

/**
 * The tick offset defines the horizontal respectively vertical offset the grid lines have over the real value range.
 */
@property(nonatomic, assign) CGFloat tickOffset;

/**
 * Defines the horizontal delta between two grid lines. The value must be greater than or equal to zero.
 */
@property(nonatomic, strong) NSNumber *majorHorizontalDelta;

/**
 * Defines the vertical delta between two grid lines. The value must be grater than or equal to zero.
 */
@property(nonatomic, strong) NSNumber *majorVerticalDelta;

/**
 * Range of values in the grid.
 */
@property(nonatomic, strong) NSArray *plotRange;

/**
 * Values for the x axis labels. If set the horizontal lines offset will be overridden to match the count of the labels.
 */
@property(nonatomic, strong) NSArray *xLabels;


/**
 * Converts the given rectangle to the rectangle actually available for drawing the chart.
 */
- (CGRect)chartRectForRect:(CGRect)rect;

- (NSNumber *)minimumValue;
- (NSNumber *)maximumValue;
@end