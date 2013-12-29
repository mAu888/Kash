/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHLineChart.h"
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
    [[_layer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];

    rect = [self.grid chartRectForRect:rect];

    _layer.frame = rect;
    _layer.path = [self pathForLayer:_layer].CGPath;
    _layer.fillColor = [UIColor clearColor].CGColor;

    // Do the plot symbols
    if ( self.plotSymbol != KSHChartPlotSymbolNone )
    {
        [self addPlotSymbolLayersToLayer:_layer];
    }

    // Do we have any labels?
    if ( [self.dataSource respondsToSelector:@selector(chart:titleForValueAtIndex:)] )
    {
        [self addTextValueLayersToLayer:_layer];
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

- (void)addTextValueLayersToLayer:(CALayer *)layer
{
    [self enumerateValuesForRect:layer.bounds
                      usingBlock:^(id value, CGPoint point, NSInteger index)
                      {
                          CGFontRef font = CGFontCreateWithFontName(( CFStringRef ) @"OpenSans");

                          CATextLayer *textLayer = [CATextLayer layer];
                          textLayer.contentsScale = [UIScreen mainScreen].scale;
                          textLayer.font = font;
                          textLayer.fontSize = 10.f;
                          textLayer.foregroundColor = [UIColor blackColor].CGColor;
//        textLayer.backgroundColor = [UIColor colorWithWhite:1.f alpha:.6f].CGColor;
                          textLayer.backgroundColor = [UIColor clearColor].CGColor;
                          textLayer.string = [self.dataSource chart:self titleForValueAtIndex:index];
                          textLayer.cornerRadius = 5.f;
                          [textLayer adjustBoundsToFit];

                          if ( [self.delegate respondsToSelector:@selector(chart:anchorPointForLabelAtIndex:)] )
                          {
                              textLayer.anchorPoint = [self.delegate chart:self anchorPointForLabelAtIndex:index];
                          }

                          CGFloat yOffset = textLayer.anchorPoint.y < .5f ? 7.f : -7.f;
                          textLayer.position = CGPointMake(point.x, point.y + yOffset);

                          CGFontRelease(font);

                          [layer addSublayer:textLayer];
                      }];
}

- (void)addPlotSymbolLayersToLayer:(CALayer *)layer
{
    [self enumerateValuesForRect:layer.bounds
                      usingBlock:^(id value, CGPoint point, NSInteger index)
                      {
                          CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                          shapeLayer.fillColor = [UIColor whiteColor].CGColor;
                          shapeLayer.strokeColor = [( CAShapeLayer * ) layer strokeColor];
                          shapeLayer.lineWidth = 2.f;
                          shapeLayer.path = [UIBezierPath bezierPathWithArcCenter:point
                                                                           radius:3.f
                                                                       startAngle:0
                                                                         endAngle:( CGFloat ) (2 * M_PI)
                                                                        clockwise:YES].CGPath;
                          [layer addSublayer:shapeLayer];
                      }];
}

- (UIBezierPath *)pathForLayer:(CALayer *)layer
{
    UIBezierPath *path = [UIBezierPath bezierPath];

    [self enumerateValuesForRect:layer.bounds
                      usingBlock:^(id value, CGPoint point, NSInteger index)
                      {
                          index == 0 ?
                              [path moveToPoint:point] :
                              [path addLineToPoint:point];
                      }];

    return path;
}

- (void)enumerateValuesForRect:(CGRect)rect usingBlock:(void (^)(id value, CGPoint point, NSInteger index))block
{
    if ( block != nil )
    {
        NSArray *values = nil;
        double maximumValue;
        double minimumValue;
        long double range;
        [self getValues:&values minimumValue:&minimumValue maximumValue:&maximumValue range:&range];

        [values enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger index, BOOL *stop)
        {
            CGPoint point = [self pointForValueAtIndex:index
                                                values:values
                                          minimumValue:[self.grid.minimumValue doubleValue]
                                          maximumValue:[self.grid.maximumValue doubleValue]
                                                  rect:rect];

            block(value, point, index);
        }];
    }
}

- (CGPoint)pointForValueAtIndex:(NSInteger)index
                         values:(NSArray *)values
                   minimumValue:(double)minimumValue
                   maximumValue:(double)maximumValue
                           rect:(CGRect)rect
{
    CGFloat dx = (CGRectGetWidth(rect) - self.grid.tickOffset) / (( CGFloat ) values.count - 1);

    double range = (MAX(maximumValue, minimumValue) - MIN(maximumValue, minimumValue)) + 1.f;
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