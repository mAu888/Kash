/**
* Created by Maurício Hanika on 29.09.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>

@class KSHColorPickerViewController;
@protocol KSHColorPickerViewControllerDelegate <NSObject>

@optional
- (void)colorPickerControllerDidSelectColor:(UIColor *)color;

@end

@interface KSHColorPickerViewController : UICollectionViewController

@property (nonatomic, weak) id <KSHColorPickerViewControllerDelegate> delegate;

@end