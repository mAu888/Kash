/**
* Created by Maurício Hanika on 27.09.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>

@interface KSHNumberFormatter : NSNumberFormatter

+ (instancetype)sharedInstance;
- (NSNumberFormatter *)currencyNumberFormatter;

@end