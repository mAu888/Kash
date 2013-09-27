/**
* Created by Maurício Hanika on 27.09.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHLabelAndTextFieldCell+Formatting.h"
#import "KSHNumberFormatter.h"


////////////////////////////////////////////////////////////////////////////////
@implementation KSHLabelAndTextFieldCell (Formatting)

- (NSNumber *)numericValue
{
    if ( self.textFieldType == KSHCurrencyTextField )
    {
        NSNumberFormatter *currencyNumberFormatter = [KSHNumberFormatter sharedInstance].currencyNumberFormatter;
        return [currencyNumberFormatter numberFromString:self.textField.text];
    }
    else if ( self.textFieldType == KSHDecimalTextField )
    {
        NSNumberFormatter *decimalNumberFormatter = [KSHNumberFormatter sharedInstance].decimalNumberFormatter;
        return [decimalNumberFormatter numberFromString:self.textField.text];
    }

    return nil;
}

- (void)setCurrencyValue:(NSNumber *)number
{
    NSNumberFormatter *currencyNumberFormatter = [KSHNumberFormatter sharedInstance].currencyNumberFormatter;
    self.textField.text = [currencyNumberFormatter stringFromNumber:number];
}

- (void)setDecimalValue:(NSNumber *)number
{
    NSNumberFormatter *decimalNumberFormatter = [KSHNumberFormatter sharedInstance].decimalNumberFormatter;
    self.textField.text = [decimalNumberFormatter stringFromNumber:number];
}


@end