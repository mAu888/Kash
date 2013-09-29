/**
* Created by Maurício Hanika on 29.09.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>

@interface KSHDateFormatterFactory : NSObject

+ (instancetype)sharedInstance;

- (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle
                                      timeStyle:(NSDateFormatterStyle)timeStyle;
- (NSDateFormatter *)dateFormatterWithDateFormat:(NSString *)dateFormat;

@end