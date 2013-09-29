/**
* Created by Maurício Hanika on 29.09.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHColorPickerViewController.h"
#import "KSHColorCollectionCell.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHColorPickerViewController ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHColorPickerViewController
{
    NSArray *_colors;
}

- (id)init
{
    self = [super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];

    if ( self )
    {
        _colors = @[
            [UIColor redColor],
            [UIColor greenColor],
            [UIColor blueColor],
            [UIColor yellowColor],
            [UIColor blackColor],
            [UIColor grayColor],
            [UIColor brownColor],
            [UIColor cyanColor],
            [UIColor orangeColor],
            [UIColor magentaColor]
        ];
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


@end