/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>

@class KSHChart;

@protocol KSHChartDelegate <NSObject>

@optional
- (NSString *)chart:(KSHChart *)chart labelForIndex:(NSInteger)index;

@end