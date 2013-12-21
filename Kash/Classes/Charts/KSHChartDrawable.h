/**
* Created by Maurício Hanika on 21.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>

@protocol KSHChartDrawable <NSObject>

/**
 * No, we're not a subclass of UIView, but the chart view delegates the drawing of different chart types to subclasses
 * of KSHChart. They should know how to draw themselves within a given rectangle.
 *
 * @param CGRect rect
 */
- (void)drawInRect:(CGRect)rect;

@end