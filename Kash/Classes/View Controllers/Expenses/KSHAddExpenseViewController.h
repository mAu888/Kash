/**
* Created by Maurício Hanika on 09.08.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHTableViewController.h"

@class KSHDataAccessLayer;
@class KSHExpense;

@interface KSHAddExpenseViewController : KSHTableViewController

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer;
- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer expense:(KSHExpense *)expense;

@end