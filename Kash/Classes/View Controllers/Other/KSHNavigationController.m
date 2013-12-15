/**
* Created by Maurício Hanika on 15.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHNavigationController.h"
#import "KSHDropOutTransition.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHNavigationController ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHNavigationController

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source
{
    KSHDropOutTransition *animationController = [[KSHDropOutTransition alloc] init];
    animationController.type = KSHAnimatedTransitioningWillAppear;
    return animationController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    KSHDropOutTransition *animationController = [[KSHDropOutTransition alloc] init];
    animationController.type = KSHAnimatedTransitioningWillDismiss;
    return animationController;
}

@end