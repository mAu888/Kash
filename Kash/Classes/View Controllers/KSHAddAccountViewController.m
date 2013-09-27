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

////////////////////////////////////////////////////////////////////////////////
@interface KSHAddAccountViewController () <KSHInputCellDelegate>

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
    self = [super initWithStyle:UITableViewStyleGrouped];

    if ( self != nil )
    {
        _dataAccessLayer = dataAccessLayer;
        _context = [_dataAccessLayer contextForEditing];

        _account = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([KSHAccount class])
                                                 inManagedObjectContext:_context];

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


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"CellIdentifier";

    KSHLabelAndTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( cell == nil )
    {
        cell = [[KSHLabelAndTextFieldCell alloc] initWithReuseIdentifier:reuseIdentifier];
        cell.delegate = self;
    }

    cell.textLabel.text = NSLocalizedString(@"Account", nil);

    return cell;
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
                                    message:NSLocalizedString(@"Could not save new account", nil)
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                          otherButtonTitles:nil] show];
    }

    [self dismissViewControllerAnimated:YES
          completion:nil];
}


#pragma mark - KSHInputCellDelegate

- (void)cellDidChangeValue:(UITableViewCell *)cell
{
    _account.name = (( KSHLabelAndTextFieldCell *)cell).textField.text;
}

@end