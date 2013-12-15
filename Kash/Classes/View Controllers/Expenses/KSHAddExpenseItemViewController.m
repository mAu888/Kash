/**
* Created by Maurício Hanika on 11.08.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <CoreData/CoreData.h>
#import "KSHAddExpenseItemViewController.h"
#import "KSHDataAccessLayer.h"
#import "KSHLabelAndTextFieldCell.h"
#import "KSHExpenseItem.h"
#import "KSHInputCellDelegate.h"
#import "KSHExpense.h"
#import "KSHLabelAndTextFieldCell+Formatting.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHAddExpenseItemViewController () <KSHInputCellDelegate>

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHAddExpenseItemViewController
{
    KSHDataAccessLayer *_dataAccessLayer;
    NSManagedObjectContext *_context;
    KSHExpense *_expense;
    KSHExpenseItem *_expenseItem;
}

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer
                      context:(NSManagedObjectContext *)context
                      expense:(KSHExpense *)expense
{
    self = [self initWithDataAccessLayer:dataAccessLayer context:context expenseItem:nil];

    if ( self != nil )
    {
        _expense = ( KSHExpense * ) [_context objectWithID:expense.objectID];
    }

    return self;
}

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer
                      context:(NSManagedObjectContext *)context
                  expenseItem:(KSHExpenseItem *)item
{
    self = [super initWithStyle:UITableViewStyleGrouped];

    if ( self != nil )
    {
        BOOL updatingMode = item != nil;
        NSString *title = !updatingMode ?
            NSLocalizedString(@"Add expense item", nil) :
            NSLocalizedString(@"Update expense item", nil);

        self.title = title;

        _dataAccessLayer = dataAccessLayer;
        _context = context;
        
        // Navigation item -----------------------------------------------------
        self.navigationItem.rightBarButtonItem =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                          target:self
                                                          action:@selector(save:)];

        // Create item ---------------------------------------------------------
        if ( !updatingMode )
        {
            item = ( KSHExpenseItem * ) [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([KSHExpenseItem class])
                                                                      inManagedObjectContext:_context];
        }
        else
        {
            item = ( KSHExpenseItem * ) [_context objectWithID:item.objectID];
        }

        _expenseItem = item;
    }

    return self;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnedCell = nil;
    if ( indexPath.section == 0 )
    {
        static NSString *labelAndTextFieldReuseIdentifier = @"LabelAndTextFieldCellIdentifier";

        KSHLabelAndTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:labelAndTextFieldReuseIdentifier];
        if ( cell == nil )
        {
            cell = [[KSHLabelAndTextFieldCell alloc] initWithReuseIdentifier:labelAndTextFieldReuseIdentifier];
            cell.delegate = self;
        }

        if ( indexPath.row == 0 )
        {
            cell.textFieldType = KSHDefaultTextField;
            cell.textLabel.text = NSLocalizedString(@"Description", nil);
            cell.textField.text = _expenseItem.name;
        }
        else if ( indexPath.row == 1 )
        {
            cell.textFieldType = KSHCurrencyTextField;
            cell.textLabel.text = NSLocalizedString(@"Amount", nil);
            [cell setCurrencyValue:_expenseItem.amount];
        }

        returnedCell = cell;
    }

    else if ( indexPath.section == 1 )
    {

    }

    return returnedCell;
}


#pragma mark - KSHInputCellDelegate

- (void)cellDidChangeValue:(KSHLabelAndTextFieldCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cell.center];

    if ( indexPath.row == 0 )
    {
        _expenseItem.name = cell.textField.text;
    }
    else if ( indexPath.row == 1 )
    {
        KSHExpense *expense = _expense;
        if ( expense == nil )
        {
            expense = _expenseItem.expense;
        }

        if ( expense.items.count > 0 )
        {
            expense.totalAmount = @(round((expense.totalAmount.doubleValue - _expenseItem.amount.doubleValue) * 100.f) / 100.f);
        }
        else
        {
            expense.totalAmount = @(.0f);
        }

        _expenseItem.amount = cell.numericValue;
        expense.totalAmount = @(round((expense.totalAmount.doubleValue + _expenseItem.amount.doubleValue) * 100.f) / 100.f);
    }
}


#pragma mark - Private methods

- (void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)save:(id)sender
{
    [self.view endEditing:YES];

    BOOL updatingMode = _expense == nil;

    // Only assign the expense if we are in "create" mode
    if ( !updatingMode )
    {
        _expenseItem.expense = _expense;
        [[_expense mutableOrderedSetValueForKey:@"items"] addObject:_expenseItem];
    }

    if ( ![_dataAccessLayer saveContext:_context] )
    {
        NSLog(@"Save failed #####################################################################");
    }

    if ( _delegate != nil && [_delegate respondsToSelector:@selector(controllerDidSaveExpenseItem:)] )
    {
        [_delegate controllerDidSaveExpenseItem:self];
    }
}

@end