/**
* Created by Maurício Hanika on 27.09.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>

@interface KSHNumberFormatter : NSObject

@property (nonatomic, readonly) NSNumberFormatter *currencyNumberFormatter;
@property (nonatomic, readonly) NSNumberFormatter *decimalNumberFormatter;

+ (instancetype)sharedInstance;

@end