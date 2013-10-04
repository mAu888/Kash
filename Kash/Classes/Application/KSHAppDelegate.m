//
//  KSHAppDelegate.m
//  Kash
//
//  Created by Maurício Hanika on 09.08.13.
//  Copyright (c) 2013 Maurício Hanika. All rights reserved.
//

#import "KSHAppDelegate.h"
#import "KSHMainViewController.h"

@implementation KSHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    KSHMainViewController *controller = [[KSHMainViewController alloc] init];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
