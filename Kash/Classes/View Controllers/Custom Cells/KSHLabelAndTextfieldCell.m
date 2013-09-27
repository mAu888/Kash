/**
* Created by Maurício Hanika on 09.08.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHLabelAndTextFieldCell.h"
#import "KSHInputCellDelegate.h"
#import "KSHNumberFormatter.h"
#import "KSHTextField.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHLabelAndTextFieldCell () <UITextFieldDelegate>

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHLabelAndTextFieldCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:reuseIdentifier];

    if ( self != nil )
    {
        KSHTextField *textField = [[KSHTextField alloc] initWithFrame:CGRectZero];
        textField.textInsets = UIEdgeInsetsMake(.0f, .0f, .0f, 5.f);

        _textField = textField;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.enablesReturnKeyAutomatically = YES;

//        _textField.rightView = [[UIView alloc]
//        initWithFrame:CGRect;Make(.0f, .0f, 5.f, CGRectGetHeight(_textField.bounds))];
//        _textField.rightViewMode = UITextFieldViewModeAlways
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;

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

        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                 target:nil
                                 action:nil];

        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                 target:self.textField
                                 action:@selector(resignFirstResponder)];

        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(.0f, .0f, CGRectGetWidth(self.bounds), 44.f)];
        toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        toolbar.items = @[
            flexibleItem,
            doneItem
        ];

        self.textField.inputAccessoryView = toolbar;
    }
    else
    {
        self.textField.keyboardType = UIKeyboardTypeDefault;
        self.textField.inputAccessoryView = nil;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
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

- (BOOL)textField:(UITextField *)textField
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