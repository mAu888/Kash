/**
* Created by Maurício Hanika on 09.08.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHAddExpenseViewController.h"
#import "KSHLabelAndTextfieldCell.h"
#import "KSHDataAccessLayer.h"
#import "KSHAccount.h"
#import "KSHExpense.h"
#import "KSHInputCellDelegate.h"
#import "enums.h"
#import "KSHAccountsViewController.h"
#import "KSHAddExpenseItemViewController.h"

NS_ENUM(NSInteger, KSHAddExpenseDescriptionRows)
{
    KSHAddExpenseTitleRow,
    KSHAddExpenseTotalAmountRow,
    numberOfRowsInDescriptionSection
};

////////////////////////////////////////////////////////////////////////////////
@interface KSHAddExpenseViewController () <KSHInputCellDelegate, KSHAccountsControllerDelegate, KSHAddExpenseItemControllerDelegate>

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHAddExpenseViewController
{

    KSHDataAccessLayer *_dataAccessLayer;
    NSArray *_accounts;
    KSHExpense *_expense;
    NSManagedObjectContext *_context;

    KSHNavigationStyle _navigationStyle;
}

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer
{
    self = [super initWithStyle:UITableViewStyleGrouped];

    if ( self != nil )
    {
        _navigationStyle = KSHModalPresentationStyle;

        self.title = NSLocalizedString(@"Add expense", nil);


        // Navigation item -----------------------------------------------------
        self.navigationItem.leftBarButtonItem =
                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                              target:self
                                                              action:@selector(cancel:)];

        self.navigationItem.rightBarButtonItem =
                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                              target:self
                                                              action:@selector(save:)];

        // Data source ---------------------------------------------------------
        _dataAccessLayer = dataAccessLayer;
        _context = [_dataAccessLayer contextForEditing];
        _expense = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([KSHExpense class])
                                                 inManagedObjectContext:_context];
    }

    return self;
}

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer expense:(KSHExpense *)expense
{
    self = [super initWithStyle:UITableViewStyleGrouped];

    if ( self != nil )
    {
        _navigationStyle = KSHNavigationControllerStyle;

        self.title = NSLocalizedString(@"Update expense", nil);



        // Navigation item -----------------------------------------------------
        self.navigationItem.rightBarButtonItem =
                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                              target:self
                                                              action:@selector(save:)];

        // Data source ---------------------------------------------------------
        _dataAccessLayer = dataAccessLayer;
        _context = [_dataAccessLayer contextForEditing];
        _expense = (KSHExpense *)[_context objectWithID:expense.objectID];
    }

    return self;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch ( section )
    {
        case 0:
            return numberOfRowsInDescriptionSection;
        case 1:
            return 1;
        case 2:
            return _expense.items.count + 1;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnedCell = nil;

    if ( indexPath.section == 0 )
    {
        static NSString *reuseIdentifier = @"TextFieldCellIdentifier";

        KSHLabelAndTextfieldCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if ( cell == nil )
        {
            cell = [[KSHLabelAndTextfieldCell alloc] initWithReuseIdentifier:reuseIdentifier];
            cell.delegate = self;
        }

        if ( indexPath.row == KSHAddExpenseTitleRow )
        {
            cell.textLabel.text = NSLocalizedString(@"For what?", nil);
            cell.textField.text = _expense.title;
        }
        else if ( indexPath.row == KSHAddExpenseTotalAmountRow )
        {
            cell.textLabel.text = NSLocalizedString(@"How much?", nil);
            cell.textField.text = [NSString stringWithFormat:@"%.2f",
                                                             [_expense.totalAmount doubleValue]];
        }

        returnedCell = cell;
    }

    else if ( indexPath.section == 1 )
    {
        static NSString *reuseIdentifier = @"CellIdentifier";

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if ( cell == nil )
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:reuseIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        cell.textLabel.text = NSLocalizedString(@"Account", nil);
        cell.detailTextLabel.text = _expense.account != nil ? _expense.account.name : NSLocalizedString(@"Choose account", nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        returnedCell = cell;
    }

    else if ( indexPath.section == 2 )
    {
        static NSString *reuseIdentifier = @"CellIdentifier";

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if ( cell == nil )
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:reuseIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        if ( indexPath.row == _expense.items.count )
        {
            cell.textLabel.text = NSLocalizedString(@"Add item", nil);
        }
        else if ( indexPath.row < _expense.items.count )
        {
            cell.textLabel.text = [_expense.items[indexPath.row] name];
        }

        returnedCell = cell;
    }

    return returnedCell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 1 )
    {
        KSHAccountsViewController *controller =
                [[KSHAccountsViewController alloc] initWithDataAccessLayer:_dataAccessLayer
                                                           selectedAccount:_expense.account];
        controller.delegate = self;
        [self.navigationController pushViewController:controller
                                             animated:YES];
    }

    else if ( indexPath.section == 2 && indexPath.row == _expense.items.count )
    {
        KSHAddExpenseItemViewController *controller =
                [[KSHAddExpenseItemViewController alloc] initWithDataAccessLayer:_dataAccessLayer
                                                                         context:_context
                                                                         expense:_expense];
        controller.delegate = self;

        UINavigationController *navigationController =
                [[UINavigationController alloc] initWithRootViewController:controller];

        [self presentViewController:navigationController
                           animated:YES
                         completion:nil];
    }
}


#pragma mark - KSHInputCellDelegate

- (void)cellDidChangeValue:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cell.center];
    if ( indexPath.section == 0 && indexPath.row == KSHAddExpenseTitleRow )
    {
        _expense.title = (( KSHLabelAndTextfieldCell * ) cell).textField.text;
    }
    else if ( indexPath.section == 0 && indexPath.row == KSHAddExpenseTotalAmountRow )
    {
        _expense.totalAmount = @([(( KSHLabelAndTextfieldCell * ) cell).textField.text doubleValue]);
    }
}


#pragma mark - KSHAccountsControllerDelegate

- (void)controller:(KSHAccountsViewController *)controller didSelectAccount:(KSHAccount *)account
{
    _expense.account = (KSHAccount *)[_context objectWithID:account.objectID];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                  withRowAnimation:UITableViewRowAnimationNone];

    [controller.navigationController popViewControllerAnimated:YES];
}


#pragma mark - KSHAddExpenseItemControllerDelegate

- (void)controllerDidSaveExpenseItem:(KSHAddExpenseItemViewController *)controller
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Private methods

- (void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)save:(id)sender
{
    [self.view endEditing:YES];

    if ( ![_dataAccessLayer saveContext:_context] )
    {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:NSLocalizedString(@"Could not save new expense", nil)
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                          otherButtonTitles:nil] show];
    }

    switch ( _navigationStyle )
    {
        case KSHNavigationControllerStyle:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case KSHModalPresentationStyle:
            [self dismissViewControllerAnimated:YES
                                     completion:nil];
            break;
    }
}

@end