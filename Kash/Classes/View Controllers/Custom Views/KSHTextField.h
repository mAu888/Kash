/**
* Created by Maurício Hanika on 27.09.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>

@interface KSHTextField : UITextField

@property (nonatomic, assign) UIEdgeInsets textInsets;

- (void)setTextColor:(UIColor *)textColor forControlState:(UIControlState)state;
@end