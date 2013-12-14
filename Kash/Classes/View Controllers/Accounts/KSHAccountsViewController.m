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
#import "KSHAccountCell.h"

NSString *const KSHAccountsViewControllerCacheName = @"KSHAccountsViewControllerCache";

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
                                                         sortDescriptors:@[
                                                             [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                                           ascending:YES]
                                                         ]
                                                      sectionNameKeyPath:nil
                                                               cacheName:nil
                                                                delegate:self];

        // Tab bar -------------------------------------------------------------
        self.title = NSLocalizedString(@"Accounts", nil);
        self.tabBarItem.title = NSLocalizedString(@"Accounts", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"account"];

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
    return _controller.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = _controller.sections[( NSUInteger ) section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"KSHAccountCell";

    KSHAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( cell == nil )
    {
        cell = [[KSHAccountCell alloc] initWithReuseIdentifier:reuseIdentifier];
    }

    KSHAccount *account = [_controller objectAtIndexPath:indexPath];
    [cell setAccount:account];

    if ( _delegate != nil )
    {
        cell.accessoryType = [account isEqual:_selectedAccount] ?
            UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}


#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _delegate == nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ( _delegate != nil && [_delegate respondsToSelector:@selector(controller:didSelectAccount:)] )
    {
        [_delegate controller:self
             didSelectAccount:[_controller objectAtIndexPath:indexPath]];
    }
    else if ( _delegate == nil )
    {
        KSHAddAccountViewController *controller = [[KSHAddAccountViewController alloc]
            initWithDataAccessLayer:_dataAccessLayer account:[_controller objectAtIndexPath:indexPath]];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
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

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
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