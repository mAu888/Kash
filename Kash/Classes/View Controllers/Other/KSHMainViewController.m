/**
* Created by Maurício Hanika on 09.08.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHMainViewController.h"
#import "KSHExpensesViewController.h"
#import "KSHAccountsViewController.h"
#import "KSHDataAccessLayer.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHMainViewController ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHMainViewController
{

}

- (id)init
{
    self = [super init];

    if ( self != nil )
    {
        KSHDataAccessLayer *dataAccessLayer = [[KSHDataAccessLayer alloc] init];

        KSHExpensesViewController *expensesViewController =
                [[KSHExpensesViewController alloc] initWithDataAccessLayer:dataAccessLayer];
        UINavigationController *expensesNavigationController =
                [[UINavigationController alloc] initWithRootViewController:expensesViewController];

        KSHAccountsViewController *accountsViewController =
                [[KSHAccountsViewController alloc] initWithDataAccessLayer:dataAccessLayer];
        UINavigationController *accountsNavigationController =
                [[UINavigationController alloc] initWithRootViewController:accountsViewController];

        self.viewControllers = @[expensesNavigationController, accountsNavigationController];
    }

    return self;
}


@end