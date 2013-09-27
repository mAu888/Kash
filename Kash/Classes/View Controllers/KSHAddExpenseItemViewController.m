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

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer context:(NSManagedObjectContext *)context expense:(KSHExpense *)expense
{
    self = [super initWithStyle:UITableViewStyleGrouped];

    if ( self != nil )
    {
        self.title = NSLocalizedString(@"Add expense item", nil);

        _dataAccessLayer = dataAccessLayer;
        _context = context;
        _expense = expense;

        _expenseItem = ( KSHExpenseItem * ) [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([KSHExpenseItem class])
                                                                          inManagedObjectContext:_context];
        _expenseItem.expense = _expense;

        // Navigation item -----------------------------------------------------
        self.navigationItem.leftBarButtonItem =
                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                              target:self
                                                              action:@selector(cancel:)];

        self.navigationItem.rightBarButtonItem =
                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                              target:self
                                                              action:@selector(save:)];
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ( _context.undoManager == nil )
    {
        _context.undoManager = [[NSUndoManager alloc] init];
    }

    [_context.undoManager beginUndoGrouping];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [_context.undoManager endUndoGrouping];
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
            cell.textFieldType = KSHCurrencyTextField;
            cell.textLabel.text = NSLocalizedString(@"Amount", nil);
            [cell setCurrencyValue:_expenseItem.amount];
        }
        else if ( indexPath.row == 1 )
        {
            cell.textFieldType = KSHDefaultTextField;
            cell.textLabel.text = NSLocalizedString(@"Description", nil);
            cell.textField.text = _expenseItem.name;
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
        _expenseItem.amount = cell.numericValue;
    }
    else if ( indexPath.row == 1 )
    {
        _expenseItem.name = cell.textField.text;
    }
}


#pragma mark - Private methods

- (void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:^
                             {
                                 [_context rollback];
                             }];
}

- (void)save:(id)sender
{
    [self.view endEditing:YES];

    [[_expense mutableOrderedSetValueForKey:@"items"] addObject:_expenseItem];

    if (_delegate != nil && [_delegate respondsToSelector:@selector(controllerDidSaveExpenseItem:)] )
    {
        [_delegate controllerDidSaveExpenseItem:self];
    }

    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end