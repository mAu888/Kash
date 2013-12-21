/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHChart.h"
#import "KSHPieChart.h"
#import "KSHLineChart.h"
#import "KSHChartGrid.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHChart ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHChart


+ (instancetype)chartWithType:(KSHChartType)chartType
{
    KSHChart *chart = nil;
    switch ( chartType )
    {
        case KSHPieChartType:
            chart = [[KSHPieChart alloc] init];
            break;
        case KSHLineChartType:
            chart = [[KSHLineChart alloc] init];
            break;
    }

    return chart;
}

- (void)drawInRect:(CGRect)rect
{
    @throw [NSException exceptionWithName:@"KSHAbstractClassCallException"
                                   reason:@"An abstract base method has been called"
                                 userInfo:nil];
}

@end