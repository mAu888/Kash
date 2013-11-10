/**
* Created by Maurício Hanika on 10.11.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "KSHChartView.h"

@interface KSHChartCell : UITableViewCell

- (id)initWithChartType:(KSHChartType)chartType reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setItems:(NSArray *)items;

@end