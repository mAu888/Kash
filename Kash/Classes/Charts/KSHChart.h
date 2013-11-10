/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>

@protocol KSHChartDataSource;
@protocol KSHChartDelegate;

@interface KSHChart : NSObject

- (void)drawInRect:(CGRect)rect;

@property(nonatomic, assign) id <KSHChartDataSource> dataSource;
@property(nonatomic, assign) id <KSHChartDelegate> delegate;

@end