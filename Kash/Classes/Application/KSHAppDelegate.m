/**
* Created by Maurício Hanika on 14.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Colours/UIColor+Colours.h>
#import "KSHAppDelegate.h"
#import "KSHMainViewController.h"
#import "KSHAppearance.h"

@implementation KSHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [KSHAppearance applyAppearance];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.tintColor = [UIColor chartreuseColor];

    KSHMainViewController *controller = [[KSHMainViewController alloc] init];
    self.window.rootViewController = controller;

    [self.window makeKeyAndVisible];

    return YES;
}

@end
