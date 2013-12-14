/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHTableViewController.h"

@class KSHExpense;
@class KSHDataAccessLayer;

@interface KSHExpenseViewController : KSHTableViewController

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer expense:(KSHExpense *)expense;

@end