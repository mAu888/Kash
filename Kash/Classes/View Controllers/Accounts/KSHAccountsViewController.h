/**
* Created by Maurício Hanika on 09.08.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHTableViewController.h"

@class KSHDataAccessLayer;
@class KSHAccount;
@class KSHAddExpenseViewController;
@class KSHAccountsViewController;

@protocol KSHAccountsControllerDelegate <NSObject>

@optional
- (void)controller:(KSHAccountsViewController *)controller didSelectAccount:(KSHAccount *)account;

@end


////////////////////////////////////////////////////////////////////////////////
@interface KSHAccountsViewController : KSHTableViewController

@property(nonatomic, weak) id<KSHAccountsControllerDelegate> delegate;

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer;

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer selectedAccount:(KSHAccount *)account;

@end