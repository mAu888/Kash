/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHPieChart.h"
#import "KSHChartDataSource.h"
#import "KSHPieChartDataSource.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHPieChart ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHPieChart
{
    CALayer *_layer;
}

- (id)init
{
    self = [super init];

    if ( self )
    {
        _layer = [CALayer layer];
    }

    return self;
}


- (CALayer *)layerForRect:(CGRect)rect
{
    [[_layer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];

    NSInteger numberOfSegments = [self.dataSource numberOfValuesInChart:self];
    if ( numberOfSegments > 0 )
    {
        double totalAmount = .0f;
        NSMutableArray *values = [NSMutableArray arrayWithCapacity:( NSUInteger ) numberOfSegments];
        for ( NSInteger i = 0; i < numberOfSegments; i++ )
        {
            NSNumber *value = [self.dataSource chart:self valueForIndex:i];
            totalAmount += value.doubleValue;

            [values addObject:value];
        }

        // Do the magic!
        CGFloat smallerEdge = floorf(MIN(rect.size.width, rect.size.height) / 2.f);

        CGFloat lineWidth = smallerEdge - (smallerEdge / 1.95f);
        CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
        CGFloat radius = smallerEdge - lineWidth;
        __block CGFloat currentAngle = .0f;
        CGFloat twoPI = ( CGFloat ) (2 * M_PI);

        [values enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger index, BOOL *stop)
        {
            CGFloat endAngle = twoPI * ( CGFloat ) (value.doubleValue / totalAmount);
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                                radius:radius
                                                            startAngle:currentAngle
                                                              endAngle:(currentAngle + endAngle)
                                                             clockwise:YES];

            CAShapeLayer *partsLayer = [CAShapeLayer layer];
            partsLayer.fillColor = [UIColor clearColor].CGColor;
            partsLayer.strokeColor = [self.dataSource pieChart:self colorForSegmentAtIndex:index].CGColor;
            partsLayer.lineWidth = lineWidth;
            partsLayer.path = path.CGPath;

            [_layer addSublayer:partsLayer];

            currentAngle += endAngle;
        }];
    }

    return _layer;
}

- (void)animate
{
    [_layer.sublayers enumerateObjectsUsingBlock:^(CAShapeLayer *layer, NSUInteger index, BOOL *stop)
    {
        layer.strokeEnd = .0f;

        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @(.0f);
        animation.toValue = @(1.f);
        animation.duration = .667f;
        animation.beginTime = CACurrentMediaTime() + (index * .667);
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.removedOnCompletion = NO;
        animation.delegate = self;

        [layer addAnimation:animation forKey:@"strokeEndAnimation"];
    }];
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished
{
    [_layer.sublayers enumerateObjectsUsingBlock:^(CAShapeLayer *layer, NSUInteger index, BOOL *stop)
    {
        if ( [layer animationForKey:@"strokeEndAnimation"] == animation )
        {
            layer.strokeEnd = 1.f;
            [layer removeAllAnimations];
        }
    }];
}

@end