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
#import "KSHChartView.h"
#import "KSHExpenseItem.h"
#import "KSHSubtitleView.h"
#import "KSHDateFormatterFactory.h"

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
    self = [super init];

    if ( self )
    {
        _expense = expense;
        _dataAccessLayer = dataAccessLayer;

        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id returnedCell = nil;
    if ( indexPath.row == 0 )
    {
        static NSString *reuseIdentifier = @"KSHExpenseCell";

        KSHExpenseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if ( cell == nil )
        {
            cell = [[KSHExpenseCell alloc] initWithReuseIdentifier:reuseIdentifier];
        }

        [cell setExpense:_expense];
        returnedCell = cell;
    }
    else if ( indexPath.row == 1 )
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
    if ( indexPath.row == 1 )
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