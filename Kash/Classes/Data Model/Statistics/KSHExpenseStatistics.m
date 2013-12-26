/**
* Created by Maurício Hanika on 21.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHExpenseStatistics.h"
#import "KSHDataAccessLayer.h"
#import "KSHExpense.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHExpenseStatistics ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHExpenseStatistics
{
    KSHDataAccessLayer *_dataAccessLayer;
}

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer
{
    self = [super init];

    if ( self != nil )
    {
        _dataAccessLayer = dataAccessLayer;
    }

    return self;
}

- (NSNumber *)expensesFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date < %@ && date > %@", toDate, fromDate];

    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"totalAmount"];
    NSExpression *sumOfCountExpression = [NSExpression expressionForFunction:@"sum:"
                                                                   arguments:[NSArray arrayWithObject:keyPathExpression]];

    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    expressionDescription.name = @"totalAmountSum";
    expressionDescription.expression = sumOfCountExpression;
    expressionDescription.expressionResultType = NSDecimalAttributeType;

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([KSHExpense class])
                                              inManagedObjectContext:_dataAccessLayer.mainManagedObjectContext];
    request.entity = entity;
    request.resultType = NSDictionaryResultType;
    request.predicate = predicate;
    request.propertiesToFetch = @[expressionDescription];

    NSError *error = nil;
    NSArray *objects = [_dataAccessLayer.mainManagedObjectContext executeFetchRequest:request error:&error];
    if ( objects == nil )
    {
        NSLog(@"An error occured during fetching summarized expenses: %@", error);
    }
    else if ( [objects count] > 0 )
    {
        return [objects firstObject][@"totalAmountSum"];
    }

    return nil;
}

- (NSArray *)weeklyExpensesFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSCalendarUnit units = NSTimeZoneCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSYearCalendarUnit;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *endDateComponents = [gregorian components:units fromDate:fromDate];
    endDateComponents.weekday = 7;
    endDateComponents.hour = 23;
    endDateComponents.minute = 59;
    endDateComponents.second = 59;

    NSMutableArray *result = [NSMutableArray array];
    NSNumber *weeks = [self weeksBetweenStartDate:fromDate endDate:toDate];
    for (int i = 0, j = [weeks intValue]; i <= j; i++ )
    {
        toDate = [gregorian dateFromComponents:endDateComponents];

        NSNumber *amountSpend = [self expensesFromDate:fromDate toDate:toDate];
        [result addObject:amountSpend];

        endDateComponents.week += 1;
        fromDate = [toDate dateByAddingTimeInterval:1];
    }

    return [NSArray arrayWithArray:result];
}

#pragma mark - Private methods

- (NSNumber *)weeksBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *componentsInBetween = [gregorian components:NSWeekCalendarUnit
                                                         fromDate:startDate
                                                           toDate:endDate
                                                          options:0];

    return @(componentsInBetween.week);
}


@end