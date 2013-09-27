/**
* Created by Maurício Hanika on 27.09.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "KSHLabelAndTextFieldCell.h"

@interface KSHLabelAndTextFieldCell (Formatting)

- (NSNumber *)numericValue;

- (void)setCurrencyValue:(NSNumber *)number;
- (void)setDecimalValue:(NSNumber *)number;

@end