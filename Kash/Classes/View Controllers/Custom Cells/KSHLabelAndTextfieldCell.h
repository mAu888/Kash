/**
* Created by Maurício Hanika on 09.08.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "KSHTableViewCell.h"

typedef NS_ENUM(NSInteger, KSHTextFieldType)
{
    KSHDefaultTextField,
    KSHCurrencyTextField,
    KSHDecimalTextField
};

@protocol KSHInputCellDelegate;

@interface KSHLabelAndTextFieldCell : KSHTableViewCell

@property(nonatomic, weak) id <KSHInputCellDelegate> delegate;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, assign) CGFloat textLabelMinimumWidth;
@property(nonatomic, assign) CGFloat textLabelMaximumWidth;
@property(nonatomic, assign) KSHTextFieldType textFieldType;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end