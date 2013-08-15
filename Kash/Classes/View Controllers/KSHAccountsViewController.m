/**
* Created by Maurício Hanika on 09.08.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <CoreData/CoreData.h>
#import "KSHAccountsViewController.h"
#import "KSHAddAccountViewController.h"
#import "KSHDataAccessLayer.h"
#import "KSHAccount.h"
#import "KSHAddExpenseViewController.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHAccountsViewController () <NSFetchedResultsControllerDelegate>

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHAccountsViewController
{

    KSHDataAccessLayer *_dataAccessLayer;
    NSFetchedResultsController *_controller;
    KSHAccount *_selectedAccount;
}

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer
{
    self = [super init];

    if ( self != nil )
    {
        _dataAccessLayer = dataAccessLayer;

        // Data store ----------------------------------------------------------
        _controller = [_dataAccessLayer fetchedResultsControllerForClass:[KSHAccount class]
                                                                 sortKey:@"name"
                                                                delegate:self];

        // Tab bar -------------------------------------------------------------
        self.title = NSLocalizedString(@"Accounts", nil);
        self.tabBarItem.title = NSLocalizedString(@"Accounts", nil);

        // Navigation item -----------------------------------------------------
        self.navigationItem.rightBarButtonItem =
                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                              target:self
                                                              action:@selector(presentAddAccountView:)];
    }

    return self;
}

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer selectedAccount:(KSHAccount *)account
{
    self = [self initWithDataAccessLayer:dataAccessLayer];

    if ( self != nil)
    {
        if ( account != nil )
        {
            if ( ![_dataAccessLayer objectInMainContext:account] )
            {
                account = ( KSHAccount * ) [_dataAccessLayer objectTransferredToMainContext:account];
            }

            _selectedAccount = account;
        }

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
    return _controller.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"CellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:reuseIdentifier];
    }

    KSHAccount *account = [_controller objectAtIndexPath:indexPath];
    cell.textLabel.text = account.name;
    cell.accessoryType = [account isEqual:_selectedAccount] ?
            UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    return cell;
}


#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _delegate == nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( _delegate != nil && [_delegate respondsToSelector:@selector(controller:didSelectAccount:)] )
    {
        [_delegate controller:self
             didSelectAccount:[_controller objectAtIndexPath:indexPath]];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( editingStyle == UITableViewCellEditingStyleDelete )
    {
        [_dataAccessLayer deleteObject:[_controller objectAtIndexPath:indexPath]];
    }
}



#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch ( type )
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath
                                   toIndexPath:newIndexPath];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}


#pragma mark - Private methods

- (void)presentAddAccountView:(id)sender
{
    KSHAddAccountViewController *controller =
            [[KSHAddAccountViewController alloc] initWithDataAccessLayer:_dataAccessLayer];
    UINavigationController *navigationController =
            [[UINavigationController alloc] initWithRootViewController:controller];

    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
}

@end