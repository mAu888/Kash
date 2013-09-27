/**
* Created by Maurício Hanika on 27.09.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHNumberFormatter.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHNumberFormatter ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHNumberFormatter
{

    NSNumberFormatter *_currencyNumberFormatter;
    NSNumberFormatter *_decimalNumberFormatter;
}

+ (instancetype)sharedInstance
{
    static KSHNumberFormatter *instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^
    {
        instance = [[KSHNumberFormatter alloc] init];
    });

    return instance;
}

- (NSNumberFormatter *)currencyNumberFormatter
{
    @synchronized ( self )
    {
        if ( _currencyNumberFormatter == nil )
        {
            _currencyNumberFormatter = [[NSNumberFormatter alloc] init];
            _currencyNumberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
            _currencyNumberFormatter.lenient = YES;
        }
    }

    return _currencyNumberFormatter;
}

- (NSNumberFormatter *)decimalNumberFormatter
{
    @synchronized ( self )
    {
        if ( _decimalNumberFormatter == nil )
        {
            _decimalNumberFormatter = [[NSNumberFormatter alloc] init];
            _decimalNumberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
            _decimalNumberFormatter.usesGroupingSeparator = NO;
            _decimalNumberFormatter.alwaysShowsDecimalSeparator = YES;
            _decimalNumberFormatter.minimumFractionDigits = 2;
            _decimalNumberFormatter.maximumFractionDigits = 2;
        }
    }

    return _decimalNumberFormatter;
}

@end