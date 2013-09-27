/**
* Created by Maurício Hanika on 09.08.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHLabelAndTextfieldCell.h"
#import "KSHInputCellDelegate.h"
#import "KSHNumberFormatter.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHLabelAndTextfieldCell () <UITextFieldDelegate>

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHLabelAndTextfieldCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:reuseIdentifier];

    if ( self != nil )
    {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.textAlignment = NSTextAlignmentRight;

        _textField.rightView = [[UIView alloc]
            initWithFrame:CGRectMake(.0f, .0f, 5.f, CGRectGetHeight(_textField.bounds))];
        _textField.rightViewMode = UITextFieldViewModeAlways;

        _textField.delegate = self;

        [self.contentView addSubview:_textField];

        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.textLabelMinimumWidth = 50.f;
        self.textLabelMaximumWidth = 100.f;
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.textLabel.frame = CGRectMake(CGRectGetMinX(self.textLabel.frame),
        CGRectGetMinY(self.textLabel.frame),
        MIN(MAX(CGRectGetWidth(self.textLabel.frame), self.textLabelMinimumWidth), self.textLabelMaximumWidth),
        CGRectGetHeight(self.textLabel.frame));

    _textField.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame),
        .0f,
        CGRectGetWidth(self.contentView.bounds) - CGRectGetMaxX(self.textLabel.frame),
        CGRectGetHeight(self.contentView.bounds));
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

- (void)setTextFieldType:(KSHTextFieldType)textFieldType
{
    _textFieldType = textFieldType;
    if ( textFieldType == KSHDecimalTextField || textFieldType == KSHCurrencyTextField )
    {
        self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    else
    {
        self.textField.keyboardType = UIKeyboardTypeDefault;
    }
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ( _textFieldType == KSHCurrencyTextField )
    {
        NSNumberFormatter *currencyNumberFormatter = [KSHNumberFormatter sharedInstance].currencyNumberFormatter;
        NSNumber *currentValue = [currencyNumberFormatter numberFromString:_textField.text];

        NSNumberFormatter *decimalNumberFormatter = [KSHNumberFormatter sharedInstance].decimalNumberFormatter;
        textField.text = [decimalNumberFormatter stringFromNumber:currentValue];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ( _textFieldType == KSHCurrencyTextField )
    {
        NSNumberFormatter *decimalNumberFormatter = [KSHNumberFormatter sharedInstance].decimalNumberFormatter;
        NSNumber *currentValue = [decimalNumberFormatter numberFromString:_textField.text];

        NSNumberFormatter *currencyNumberFormatter = [KSHNumberFormatter sharedInstance].currencyNumberFormatter;
        textField.text = [currencyNumberFormatter stringFromNumber:currentValue];
    }

    if ( _delegate != nil && [_delegate respondsToSelector:@selector(cellDidChangeValue:)] )
    {
        [_delegate cellDidChangeValue:self];
    }
}

- (BOOL)            textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
            replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range
                                                                  withString:string];
    if ( _textFieldType == KSHCurrencyTextField || _textFieldType == KSHDecimalTextField )
    {
        NSNumberFormatter *formatter = [KSHNumberFormatter sharedInstance].decimalNumberFormatter;
        NSNumber *currentValue = [formatter numberFromString:newString];

        if ( currentValue == nil && newString.length > 0 )
        {
            return NO;
        }
    }

    return YES;
}


@end