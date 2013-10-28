/**
* Created by Maurício Hanika on 18.10.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHBadgeCell+KSHCellConfiguration.h"
#import "KSHExpense.h"
#import "KSHNumberFormatter.h"
#import "KSHAccount.h"

////////////////////////////////////////////////////////////////////////////////
@implementation KSHBadgeCell (KSHCellConfiguration)

- (void)setExpense:(KSHExpense *)expense
{
    NSNumberFormatter *currencyFormatter = [KSHNumberFormatter sharedInstance].currencyNumberFormatter;

    UIColor *redColor = [UIColor colorWithRed:(177.f/255.f)
                                        green:(71.f/255.f)
                                         blue:(91.f/255.f)
                                        alpha:1.f];

    self.textLabel.text = expense.title;
    self.badgeLabel.text = [currencyFormatter stringFromNumber:expense.totalAmount];
    [self setBadgeColor:redColor];
}

@end