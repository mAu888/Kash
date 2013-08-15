/**
* Created by Maurício Hanika on 11.08.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>

@class KSHExpense;
@class KSHDataAccessLayer;
@class KSHAddExpenseItemViewController;

@protocol KSHAddExpenseItemControllerDelegate <NSObject>

@optional
- (void)controllerDidSaveExpenseItem:(KSHAddExpenseItemViewController *)controller;

@end


@interface KSHAddExpenseItemViewController : UITableViewController

@property(nonatomic, weak) id <KSHAddExpenseItemControllerDelegate> delegate;

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer context:(NSManagedObjectContext *)context expense:(KSHExpense *)expense;

@end