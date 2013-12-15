/**
* Created by Maurício Hanika on 14.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHExpense.h"
#import "KSHAccount.h"
#import "KSHExpenseItem.h"
#import "KSHDateFormatterFactory.h"

// -----------------------------------------------------------------------------
@implementation KSHExpense

@dynamic title;
@dynamic totalAmount;
@dynamic date;
@dynamic account;
@dynamic items;

- (NSString *)sectionIdentifier
{
    NSDateFormatter *dateFormatter = [[KSHDateFormatterFactory sharedInstance]
        dateFormatterWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];

    return [dateFormatter stringFromDate:self.date];
}

@end
