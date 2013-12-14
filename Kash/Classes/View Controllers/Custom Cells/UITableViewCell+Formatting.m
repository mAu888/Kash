/**
* Created by Maurício Hanika on 27.09.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "UITableViewCell+Formatting.h"
#import "KSHNumberFormatter.h"
#import "KSHExpenseItem.h"
#import "KSHAccount.h"
#import "KSHDateFormatterFactory.h"


////////////////////////////////////////////////////////////////////////////////
@implementation UITableViewCell (Formatting)

- (void)setAccount:(KSHAccount *)account
{
    self.textLabel.text = NSLocalizedString(@"Account", nil);

    if ( account != nil)
    {
        self.detailTextLabel.text = account.name;
        self.detailTextLabel.textColor = account.color;
    }
    else
    {
        self.detailTextLabel.text = NSLocalizedString(@"Choose account", nil);
        self.detailTextLabel.textColor = [UIColor grayColor];
    }
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setExpenseItem:(KSHExpenseItem *)expenseItem
{
    NSNumberFormatter *currencyNumberFormatter = [KSHNumberFormatter sharedInstance].currencyNumberFormatter;

    self.textLabel.text = expenseItem.name;
    self.detailTextLabel.text = [currencyNumberFormatter stringFromNumber:expenseItem.amount];

    self.textLabel.textColor = [UIColor blackColor];
}

- (void)setDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[KSHDateFormatterFactory sharedInstance]
        dateFormatterWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];

    self.textLabel.text = NSLocalizedString(@"Date", nil);
    self.detailTextLabel.text = [formatter stringFromDate:date];

    self.textLabel.textColor = [UIColor blackColor];
}

- (void)displaysDeleteButtonWithTitle:(NSString *)text
{
    self.textLabel.text = text;
    self.textLabel.textColor = [UIColor redColor];
}


@end