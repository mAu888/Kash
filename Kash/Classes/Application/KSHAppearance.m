/**
* Created by Maurício Hanika on 14.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Colours/UIColor+Colours.h>
#import "KSHAppearance.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHAppearance ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHAppearance
{

}

+ (void)applyAppearance
{
    [self appearanceForNavigationBar];
    [self appearanceForTabBar];
}

+ (void)appearanceForTabBar
{
    UIFontDescriptor *fontDescriptor =
        [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleFootnote];

    NSDictionary *attributes = @{
        NSFontAttributeName : [UIFont fontWithName:@"OpenSans" size:[fontDescriptor pointSize]]
    };

    [[UITabBarItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

+ (void)appearanceForNavigationBar
{
    UIFontDescriptor *fontDescriptor =
        [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline];

    NSDictionary *attributes = @{
        NSFontAttributeName : [UIFont fontWithName:@"OpenSans" size:[fontDescriptor pointSize]],
        NSForegroundColorAttributeName : [UIColor charcoalColor]
    };

    [UINavigationBar appearance].titleTextAttributes = attributes;
    [[UIBarItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

@end