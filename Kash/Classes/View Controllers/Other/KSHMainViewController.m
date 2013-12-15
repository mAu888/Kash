/**
* Created by Maurício Hanika on 09.08.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHMainViewController.h"
#import "KSHExpensesViewController.h"
#import "KSHAccountsViewController.h"
#import "KSHDataAccessLayer.h"
#import "KSHNavigationController.h"
#import "KSHChartsViewController.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHMainViewController ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHMainViewController

- (id)init
{
    self = [super init];

    if ( self != nil )
    {
        KSHDataAccessLayer *dataAccessLayer = [[KSHDataAccessLayer alloc] init];

        KSHExpensesViewController *expensesViewController =
            [[KSHExpensesViewController alloc] initWithDataAccessLayer:dataAccessLayer];
        KSHNavigationController *expensesNavigationController =
            [[KSHNavigationController alloc] initWithRootViewController:expensesViewController];

        KSHAccountsViewController *accountsViewController =
            [[KSHAccountsViewController alloc] initWithDataAccessLayer:dataAccessLayer];
        KSHNavigationController *accountsNavigationController =
            [[KSHNavigationController alloc] initWithRootViewController:accountsViewController];

        KSHChartsViewController *chartsViewController =
            [[KSHChartsViewController alloc] initWithDataAccessLayer:dataAccessLayer];
        KSHNavigationController *chartsNavigationController =
            [[KSHNavigationController alloc] initWithRootViewController:chartsViewController];


        self.viewControllers = @[
            expensesNavigationController,
            accountsNavigationController,
            chartsNavigationController
        ];

        self.customizableViewControllers = @[
            chartsNavigationController
        ];
    }

    return self;
}


@end