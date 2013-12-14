/**
* Created by Maurício Hanika on 14.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "UILabel+KSHAdditions.h"

////////////////////////////////////////////////////////////////////////////////
@implementation UILabel (KSHAdditions)

- (CGSize)sizeConstrainedToSize:(CGSize)constrainedSize
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];

    CGRect rect = [self.text boundingRectWithSize:constrainedSize
                                          options:0
                                       attributes:@{
                                           NSParagraphStyleAttributeName : paragraphStyle,
                                           NSFontAttributeName           : self.font
                                       }
                                          context:nil];

    return rect.size;
}

@end