/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHExpenseCell.h"
#import "KSHExpense.h"
#import "KSHDateFormatterFactory.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHExpenseCell ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHExpenseCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    return self;
}

- (void)setExpense:(KSHExpense *)expense
{
    NSDateFormatter *dateFormatter = [[KSHDateFormatterFactory sharedInstance]
        dateFormatterWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    self.textLabel.text = expense.titleAccountingEmptyString;
    self.detailTextLabel.text = [dateFormatter stringFromDate:expense.date];
}

@end