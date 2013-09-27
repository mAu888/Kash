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
        }
    }
    
    return _currencyNumberFormatter;
}


@end