/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHPieChart.h"
#import "KSHChartDataSource.h"
#import "KSHChartDelegate.h"
#import "KSHPieChartDataSource.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHPieChart ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHPieChart
{

}

- (void)drawInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

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

        CGContextSetLineWidth(context, lineWidth);
        [values enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger index, BOOL *stop)
        {
            CGFloat endAngle = twoPI * ( CGFloat ) (value.doubleValue / totalAmount);
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                                radius:radius
                                                            startAngle:currentAngle
                                                              endAngle:(currentAngle + endAngle)
                                                             clockwise:YES];

            UIColor *segmentColor = [self.dataSource pieChart:self colorForSegmentAtIndex:index];
            [segmentColor setStroke];

            path.lineWidth = lineWidth;
            [path stroke];

            currentAngle += endAngle;
        }];
    }

    CGContextRestoreGState(context);
}


@end