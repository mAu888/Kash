/**
* Created by Maurício Hanika on 09.08.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>

@protocol KSHInputCellDelegate;

@interface KSHLabelAndTextfieldCell : UITableViewCell

@property(nonatomic, weak) id <KSHInputCellDelegate> delegate;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, assign) CGFloat textLabelMinimumWidth;
@property(nonatomic, assign) CGFloat textLabelMaximumWidth;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end