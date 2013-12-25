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
{
    CAShapeLayer *_layer;
}

- (id)init
{
    self = [super init];

    if ( self )
    {
        _lineColor = [UIColor darkGrayColor];
        _lineWidth = 2.f;
        _layer = [CAShapeLayer layer];
    }

    return self;
}


- (UIBezierPath *)pathForRect:(CGRect)rect
{
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

    return path;
}

- (CALayer *)layerForRect:(CGRect)rect
{
    _layer.path = [self pathForRect:rect].CGPath;
    _layer.fillColor = [UIColor clearColor].CGColor;
    _layer.strokeColor = _lineColor.CGColor;
    _layer.lineWidth = _lineWidth;

    return _layer;
}

- (void)animate
{
    _layer.strokeEnd = 1.f;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(.0f);
    animation.toValue = @(1.f);
    animation.duration = .667f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_layer addAnimation:animation forKey:@"strokeEndAnimation"];
}


@end