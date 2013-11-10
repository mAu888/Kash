/**
* Created by Maurício Hanika on 27.09.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>

@class KSHAccount;
@class KSHExpenseItem;

@interface UITableViewCell (Formatting)

- (void)setAccount:(KSHAccount *)account;
- (void)setExpenseItem:(KSHExpenseItem *)expenseItem;
- (void)displaysDeleteButtonWithTitle:(NSString *)text;

@end