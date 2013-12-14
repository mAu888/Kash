/**
* Created by Maurício Hanika on 09.08.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "KSHTableViewController.h"

@class KSHDataAccessLayer;

@interface KSHExpensesViewController : KSHTableViewController

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer;

@end