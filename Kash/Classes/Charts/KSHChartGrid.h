/**
* Created by Maurício Hanika on 21.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "KSHChartDrawable.h"

@interface KSHChartGrid : NSObject <KSHChartDrawable>

@property(nonatomic, assign) BOOL showsHorizontalLines;
@property(nonatomic, assign) BOOL showsVerticalLines;

/**
 * Defines the horizontal delta between two grid lines. The value must be greater than or equal to zero.
 */
@property(nonatomic, assign) NSNumber *majorHorizontalDelta;

/**
 * Defines the vertical delta between two grid lines. The value must be grater than or equal to zero.
 */
@property(nonatomic, assign) NSNumber *majorVerticalDelta;

@end