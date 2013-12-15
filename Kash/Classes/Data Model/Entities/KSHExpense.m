/**
* Created by Maurício Hanika on 14.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHExpense.h"
#import "KSHDateFormatterFactory.h"

// -----------------------------------------------------------------------------
@implementation KSHExpense

@dynamic title;
@dynamic totalAmount;
@dynamic date;
@dynamic account;
@dynamic items;

- (NSString *)titleAccountingEmptyString
{
    return self.title.length == 0 ? NSLocalizedString(@"(no title)", nil) : self.title;
}

- (NSString *)sectionIdentifier
{
    NSDateFormatter *dateFormatter = [[KSHDateFormatterFactory sharedInstance]
        dateFormatterWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];

    return [dateFormatter stringFromDate:self.date];
}

@end
