/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHExpenseViewController.h"
#import "KSHExpense.h"
#import "KSHExpenseCell.h"
#import "KSHChartCell.h"
#import "KSHAddExpenseViewController.h"
#import "KSHDataAccessLayer.h"
#import "KSHExpenseItem.h"
#import "KSHSubtitleView.h"
#import "KSHDateFormatterFactory.h"
#import "KSHBadgeCell.h"
#import "KSHBadgeCell+KSHCellConfiguration.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHExpenseViewController ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHExpenseViewController
{
    KSHExpense *_expense;
    KSHDataAccessLayer *_dataAccessLayer;
}

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer expense:(KSHExpense *)expense
{
    self = [super initWithStyle:UITableViewStyleGrouped];

    if ( self )
    {
        _expense = expense;
        _dataAccessLayer = dataAccessLayer;

        // Navigation items
        self.navigationItem.rightBarButtonItems = @[
            [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                     target:self
                                     action:@selector(editExpense:)]
        ];
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // After editing the date may have changed, thus we apply the title view before appearing and not in init
    NSDateFormatter *formatter = [[KSHDateFormatterFactory sharedInstance]
        dateFormatterWithDateStyle:NSDateFormatterMediumStyle
                         timeStyle:NSDateFormatterShortStyle];
    KSHSubtitleView *titleView = [[KSHSubtitleView alloc] init];
    titleView.textLabel.text = _expense.title;
    titleView.detailTextLabel.text = [formatter stringFromDate:_expense.date];

    self.navigationItem.titleView = titleView;

    // Reload possible changes after editing
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ( _expense.isDeleted )
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 1 )
    {
        return 1;
    }
    else if ( _expense.items.count > 0 )
    {
        return _expense.items.count;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id returnedCell = nil;
    if ( indexPath.section == 0 )
    {
        static NSString *reuseIdentifier = @"KSHBadgeCell";

        KSHBadgeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if ( cell == nil )
        {
            cell = [[KSHBadgeCell alloc] initWithReuseIdentifier:reuseIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        if ( _expense.items.count > 0 )
        {
            [cell setExpenseItem:_expense.items[( NSUInteger ) indexPath.row]];
        }
        else
        {
            [cell setExpense:_expense];
        }

        returnedCell = cell;
    }
    else if ( indexPath.section == 1 )
    {
        static NSString *reuseIdentifier = @"KSHChartCell";

        KSHChartCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if ( cell == nil )
        {
            cell = [[KSHChartCell alloc]
                initWithChartType:KSHPieChartType reuseIdentifier:reuseIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        NSMutableArray *values = [NSMutableArray arrayWithCapacity:_expense.items.count];
        [_expense.items enumerateObjectsUsingBlock:^(KSHExpenseItem *item, NSUInteger index, BOOL *stop)
        {
            [values addObject:item.amount];
        }];

        [cell setItems:values];

        returnedCell = cell;
    }

    return returnedCell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 1 )
    {
        return CGRectGetWidth(self.view.bounds);
    }

    return 44.f;
}


#pragma mark - Private methods

- (void)editExpense:(UIBarButtonItem *)sender
{
    KSHAddExpenseViewController *controller = [[KSHAddExpenseViewController alloc]
        initWithDataAccessLayer:_dataAccessLayer expense:_expense];

    UINavigationController *navigationController = [[UINavigationController alloc]
        initWithRootViewController:controller];

    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

@end