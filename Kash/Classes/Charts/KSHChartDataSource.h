/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>

@class KSHChart;

@protocol KSHChartDataSource <NSObject>

@required
- (NSInteger)numberOfValuesInChart:(KSHChart *)chart;
- (NSNumber *)chart:(KSHChart *)chart valueForIndex:(NSInteger)index;

@optional
- (NSString *)chart:(KSHChart *)chart titleForValueAtIndex:(NSInteger)index;

@end