/**
* Created by Maurício Hanika on 15.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KSHAnimatedTransitioningDirection)
{
    KSHAnimatedTransitioningWillAppear,
    KSHAnimatedTransitioningWillDismiss
};

@interface KSHDropOutTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property(nonatomic, assign) KSHAnimatedTransitioningDirection type;

@end