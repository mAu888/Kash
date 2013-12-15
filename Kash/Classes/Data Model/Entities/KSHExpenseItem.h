/**
* Created by Maurício Hanika on 14.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KSHCategory, KSHExpense;

@interface KSHExpenseItem : NSManagedObject

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSNumber *amount;
@property(nonatomic, retain) KSHExpense *expense;
@property(nonatomic, retain) KSHCategory *category;

@end
