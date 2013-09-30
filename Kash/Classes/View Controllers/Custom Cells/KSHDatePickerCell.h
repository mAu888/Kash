/**
* Created by Maurício Hanika on 29.09.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>

@protocol KSHDatePickerCellDelegate <NSObject>

@optional
- (void)datePickerCellDidChangeToDate:(NSDate *)date;

@end

@interface KSHDatePickerCell : UITableViewCell

@property(nonatomic, weak) id <KSHDatePickerCellDelegate> delegate;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setDate:(NSDate *)date;

@end