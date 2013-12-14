/**
* Created by Maurício Hanika on 11.08.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "KSHTableViewController.h"

@class KSHExpense;
@class KSHExpenseItem;
@class KSHDataAccessLayer;
@class KSHAddExpenseItemViewController;

////////////////////////////////////////////////////////////////////////////////

/**
* The KSHAddExpenseItemControllerDelegate protocol handles information about the editing state of the view controller.
*/
@protocol KSHAddExpenseItemControllerDelegate <NSObject>

@optional
/**
* Informs the delegate about the successful saving of the assigned expense item.
*
* @param controller The controller that did save the expense item.
*/
- (void)controllerDidSaveExpenseItem:(KSHAddExpenseItemViewController *)controller;

@end

////////////////////////////////////////////////////////////////////////////////
@interface KSHAddExpenseItemViewController : KSHTableViewController

@property(nonatomic, weak) id <KSHAddExpenseItemControllerDelegate> delegate;

/**
* Initializes a controller for inserting a new expense item in a given context.
*
* @param dataAccessLayer The data access layer object for managing Core Data related stuff.
* @param context The context to insert the expense item in.
* @param expense The expense to assign the new item with.
*/
- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer
                      context:(NSManagedObjectContext *)context
                      expense:(KSHExpense *)expense;

/**
* Initializes a controller for updating a given expense item.
*
* @param dataAccessLayer The data access layer object for managing Core Data related stuff.
* @param context The context to insert the expense item in.
* @param item The expense item to be updated.
*/
- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)layer
                      context:(NSManagedObjectContext *)context
                  expenseItem:(KSHExpenseItem *)item;

@end