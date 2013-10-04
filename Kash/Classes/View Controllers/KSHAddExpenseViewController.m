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
@interface KSHAddExpenseViewController () <KSHInputCellDelegate, KSHAccountsControllerDelegate, KSHAddExpenseItemControllerDelegate, KSHDatePickerCellDelegate, UIAlertViewDelegate>

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHAddExpenseViewController
{
    KSHDataAccessLayer *_dataAccessLayer;
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
        _expense.date = [NSDate date];
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
        _expense = ( KSHExpense * ) [_context objectWithID:expense.objectID];
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
    return 4;
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
            return 1;
        default:
            break;
    }

    return 0;
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
        }
        else if ( indexPath.row == KSHAddExpenseTotalAmountRow )
        {
            cell.textLabel.text = NSLocalizedString(@"How much?", nil);
            [cell setCurrencyValue:_expense.totalAmount];
            cell.textFieldType = KSHCurrencyTextField;
        }

        returnedCell = cell;
    }

    else if ( indexPath.section == 1 )
    {
        static NSString *reuseIdentifier = @"UITableViewCellStyleValue1";

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if ( cell == nil )
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
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
                cell = [[UITableViewCell alloc]
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
                cell = [[UITableViewCell alloc]
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
        [[_expense mutableOrderedSetValueForKey:@"items"] removeObjectAtIndex:( NSUInteger ) indexPath.row];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2]
                      withRowAnimation:UITableViewRowAnimationAutomatic];
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
//    if ( section == 2 && _expense.items.count > 0 )
//    {
//        NSNumberFormatter *formatter = [KSHNumberFormatter sharedInstance].currencyNumberFormatter;
//
//        NSNumber *sum = [_expense.items valueForKeyPath:@"@sum.amount"];
//        return [NSString stringWithFormat:NSLocalizedString(@"Total cost is %@", nil),
//                                          [formatter stringFromNumber:sum]];
//    }

    return nil;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ( section == 2 && _expense.items.count > 0 )
    {
        return 30.f;
    }

    return .0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ( section == 2 && _expense.items.count > 0 )
    {
        NSNumber *sum = [_expense.items valueForKeyPath:@"@sum.amount"];

        NSNumberFormatter *numberFormatter = [KSHNumberFormatter sharedInstance].currencyNumberFormatter;

        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, CGRectGetWidth(self.view.bounds), 20.f)];
        container.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        UILabel *label = [[UILabel alloc]
            initWithFrame:CGRectMake(15.f, .0f, CGRectGetWidth(self.view.bounds) - 10.f, 20.f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        label.textColor = [UIColor darkGrayColor];
        label.text = [NSString stringWithFormat:NSLocalizedString(@"Total cost is %@", nil),
                                                [numberFormatter stringFromNumber:sum]];
        [container addSubview:label];

        UITapGestureRecognizer *gestureRecognizer =
            [[UITapGestureRecognizer alloc]
                initWithTarget:self action:@selector(shouldUpdateTotalAmountsBySummingItems)];
        [container addGestureRecognizer:gestureRecognizer];

        return container;
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];

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
                                context:_context
                            expenseItem:_expense.items[( NSUInteger ) indexPath.row]];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }

    else if ( indexPath.section == 2 && indexPath.row == _expense.items.count )
    {
        KSHAddExpenseItemViewController *controller =
            [[KSHAddExpenseItemViewController alloc] initWithDataAccessLayer:_dataAccessLayer
                                                                     context:_context
                                                                     expense:_expense];
        controller.delegate = self;

        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 3 && indexPath.row == 0 )
    {
        return 216.f;
    }

    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
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

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - KSHDatePickerCellDelegate

- (void)datePickerCellDidChangeToDate:(NSDate *)date
{
    _expense.date = date;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == alertView.firstOtherButtonIndex )
    {
        _expense.totalAmount = [_expense.items valueForKeyPath:@"@sum.amount"];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - Private methods

- (void)shouldUpdateTotalAmountsBySummingItems
{
    [[[UIAlertView alloc]
        initWithTitle:nil
              message:NSLocalizedString(@"Do you want to update the total amount by summing up the amount of each split item?", nil)
             delegate:self
    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
    otherButtonTitles:NSLocalizedString(@"Yes", nil), nil] show];
}

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

    switch ( _navigationStyle )
    {
        case KSHNavigationControllerStyle:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case KSHModalPresentationStyle:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
    }
}

@end