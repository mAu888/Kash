/**
* Created by Maurício Hanika on 14.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KSHAccount, KSHExpenseItem;

@interface KSHExpense : NSManagedObject

@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSNumber *totalAmount;
@property(nonatomic, retain) NSDate *date;
@property(nonatomic, retain) KSHAccount *account;
@property(nonatomic, retain) NSOrderedSet *items;
@property(nonatomic, readonly) NSString *sectionIdentifier;

@end

@interface KSHExpense (CoreDataGeneratedAccessors)

- (void)insertObject:(KSHExpenseItem *)value inItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromItemsAtIndex:(NSUInteger)idx;
- (void)insertItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInItemsAtIndex:(NSUInteger)idx withObject:(KSHExpenseItem *)value;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)values;
- (void)addItemsObject:(KSHExpenseItem *)value;
- (void)removeItemsObject:(KSHExpenseItem *)value;
- (void)addItems:(NSOrderedSet *)values;
- (void)removeItems:(NSOrderedSet *)values;

@end
