/**
* Created by Maurício Hanika on 29.09.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHDateFormatterFactory.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHDateFormatterFactory ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHDateFormatterFactory
{
    NSCache *_dateFormatterCache;
}

+ (instancetype)sharedInstance
{
    static KSHDateFormatterFactory *instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^
    {
        instance = [[KSHDateFormatterFactory alloc] init];
    });

    return instance;
}

- (id)init
{
    self = [super init];

    if ( self )
    {
        _dateFormatterCache = [[NSCache alloc] init];
    }

    return self;
}


- (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle
                                      timeStyle:(NSDateFormatterStyle)timeStyle
{
    NSString *key = [NSString stringWithFormat:@"d%d_t%d", dateStyle, timeStyle];
    NSDateFormatter *dateFormatter = [_dateFormatterCache objectForKey:key];

    if ( dateFormatter == nil )
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = dateStyle;
        dateFormatter.timeStyle = timeStyle;
        dateFormatter.doesRelativeDateFormatting = YES;

        [_dateFormatterCache setObject:dateFormatter forKey:key];
    }

    return dateFormatter;
}

- (NSDateFormatter *)dateFormatterWithDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [_dateFormatterCache objectForKey:dateFormat];

    if ( dateFormatter == nil )
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = dateFormat;

        [_dateFormatterCache setObject:dateFormatter forKey:dateFormat];
    }

    return dateFormatter;
}

@end