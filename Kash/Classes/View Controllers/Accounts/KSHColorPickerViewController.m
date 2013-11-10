/**
* Created by Maurício Hanika on 29.09.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHColorPickerViewController.h"
#import "KSHColorCollectionCell.h"
#import "UIColor+Colours.h"
#import "KSHFlowLayout.h"

const float KSHMinimumInterItemSpacing = 15.f;

////////////////////////////////////////////////////////////////////////////////
@interface KSHColorPickerViewController () <UICollectionViewDelegateFlowLayout>

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHColorPickerViewController
{
    NSArray *_colors;
}

- (id)init
{
    self = [super initWithCollectionViewLayout:[[KSHFlowLayout alloc] init]];

    if ( self )
    {
        NSMutableArray *colors = [NSMutableArray array];
        [colors addObjectsFromArray:[[UIColor robinEggColor] colorSchemeOfType:ColorSchemeMonochromatic]];
        [colors addObjectsFromArray:[[UIColor pastelGreenColor] colorSchemeOfType:ColorSchemeMonochromatic]];
        [colors addObjectsFromArray:[[UIColor pastelBlueColor] colorSchemeOfType:ColorSchemeMonochromatic]];
        [colors addObjectsFromArray:[[UIColor pastelPurpleColor] colorSchemeOfType:ColorSchemeMonochromatic]];
        [colors addObjectsFromArray:[[UIColor mustardColor] colorSchemeOfType:ColorSchemeMonochromatic]];
        [colors addObjectsFromArray:[[UIColor charcoalColor] colorSchemeOfType:ColorSchemeAnalagous]];

        _colors = [NSArray arrayWithArray:colors];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.contentInset = UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f);
    [self.collectionView registerClass:KSHColorCollectionCell.class
            forCellWithReuseIdentifier:NSStringFromClass(KSHColorCollectionCell.class)];
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _colors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KSHColorCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(KSHColorCollectionCell.class)
                                                                             forIndexPath:indexPath];

    cell.color = _colors[( NSUInteger ) indexPath.row];

    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( _delegate != nil && [_delegate respondsToSelector:@selector(colorPickerControllerDidSelectColor:)] )
    {
        UIColor *color = _colors[( NSUInteger ) indexPath.item];
        [_delegate colorPickerControllerDidSelectColor:color];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                             layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return KSHMinimumInterItemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                                  layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return KSHMinimumInterItemSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets = collectionView.contentInset;
    CGFloat edgeLength = ((collectionView.bounds.size.width - insets.left - insets.right - KSHMinimumInterItemSpacing) / 2.f);

    return CGSizeMake(edgeLength, edgeLength);
}


@end