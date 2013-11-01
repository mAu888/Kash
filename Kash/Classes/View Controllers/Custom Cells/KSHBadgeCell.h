/**
* Created by Maurício Hanika on 18.10.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>

@interface KSHBadgeCell : UITableViewCell

@property (nonatomic, readonly) UILabel *badgeLabel;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end