/**
* Created by Maurício Hanika on 14.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

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
    NSDictionary *attributes = @{
        NSFontAttributeName : [UIFont fontWithName:@"OpenSans" size:10.f]
    };

    [[UITabBarItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

+ (void)appearanceForNavigationBar
{
    NSDictionary *attributes = @{
        NSFontAttributeName : [UIFont fontWithName:@"OpenSans" size:18.f]
    };

    [UINavigationBar appearance].titleTextAttributes = attributes;
    [[UIBarItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

@end