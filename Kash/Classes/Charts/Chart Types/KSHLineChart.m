/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHLineChart.h"
#import "KSHChartDataSource.h"
#import "KSHChartGrid.h"
#import "CATextLayer+AutoSizing.h"

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
        _layer = [CAShapeLayer layer];
//        _layer.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.2f].CGColor;
        _layer.strokeColor = [UIColor darkGrayColor].CGColor;
        _layer.lineWidth = 2.f;
        _layer.lineCap = kCALineCapRound;
        _layer.lineJoin = kCALineJoinRound;
    }

    return self;
}

- (CALayer *)layerForRect:(CGRect)rect
{
    _layer.frame = rect;
    _layer.path = [self pathForLayer:_layer].CGPath;
    _layer.fillColor = [UIColor clearColor].CGColor;

    // Do we have any labels?
    if ( [self.dataSource respondsToSelector:@selector(titleForValueAtIndex:)] )
    {
        [self addTitlesForValuesToLayer:_layer];
    }

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


#pragma mark - Setters & Getters

- (CGFloat)lineWidth
{
    return _layer.lineWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _layer.lineWidth = lineWidth;
}

- (UIColor *)lineColor
{
    return [UIColor colorWithCGColor:_layer.strokeColor];
}

- (void)setLineColor:(UIColor *)lineColor
{
    _layer.strokeColor = lineColor.CGColor;
}


#pragma mark - Private methods

- (void)addTitlesForValuesToLayer:(CALayer *)layer
{
    CGRect rect = _layer.bounds;

    NSArray *values = nil;
    double maximumValue;
    double minimumValue;
    long double range;
    [self getValues:&values minimumValue:&minimumValue maximumValue:&maximumValue range:&range];

    [values enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger index, BOOL *stop)
    {
        CGFontRef font = CGFontCreateWithFontName(( CFStringRef ) @"OpenSans");

        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        textLayer.font = font;
        textLayer.fontSize = 10.f;
        textLayer.foregroundColor = [UIColor blackColor].CGColor;
//        textLayer.backgroundColor = [UIColor colorWithWhite:1.f alpha:.6f].CGColor;
        textLayer.backgroundColor = [UIColor clearColor].CGColor;
        textLayer.string = [self.dataSource titleForValueAtIndex:index];
        textLayer.cornerRadius = 5.f;
        [textLayer adjustBoundsToFit];

        if ( [self.delegate respondsToSelector:@selector(chart:anchorPointForLabelAtIndex:)] )
        {
            textLayer.anchorPoint = [self.delegate chart:self anchorPointForLabelAtIndex:index];
        }

        CGPoint point = [self pointForValueAtIndex:index
                                            values:values
                                      minimumValue:minimumValue
                                      maximumValue:maximumValue
                                              rect:rect];

        textLayer.position = point;

        CGFontRelease(font);

        [layer addSublayer:textLayer];
    }];
}

- (UIBezierPath *)pathForLayer:(CALayer *)layer
{
    [[layer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];

    CGRect rect = layer.bounds;

    NSArray *values = nil;
    double maximumValue;
    double minimumValue;
    long double range;
    [self getValues:&values minimumValue:&minimumValue maximumValue:&maximumValue range:&range];

    UIBezierPath *path = [UIBezierPath bezierPath];
    [values enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger index, BOOL *stop)
    {
        CGPoint point = [self pointForValueAtIndex:index
                                        values:values
                                  minimumValue:minimumValue
                                  maximumValue:maximumValue
                                          rect:rect];

        index == 0 ?
            [path moveToPoint:point] :
            [path addLineToPoint:point];
    }];

    return path;
}

- (CGPoint)pointForValueAtIndex:(NSInteger)index
                         values:(NSArray *)values
                   minimumValue:(double)minimumValue
                   maximumValue:(double)maximumValue
                           rect:(CGRect)rect
{
    CGFloat dx = (CGRectGetWidth(rect) - self.grid.tickOffset) / (( CGFloat ) values.count - 1);

    double range = MAX(maximumValue, minimumValue) - MIN(maximumValue, minimumValue);
    double mappingValue = -1 * minimumValue;

    CGFloat x = (index * dx) + CGRectGetMinX(rect) + self.grid.tickOffset;
    CGFloat y = ( CGFloat ) ((mappingValue + [values[( NSUInteger ) index] doubleValue]) / range) * (CGRectGetHeight(rect) - self.grid.tickOffset);
    y = CGRectGetMinY(rect) + CGRectGetHeight(rect) - y - self.grid.tickOffset;

    return CGPointMake(x, y);
}

- (void)getValues:(NSArray **)outValues
     minimumValue:(double *)outMinimumValue
     maximumValue:(double *)outMaximumValue
            range:(long double *)outRange
{
    NSInteger numberOfValues = [self.dataSource numberOfValuesInChart:self];

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

    long double range = fabs(minimumValue) + fabs(maximumValue);

    if ( NULL != outMinimumValue )
    {
        *outMinimumValue = minimumValue;
    }

    if ( NULL != outMaximumValue )
    {
        *outMaximumValue = maximumValue;
    }

    if ( NULL != outRange )
    {
        *outRange = range;
    }

    if ( NULL != outValues )
    {
        *outValues = values;
    }
}

@end