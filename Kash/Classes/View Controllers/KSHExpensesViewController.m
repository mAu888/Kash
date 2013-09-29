/**
* Created by Maurício Hanika on 09.08.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHExpensesViewController.h"
#import "KSHAddExpenseViewController.h"
#import "KSHDataAccessLayer.h"
#import "KSHExpense.h"
#import "KSHNumberFormatter.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHExpensesViewController () <NSFetchedResultsControllerDelegate>

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHExpensesViewController
{

    KSHDataAccessLayer *_dataAccessLayer;
    NSFetchedResultsController *_controller;
}

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer
{
    self = [super init];

    if ( self != nil )
    {
        _dataAccessLayer = dataAccessLayer;

        self.title = NSLocalizedString(@"Expenses", nil);

        // Tab bar -------------------------------------------------------------
        self.tabBarItem.title = NSLocalizedString(@"Expenses", nil);

        // Navigation item -----------------------------------------------------
        self.navigationItem.rightBarButtonItem =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                          target:self
                                                          action:@selector(presentAddExpenseView:)];

        // Data model ----------------------------------------------------------
        _controller = [_dataAccessLayer fetchedResultsControllerForClass:[KSHExpense class]
                                                                 sortKey:@"date"
                                                      sectionNameKeyPath:@"sectionIdentifier"
                                                               cacheName:@"KSHExpensesViewControllerCache"
                                                                delegate:self];
    }

    return self;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _controller.fetchedObjects.count;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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

    KSHExpense *expense = [_controller objectAtIndexPath:indexPath];
    cell.textLabel.text = expense.title;

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ( _controller.sections.count > 0 )
    {
        NSString *title = [_controller.sections[( NSUInteger ) section] name];
        return title;
    }

    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if ( _controller.sections.count > 0 )
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = _controller.sections[( NSUInteger ) section];

        NSNumber *sum = [sectionInfo.objects valueForKeyPath:@"@sum.totalAmount"];
        NSNumberFormatter *numberFormatter = [KSHNumberFormatter sharedInstance].currencyNumberFormatter;

        return [numberFormatter stringFromNumber:sum];
    }
    else
    {
        return nil;
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KSHAddExpenseViewController *controller =
        [[KSHAddExpenseViewController alloc] initWithDataAccessLayer:_dataAccessLayer
                                                             expense:[_controller objectAtIndexPath:indexPath]];

    [self.navigationController pushViewController:controller
                                         animated:YES];
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

- (NSString *)       controller:(NSFetchedResultsController *)controller
sectionIndexTitleForSectionName:(NSString *)sectionName
{
    return sectionName;
}


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

- (void)presentAddExpenseView:(id)sender
{
    KSHAddExpenseViewController *controller =
        [[KSHAddExpenseViewController alloc] initWithDataAccessLayer:_dataAccessLayer];
    UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:controller];

    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
}

@end