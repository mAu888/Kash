/**
* Created by Maurício Hanika on 14.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHExpenseItem.h"


@implementation KSHExpenseItem

@dynamic name;
@dynamic amount;
@dynamic expense;
@dynamic category;

- (NSString *)nameAccountingEmptyString
{
    return self.name.length == 0 ? NSLocalizedString(@"(no name)", nil) : self.name;
}

@end
