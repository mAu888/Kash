/**
* Created by Maurício Hanika on 09.08.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "KSHTableViewController.h"

@class KSHDataAccessLayer;
@class KSHAccount;

@interface KSHAddAccountViewController : KSHTableViewController

@property(nonatomic, strong) KSHAccount *account;
- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer;

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer account:(KSHAccount *)account;
@end