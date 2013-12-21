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
#import "KSHExpense.h"

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

        #ifdef DEBUG
//        [self insertRandomEntriesWithDataAccessLayer:dataAccessLayer count:3650];
        #endif
    }

    return self;
}

#ifdef DEBUG
- (int)randomIntWithLowerBoundary:(int)smallNumber upperBoundary:(int)bigNumber
{
    int d = bigNumber - smallNumber;
    return ( int ) (floorf(((( float ) (arc4random() % (( unsigned ) RAND_MAX + 1)) / RAND_MAX) * d)) + smallNumber);
}

- (float)randomFloatWithLowerBoundary:(float)smallNumber upperBoundary:(float)bigNumber
{
    float d = bigNumber - smallNumber;
    return ((( float ) (arc4random() % (( unsigned ) RAND_MAX + 1)) / RAND_MAX) * d) + smallNumber;
}

- (void)insertRandomEntriesWithDataAccessLayer:(KSHDataAccessLayer *)layer count:(int)number
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSCalendarUnit units = NSTimeZoneCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSYearCalendarUnit;

    NSDateComponents *todayComponents = [gregorian components:units fromDate:[NSDate date]];
    NSInteger theYear = [todayComponents year];

// now build a NSDate object for the input date using these components
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

    NSManagedObjectContext *context = layer.contextForEditing;

    NSArray *titles = @[
        @"Essen", @"Bier", @"Trinken", @"VVS", @"DB Fra - HH", @"Bioladen", @"Döner", @"Geschenke", @"HVV", @"RMV", @"E-Plus"
    ];

    for (int i = 0; i < number; i++)
    {
        [components setWeekday:[self randomIntWithLowerBoundary:1 upperBoundary:7]];
        [components setWeek:[self randomIntWithLowerBoundary:1 upperBoundary:52]];
        [components setYear:theYear];
        [components setHour:[self randomIntWithLowerBoundary:6 upperBoundary:22]];
        [components setMinute:[self randomIntWithLowerBoundary:1 upperBoundary:59]];
        [components setSecond:[self randomIntWithLowerBoundary:1 upperBoundary:59]];

        NSDate *date = [gregorian dateFromComponents:components];

        KSHExpense *expense = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([KSHExpense class])
                                                            inManagedObjectContext:context];
        expense.title = titles[( NSUInteger ) [self randomIntWithLowerBoundary:0 upperBoundary:(titles.count - 1)]];
        expense.totalAmount = @([self randomFloatWithLowerBoundary:2.f upperBoundary:47.f]);
        expense.date = date;
        [context insertObject:expense];
    }

    [layer saveContext:context];
}
#endif

@end