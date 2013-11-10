/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>

@class KSHExpense;
@class KSHDataAccessLayer;

@interface KSHExpenseViewController : UITableViewController

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer expense:(KSHExpense *)expense;

@end