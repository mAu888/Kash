/**
* Created by Maurício Hanika on 14.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface KSHAccount : NSManagedObject

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSSet *expenses;
@property(nonatomic, copy) UIColor *color;

@end


@interface KSHAccount (CoreDataGeneratedAccessors)

- (void)addExpensesObject:(NSManagedObject *)value;

- (void)removeExpensesObject:(NSManagedObject *)value;

- (void)addExpenses:(NSSet *)values;

- (void)removeExpenses:(NSSet *)values;

@end
