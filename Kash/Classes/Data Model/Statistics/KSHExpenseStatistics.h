/**
* Created by Maurício Hanika on 21.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>

@class KSHDataAccessLayer;

@interface KSHExpenseStatistics : NSObject

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer;

- (NSNumber *)expensesFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (NSArray *)weeklyExpensesFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

@end