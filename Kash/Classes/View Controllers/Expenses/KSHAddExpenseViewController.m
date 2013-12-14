/**
* Created by Maurício Hanika on 09.08.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHAddExpenseViewController.h"
#import "KSHLabelAndTextFieldCell.h"
#import "KSHDataAccessLayer.h"
#import "KSHAccount.h"
#import "KSHExpense.h"
#import "KSHInputCellDelegate.h"
#import "enums.h"
#import "KSHAccountsViewController.h"
#import "KSHAddExpenseItemViewController.h"
#import "KSHExpenseItem.h"
#import "KSHNumberFormatter.h"
#import "KSHLabelAndTextFieldCell+Formatting.h"
#import "UITableViewCell+Formatting.h"
#import "KSHDatePickerCell.h"

NS_ENUM(NSInteger, KSHAddExpenseDescriptionRows)
{
    KSHAddExpenseTitleRow,
    KSHAddExpenseTotalAmountRow,
    numberOfRowsInDescriptionSection
};

////////////////////////////////////////////////////////////////////////////////
@interface KSHAddExpenseViewController () <KSHInputCellDelegate, KSHAccountsControllerDelegate, KSHAddExpenseItemControllerDelegate, KSHDatePickerCellDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHAddExpenseViewController
{
    NSManagedObjectContext *_context;
    KSHDataAccessLayer *_dataAccessLayer;
    KSHExpense *_expense;

    BOOL _deleteButtonHidden;
    BOOL _shouldShowDatePickerCell;
}

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer
{
    self = [self initWithDataAccessLayer:dataAccessLayer expense:nil];

    if ( self != nil )
    {
        self.title = NSLocalizedString(@"Add expense", nil);

        // Data source ---------------------------------------------------------
        _expense = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([KSHExpense class])
                                                 inManagedObjectContext:_context];
        _expense.date = [NSDate date];
    }

    return self;
}

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer expense:(KSHExpense *)expense
{
    self = [super initWithStyle:UITableViewStyleGrouped];

    if ( self != nil )
    {
        self.title = NSLocalizedString(@"Update expense", nil);

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

        _deleteButtonHidden = YES;
        if ( expense != nil )
        {
            _expense = ( KSHExpense * ) [_context objectWithID:expense.objectID];
            _deleteButtonHidden = NO;
        }
    }

    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Notifications -------------------------------------------------------
    [[NSNotificationCenter defaultCenter]
        addObserver:self.tableView
           selector:@selector(reloadData)
               name:NSCurrentLocaleDidChangeNotification
             object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]
        removeObserver:self.tableView name:NSCurrentLocaleDidChangeNotification object:nil];
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _deleteButtonHidden ? 4 : 5;
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
        case 3:
            return 1 + (_shouldShowDatePickerCell ? 1 : 0);
        case 4:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnedCell = nil;

    if ( indexPath.section == 0 )
    {
        static NSString *reuseIdentifier = @"TextFieldCellIdentifier";

        KSHLabelAndTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if ( cell == nil )
        {
            cell = [[KSHLabelAndTextFieldCell alloc] initWithReuseIdentifier:reuseIdentifier];
            cell.delegate = self;
        }

        if ( indexPath.row == KSHAddExpenseTitleRow )
        {
            cell.textLabel.text = NSLocalizedString(@"For what?", nil);
            cell.textField.text = _expense.title;
            cell.textFieldType = KSHDefaultTextField;
            cell.textField.enabled = YES;
        }
        else if ( indexPath.row == KSHAddExpenseTotalAmountRow )
        {
            cell.textLabel.text = NSLocalizedString(@"How much?", nil);
            [cell setCurrencyValue:_expense.totalAmount];
            cell.textFieldType = KSHCurrencyTextField;

            cell.textField.enabled = _expense.items.count == 0;
        }

        returnedCell = cell;
    }

    else if ( indexPath.section == 1 )
    {
        static NSString *reuseIdentifier = @"UITableViewCellStyleValue1";

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if ( cell == nil )
        {
            cell = [[KSHTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        }

        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        [cell setAccount:_expense.account];

        returnedCell = cell;
    }

    else if ( indexPath.section == 2 )
    {
        UITableViewCell *cell = nil;

        if ( indexPath.row == _expense.items.count )
        {
            static NSString *reuseIdentifier = @"UITableViewCellStyleDefault";

            cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if ( cell == nil )
            {
                cell = [[KSHTableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }

            cell.textLabel.text = NSLocalizedString(@"Add item", nil);
        }
        else if ( indexPath.row < _expense.items.count )
        {
            static NSString *reuseIdentifier = @"UITableViewCellStyleValue1";

            cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if ( cell == nil )
            {
                cell = [[KSHTableViewCell alloc]
                    initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setExpenseItem:_expense.items[indexPath.row]];
        }

        returnedCell = cell;
    }
    else if ( indexPath.section == 3 )
    {
        if ( indexPath.row == 0 )
        {
            static NSString *reuseIdentifier = @"UITableViewCellStyleValue1";

            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if ( cell == nil )
            {
                cell = [[KSHTableViewCell alloc]
                    initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
            }

            [cell setDate:_expense.date];

            returnedCell = cell;
        }
        else if ( indexPath.row == 1 )
        {
            static NSString *reuseIdentifier = @"KSHDatePickerCellIdentifier";

            KSHDatePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if ( cell == nil)
            {
                cell = [[KSHDatePickerCell alloc] initWithReuseIdentifier:reuseIdentifier];
                cell.delegate = self;
            }

            cell.date = _expense.date;

            returnedCell = cell;
        }
    }
    else if ( indexPath.section == 4 )
    {
        if ( indexPath.row == 0 )
        {
            static NSString *reuseIdentifier = @"UITableViewCellStyleDefault";

            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if ( cell == nil )
            {
                cell = [[KSHTableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
            }

            [cell displaysDeleteButtonWithTitle:NSLocalizedString(@"Delete Expense", nil)];

            returnedCell = cell;
        }
    }

    return returnedCell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 2 && indexPath.row < _expense.items.count;
}

- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( editingStyle == UITableViewCellEditingStyleDelete )
    {
        KSHExpenseItem *item = [_expense.items objectAtIndex:( NSUInteger ) indexPath.row];
        _expense.totalAmount = @(round((_expense.totalAmount.doubleValue - item.amount.doubleValue) * 100.f) / 100.f);

        [[_expense mutableOrderedSetValueForKey:@"items"] removeObjectAtIndex:( NSUInteger ) indexPath.row];
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndex:0];
        [indexSet addIndex:2];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ( section == 2 )
    {
        return NSLocalizedString(@"Split", nil);
    }
    else if ( section == 3 )
    {
        return NSLocalizedString(@"Value date", nil);
    }

    return nil;
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if ( section == 2 && _expense.items.count > 0 )
    {
        NSNumberFormatter *formatter = [KSHNumberFormatter sharedInstance].currencyNumberFormatter;

        NSNumber *sum = [_expense.items valueForKeyPath:@"@sum.amount"];
        return [NSString stringWithFormat:NSLocalizedString(@"Total cost is %@", nil),
                                          [formatter stringFromNumber:sum]];
    }

    return nil;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ( indexPath.section == 1 )
    {
        KSHAccountsViewController *controller =
            [[KSHAccountsViewController alloc]
                initWithDataAccessLayer:_dataAccessLayer selectedAccount:_expense.account];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }

    else if ( indexPath.section == 2 && indexPath.row < _expense.items.count )
    {
        KSHAddExpenseItemViewController *controller =
            [[KSHAddExpenseItemViewController alloc]
                initWithDataAccessLayer:_dataAccessLayer
                                context:[_dataAccessLayer contextWithParentContext:_context]
                            expenseItem:_expense.items[( NSUInteger ) indexPath.row]];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }

    else if ( indexPath.section == 2 && indexPath.row == _expense.items.count )
    {
        KSHAddExpenseItemViewController *controller =
            [[KSHAddExpenseItemViewController alloc] initWithDataAccessLayer:_dataAccessLayer
                                                                     context:[_dataAccessLayer contextWithParentContext:_context]
                                                                     expense:_expense];
        controller.delegate = self;

        [self.navigationController pushViewController:controller animated:YES];
    }

    else if ( indexPath.section == 3 && indexPath.row == 0 )
    {
        _shouldShowDatePickerCell = !_shouldShowDatePickerCell;

        NSIndexPath *datePickerIndexPath = [NSIndexPath indexPathForRow:1 inSection:3];

        [self.tableView beginUpdates];
        if ( _shouldShowDatePickerCell )
        {
            [self.tableView insertRowsAtIndexPaths:@[datePickerIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            [self.tableView deleteRowsAtIndexPaths:@[datePickerIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
        }

        // Reload the date cell too, to fix the broken separator
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]]
                              withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];

        if ( _shouldShowDatePickerCell )
        {
            [self.tableView scrollToRowAtIndexPath:datePickerIndexPath
                                  atScrollPosition:UITableViewScrollPositionBottom
                                          animated:YES];
        }
    }

    else if ( indexPath.section == 4 && indexPath.row == 0 )
    {
        [self confirmExpenseRemoval];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ( section == 2 && _expense.items.count > 0 )
    {
        return 30.f;
    }

    return .0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 3 && indexPath.row == 1 )
    {
        return 216.f;
    }

    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == actionSheet.destructiveButtonIndex )
    {
        [_context deleteObject:_expense];
        [self save:nil];
    }
}


#pragma mark - KSHInputCellDelegate

- (void)cellDidChangeValue:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cell.center];
    if ( indexPath.section == 0 && indexPath.row == KSHAddExpenseTitleRow )
    {
        _expense.title = (( KSHLabelAndTextFieldCell * ) cell).textField.text;
    }
    else if ( indexPath.section == 0 && indexPath.row == KSHAddExpenseTotalAmountRow )
    {
        _expense.totalAmount = (( KSHLabelAndTextFieldCell * ) cell).numericValue;
    }
}


#pragma mark - KSHAccountsControllerDelegate

- (void)controller:(KSHAccountsViewController *)controller didSelectAccount:(KSHAccount *)account
{
    _expense.account = ( KSHAccount * ) [_context objectWithID:account.objectID];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];

    [controller.navigationController popViewControllerAnimated:YES];
}


#pragma mark - KSHAddExpenseItemControllerDelegate

- (void)controllerDidSaveExpenseItem:(KSHAddExpenseItemViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];

    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndex:0];
    [indexSet addIndex:2];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - KSHDatePickerCellDelegate

- (void)datePickerCellDidChangeToDate:(NSDate *)date
{
    _expense.date = date;

    [self.tableView reloadRowsAtIndexPaths:@[
        [NSIndexPath indexPathForRow:0
                           inSection:3]
    ]
                          withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - Private methods

- (void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmExpenseRemoval
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
        initWithTitle:NSLocalizedString(@"The expense will be permanently removed. Do you want to continue?", nil)
             delegate:self
     cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
destructiveButtonTitle:NSLocalizedString(@"Delete Expense", nil)
     otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

@end