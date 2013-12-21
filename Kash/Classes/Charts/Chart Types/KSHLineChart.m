/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHLineChart.h"
#import "KSHChartDataSource.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHLineChart ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHLineChart
{

}

- (void)drawInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, rect.size.height);
    CGContextConcatCTM(context, flipVertical);

    NSInteger numberOfValues = [self.dataSource numberOfValuesInChart:self];
    CGFloat dx = CGRectGetWidth(rect) / (( CGFloat ) numberOfValues - 1);

    double minimumValue = DBL_MIN;
    double maximumValue = DBL_MAX;

    NSMutableArray *values = [NSMutableArray arrayWithCapacity:( NSUInteger ) numberOfValues];
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
        CGFloat x = index * dx;
        CGFloat y = ( CGFloat ) ((mappingValue + value.doubleValue) / range) * rect.size.height;
        index == 0 ?
            [path moveToPoint:CGPointMake(x, y)] :
            [path addLineToPoint:CGPointMake(x, y)];
    }];

    [[UIColor darkGrayColor] setStroke];
    [path stroke];

    CGContextRestoreGState(context);
}

@end