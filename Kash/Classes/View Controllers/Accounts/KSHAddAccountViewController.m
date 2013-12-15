/**
* Created by Maurício Hanika on 09.08.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <CoreData/CoreData.h>
#import "KSHAddAccountViewController.h"
#import "KSHInputCellDelegate.h"
#import "KSHLabelAndTextFieldCell.h"
#import "KSHDataAccessLayer.h"
#import "KSHAccount.h"
#import "KSHColorPickerViewController.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHAddAccountViewController () <KSHInputCellDelegate, KSHColorPickerViewControllerDelegate>

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHAddAccountViewController
{
    KSHDataAccessLayer *_dataAccessLayer;
    NSManagedObjectContext *_context;
    KSHAccount *_account;
}

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer
{
    return [self initWithDataAccessLayer:dataAccessLayer account:nil];
}

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer account:(KSHAccount *)account
{
    self = [super initWithStyle:UITableViewStyleGrouped];

    if ( self != nil )
    {
        _dataAccessLayer = dataAccessLayer;
        _context = [_dataAccessLayer contextForEditing];

        if ( account == nil )
        {
            _account = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([KSHAccount class])
                                                     inManagedObjectContext:_context];
            self.title = NSLocalizedString(@"Add new account", nil);
        }
        else
        {
            _account = ( KSHAccount * ) [_context objectWithID:account.objectID];
            self.title = _account.name;
        }

        // Navigation item -----------------------------------------------------
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

    if ( self.presentingViewController != nil )
    {
        self.navigationItem.leftBarButtonItem =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                          target:self
                                                          action:@selector(cancel:)];
    }
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnedCell = nil;
    if ( indexPath.section == 0 )
    {
        static NSString *reuseIdentifier = @"KSHLabelAndTextFieldCell";

        KSHLabelAndTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if ( cell == nil )
        {
            cell = [[KSHLabelAndTextFieldCell alloc] initWithReuseIdentifier:reuseIdentifier];
            cell.delegate = self;
        }

        cell.textLabel.text = NSLocalizedString(@"Account", nil);
        cell.textField.text = _account.name;

        returnedCell = cell;
    }
    else if ( indexPath.section == 1 )
    {
        static NSString *reuseIdentifier = @"UITableViewCellStyleValue1";

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if ( cell == nil )
        {
            cell = [[KSHTableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        }

        cell.textLabel.text = NSLocalizedString(@"Key color", nil);
        if ( _account.color == nil)
        {
            cell.detailTextLabel.textColor = [UIColor lightTextColor];
            cell.detailTextLabel.text = NSLocalizedString(@"Choose color", nil);
        }
        else
        {
            cell.detailTextLabel.textColor = _account.color;
            cell.detailTextLabel.text = NSLocalizedString(@"Chosen color", nil);
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        returnedCell = cell;
    }

    return returnedCell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 1 && indexPath.row == 0 )
    {
        KSHColorPickerViewController *controller = [[KSHColorPickerViewController alloc] init];
        controller.delegate = self;

        [self.navigationController pushViewController:controller
                                             animated:YES];
    }
}



#pragma mark - Private methods

- (void)cancel:(id)sender
{
    [self dismissOrPopViewControllerAllowDropping:YES];
}

- (void)save:(id)sender
{
    [self.view endEditing:YES];

    if ( ![_dataAccessLayer saveContext:_context] )
    {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:NSLocalizedString(@"Could not save new account", nil)
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                          otherButtonTitles:nil] show];
    }

    [self dismissOrPopViewControllerAllowDropping:NO];
}

- (void)dismissOrPopViewControllerAllowDropping:(BOOL)dropping
{
    if ( self.presentingViewController != nil )
    {
        if ( !dropping )
        {
            self.navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
            self.navigationController.transitioningDelegate = nil;
        }

        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - KSHInputCellDelegate

- (void)cellDidChangeValue:(UITableViewCell *)cell
{
    _account.name = (( KSHLabelAndTextFieldCell * ) cell).textField.text;
}


#pragma mark - KSHColorPickerViewControllerDelegate

- (void)colorPickerControllerDidSelectColor:(UIColor *)color
{
    _account.color = color;

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    [self.navigationController popViewControllerAnimated:YES];
}


@end