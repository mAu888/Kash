/**
* Created by Maurício Hanika on 18.10.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHBadgeCell+KSHCellConfiguration.h"
#import "KSHExpense.h"
#import "KSHNumberFormatter.h"
#import "KSHAccount.h"
#import "UIColor+Colours.h"

////////////////////////////////////////////////////////////////////////////////
@implementation KSHBadgeCell (KSHCellConfiguration)

- (void)setExpense:(KSHExpense *)expense
{
    NSNumberFormatter *currencyFormatter = [KSHNumberFormatter sharedInstance].currencyNumberFormatter;

    self.textLabel.text = expense.title;
    self.badgeLabel.text = [currencyFormatter stringFromNumber:expense.totalAmount];

    self.tintColor = [expense.totalAmount floatValue] > .0f ? [UIColor brickRedColor] : [UIColor grassColor];
}

@end