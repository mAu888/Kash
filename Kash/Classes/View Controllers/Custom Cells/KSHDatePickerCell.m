/**
* Created by Maurício Hanika on 29.09.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHDatePickerCell.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHDatePickerCell ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHDatePickerCell
{

    UIDatePicker *_datePicker;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];

    if ( self != nil )
    {
        _datePicker = [[UIDatePicker alloc] initWithFrame:self.contentView.bounds];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        _datePicker.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_datePicker addTarget:self
                        action:@selector(datePickerDidChangeDate:)
              forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_datePicker];
    }

    return self;
}

- (void)datePickerDidChangeDate:(UIDatePicker *)datePicker
{
    if ( _delegate != nil && [_delegate respondsToSelector:@selector(datePickerCellDidChangeToDate:)] )
    {
        [_delegate datePickerCellDidChangeToDate:_datePicker.date];
    }
}

- (void)setDate:(NSDate *)date
{
    if ( date == nil )
    {
        date = [NSDate date];
    }

    [_datePicker setDate:date animated:YES];
}


@end