/**
* Created by Maurício Hanika on 27.09.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "UITableViewCell+Formatting.h"
#import "KSHNumberFormatter.h"
#import "KSHExpenseItem.h"
#import "KSHAccount.h"


////////////////////////////////////////////////////////////////////////////////
@implementation UITableViewCell (Formatting)

- (void)setAccount:(KSHAccount *)account
{
    self.textLabel.text = NSLocalizedString(@"Account", nil);
    self.detailTextLabel.text = account != nil ? account.name : NSLocalizedString(@"Choose account", nil);
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setExpenseItem:(KSHExpenseItem *)expenseItem
{
    NSNumberFormatter *currencyNumberFormatter = [KSHNumberFormatter sharedInstance].currencyNumberFormatter;

    self.textLabel.text = expenseItem.name;
    self.detailTextLabel.text = [currencyNumberFormatter stringFromNumber:expenseItem.amount];
}

@end