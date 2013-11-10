/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHChart.h"
#import "KSHChartDataSource.h"
#import "KSHChartDelegate.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHChart ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHChart
{

}

- (void)drawInRect:(CGRect)rect
{
    @throw [NSException exceptionWithName:@"KSHAbstractClassCallException"
                                   reason:@"An abstract base method has been called"
                                 userInfo:nil];
}


@end