/**
* Created by Maurício Hanika on 15.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHDropOutTransition.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHDropOutTransition () <UICollisionBehaviorDelegate>

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHDropOutTransition
{
    UIDynamicAnimator *_animator;
    id <UIViewControllerContextTransitioning> _transitionContext;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if ( self.type == KSHAnimatedTransitioningWillDismiss )
    {
        return .557f;
    }

    return .335f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    _transitionContext = transitionContext;

    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    if ( self.type == KSHAnimatedTransitioningWillAppear )
    {
        [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];

        float shadowRadius = 10.f;
        toViewController.view.frame = CGRectMake(
            .0f,
            CGRectGetMaxY(containerView.bounds) + shadowRadius,
            CGRectGetWidth(fromViewController.view.frame),
            CGRectGetHeight(fromViewController.view.frame)
        );

        UIView *shadowView = [[UIView alloc] initWithFrame:fromViewController.view.frame];
        shadowView.alpha = .0f;
        shadowView.backgroundColor = [UIColor blackColor];
        [fromViewController.view addSubview:shadowView];

        CALayer *layer = toViewController.view.layer;
        layer.shadowColor = [UIColor blackColor].CGColor;
        layer.shadowPath = [UIBezierPath bezierPathWithRect:fromViewController.view.frame].CGPath;
        layer.shadowOpacity = .3f;
        layer.shadowRadius = shadowRadius;

        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^
                         {
                             shadowView.alpha = .37f;
                             toViewController.view.frame = CGRectMake(
                                 .0f,
                                 .0f,
                                 CGRectGetWidth(fromViewController.view.frame),
                                 CGRectGetHeight(fromViewController.view.frame)
                             );
                         }
                         completion:^(BOOL finished)
                         {
                             [shadowView removeFromSuperview];
                             [transitionContext completeTransition:YES];
                         }];
    }
    else if ( self.type == KSHAnimatedTransitioningWillDismiss )
    {
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
        toViewController.view.frame = CGRectMake(
            .0f, .0f, CGRectGetWidth(containerView.bounds), CGRectGetHeight(containerView.bounds)
        );

        UIView *shadowView = [[UIView alloc] initWithFrame:toViewController.view.frame];
        shadowView.alpha = .37f;
        shadowView.backgroundColor = [UIColor blackColor];
        [toViewController.view addSubview:shadowView];

        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^
                         {
                             shadowView.alpha = .0f;
                         }
                         completion:^(BOOL finished)
                         {
                             [shadowView removeFromSuperview];
                         }];

        CALayer *layer = fromViewController.view.layer;
        layer.shadowColor = [UIColor blackColor].CGColor;
        layer.shadowPath = [UIBezierPath bezierPathWithRect:fromViewController.view.frame].CGPath;
        layer.shadowOpacity = .4f;
        layer.shadowRadius = 25.f;

        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:containerView];

        CGFloat inset = -hypotf(CGRectGetWidth(containerView.bounds), CGRectGetHeight(containerView.bounds));
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(inset, inset, inset, inset);

        UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[fromViewController.view]];
        collisionBehavior.collisionDelegate = self;
        collisionBehavior.translatesReferenceBoundsIntoBoundaryWithInsets = edgeInsets;
        [_animator addBehavior:collisionBehavior];

        UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[fromViewController.view]];
        gravityBehavior.gravityDirection = CGVectorMake(.0f, 3.7f);
        [_animator addBehavior:gravityBehavior];

        UIPushBehavior *pushBehavior = [[UIPushBehavior alloc]
            initWithItems:@[fromViewController.view] mode:UIPushBehaviorModeInstantaneous];
        pushBehavior.pushDirection = CGVectorMake([self randomFloatWithLowerBoundary:-18.f
                                                                       upperBoundary:18.f], 0.f);
        [pushBehavior setTargetOffsetFromCenter:UIOffsetMake(
            (CGRectGetHeight(fromViewController.view.frame) / 2.f),
            (CGRectGetWidth(fromViewController.view.frame) / 2.f)
        )
                                        forItem:fromViewController.view];
        [_animator addBehavior:pushBehavior];

        UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[fromViewController.view]];
        itemBehavior.allowsRotation = YES;
        [_animator addBehavior:itemBehavior];


        int64_t duration = ( int64_t ) (NSEC_PER_SEC * [self transitionDuration:transitionContext]);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration), dispatch_get_main_queue(), ^
        {
            if ( _animator != nil )
            {
                [_animator removeAllBehaviors];
                _animator = nil;

                [transitionContext completeTransition:YES];
            }
        });
    }
}


#pragma mark - UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior
      beganContactForItem:(id <UIDynamicItem>)item
   withBoundaryIdentifier:(id <NSCopying>)identifier
                  atPoint:(CGPoint)p
{
    [_animator removeAllBehaviors];
    _animator = nil;

    [_transitionContext completeTransition:YES];
}


#pragma mark - Private methods

- (float)randomFloatWithLowerBoundary:(float)smallNumber upperBoundary:(float)bigNumber
{
    float d = bigNumber - smallNumber;
    return ((( float ) (arc4random() % (( unsigned ) RAND_MAX + 1)) / RAND_MAX) * d) + smallNumber;
}

@end