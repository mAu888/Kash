/**
* Created by Maurício Hanika on 09.08.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHExpensesViewController.h"
#import "KSHAddExpenseViewController.h"
#import "KSHDataAccessLayer.h"
#import "KSHExpense.h"
#import "KSHNumberFormatter.h"
#import "UIColor+Colours.h"
#import "KSHBadgeCell.h"
#import "KSHBadgeCell+KSHCellConfiguration.h"
#import "KSHExpenseViewController.h"
#import "KSHDropOutTransition.h"
#import "KSHNavigationController.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHExpensesViewController () <NSFetchedResultsControllerDelegate, UIViewControllerTransitioningDelegate>

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHExpensesViewController
{
    KSHDataAccessLayer *_dataAccessLayer;
    NSFetchedResultsController *_controller;
}

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer
{
    self = [super initWithStyle:UITableViewStyleGrouped];

    if ( self != nil )
    {
        _dataAccessLayer = dataAccessLayer;

        self.title = NSLocalizedString(@"Expenses", nil);

        // Tab bar -------------------------------------------------------------
        self.tabBarItem.title = NSLocalizedString(@"Expenses", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"expense"];

        // Navigation item -----------------------------------------------------
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        self.navigationItem.rightBarButtonItem =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                          target:self
                                                          action:@selector(presentAddExpenseView:)];

        // Data model ----------------------------------------------------------
        _controller = [_dataAccessLayer fetchedResultsControllerForClass:[KSHExpense class]
                                                         sortDescriptors:@[
                                                             [NSSortDescriptor sortDescriptorWithKey:@"date"
                                                                                           ascending:NO]
                                                         ]
                                                      sectionNameKeyPath:@"sectionIdentifier"
                                                               cacheName:nil
                                                                delegate:self];
    }

    return self;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = _controller.sections[( NSUInteger ) section];
    return sectionInfo.numberOfObjects;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _controller.sections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"BadgeCellIdentifier";

    KSHBadgeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( cell == nil )
    {
        cell = [[KSHBadgeCell alloc] initWithReuseIdentifier:reuseIdentifier];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    KSHExpense *expense = [_controller objectAtIndexPath:indexPath];
    [cell setExpense:expense];

    return cell;
}

- (NSString *)titleForHeaderInSection:(NSInteger)section
{
    if ( _controller.sections.count > 0 )
    {
        NSString *title = [_controller.sections[( NSUInteger ) section] name];
        return title;
    }

    return nil;
}

- (NSString *)titleForFooterInSection:(NSInteger)section
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = [self titleForHeaderInSection:section];
    return [self tableHeaderFooterViewWithTitle:title];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSString *title = [self titleForFooterInSection:section];
    return [self tableHeaderFooterViewWithTitle:title];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KSHExpenseViewController *controller =
        [[KSHExpenseViewController alloc]
            initWithDataAccessLayer:_dataAccessLayer expense:[_controller objectAtIndexPath:indexPath]];

    [self.navigationController pushViewController:controller animated:YES];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ( _controller.sections.count > 0 )
    {
        return 28.f;
    }

    return .0f;
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
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch ( type )
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
#warning Act on section move
            NSLog(@"Move :(");
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
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
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];

            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:( NSUInteger ) indexPath.section]
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
    navigationController.modalPresentationStyle = UIModalPresentationCustom;
    navigationController.transitioningDelegate = ( KSHNavigationController * ) self.navigationController;

    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

@end