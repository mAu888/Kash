/**
* Created by Maurício Hanika on 27.09.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "KSHLabelAndTextfieldCell.h"

@interface KSHLabelAndTextfieldCell (Formatting)

- (NSNumber *)numericValue;

- (void)setCurrencyValue:(NSNumber *)number;
- (void)setDecimalValue:(NSNumber *)number;

@end