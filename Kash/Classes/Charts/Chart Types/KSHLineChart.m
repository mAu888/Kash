/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHLineChart.h"
#import "KSHChartDataSource.h"
#import "KSHChartGrid.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHLineChart ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHLineChart

- (id)init
{
    self = [super init];

    if ( self )
    {
        _lineColor = [UIColor darkGrayColor];
        _lineWidth = 2.f;
    }

    return self;
}


- (void)drawInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    NSInteger numberOfValues = [self.dataSource numberOfValuesInChart:self];
    CGFloat dx = (CGRectGetWidth(rect) - self.grid.tickOffset) / (( CGFloat ) numberOfValues - 1);

    double minimumValue = DBL_MIN;
    double maximumValue = DBL_MAX;

    NSMutableArray *values = [NSMutableArray array];
    for ( int i = 0; i < numberOfValues; i++ )
    {
        NSNumber *value = [self.dataSource chart:self valueForIndex:i];
        [values addObject:value];

        minimumValue = minimumValue == DBL_MIN ? value.doubleValue : MIN(minimumValue, value.doubleValue);
        maximumValue = maximumValue == DBL_MAX ? value.doubleValue : MAX(maximumValue, value.doubleValue);
    }

    double mappingValue = -1 * minimumValue;
    long double range = fabs(minimumValue) + fabs(maximumValue);

    UIBezierPath *path = [UIBezierPath bezierPath];
    [values enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger index, BOOL *stop)
    {
        CGFloat x = (index * dx) + CGRectGetMinX(rect) + self.grid.tickOffset;
        CGFloat y = ( CGFloat ) ((mappingValue + value.doubleValue) / range) * (CGRectGetHeight(rect) - self.grid.tickOffset);
        y = CGRectGetMinY(rect) + CGRectGetHeight(rect) - y - self.grid.tickOffset;

        index == 0 ?
            [path moveToPoint:CGPointMake(x, y)] :
            [path addLineToPoint:CGPointMake(x, y)];
    }];

    [_lineColor setStroke];
    [path setLineWidth:_lineWidth];
    [path stroke];

    CGContextRestoreGState(context);
}

@end