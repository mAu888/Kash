/**
* Created by Maurício Hanika on 09.08.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>

@class KSHDataAccessLayer;
@class KSHExpense;

@interface KSHAddExpenseViewController : UITableViewController

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer;

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer expense:(KSHExpense *)expense;

@end