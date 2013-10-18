/**
* Created by Maurício Hanika on 18.10.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "KSHBadgeCell.h"

@class KSHExpense;

@interface KSHBadgeCell (KSHCellConfiguration)

- (void)setExpense:(KSHExpense *)expense;

@end