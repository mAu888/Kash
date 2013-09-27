/**
* Created by Maurício Hanika on 27.09.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "UITableViewCell+Formatting.h"
#import "KSHNumberFormatter.h"
#import "KSHExpenseItem.h"


////////////////////////////////////////////////////////////////////////////////
@implementation UITableViewCell (Formatting)

- (void)setExpenseItem:(KSHExpenseItem *)expenseItem
{
    NSNumberFormatter *currencyNumberFormatter = [KSHNumberFormatter sharedInstance].currencyNumberFormatter;

    self.textLabel.text = expenseItem.name;
    self.detailTextLabel.text = [currencyNumberFormatter stringFromNumber:expenseItem.amount];
}

@end