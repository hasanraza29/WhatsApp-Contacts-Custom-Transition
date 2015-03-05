//
//  SecondToFirstTransition.m
//  WhatsApp Contacts Custom Transition
//
//  Created by Hasan on 05/03/2015.
//  Copyright (c) 2015 Wasi Ahmed. All rights reserved.
//

#import "SecondToFirstTransition.h"
#import "ViewController.h"
#import "SecondViewController.h"


@interface SecondToFirstTransition ()
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@end

@implementation SecondToFirstTransition

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    self.transitionContext = transitionContext;
    ViewController *toVC = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    SecondViewController *fromVC = (SecondViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIView *snapshot = [fromVC.imageView snapshotViewAfterScreenUpdates:NO];
    snapshot.frame = fromVC.imageView.frame;
    
    // Get a snapshot of the image view
    UIView *imageSnapshot = [fromVC.imageView snapshotViewAfterScreenUpdates:NO];
    imageSnapshot.frame = [containerView convertRect:fromVC.imageView.frame fromView:fromVC.imageView.superview];
    fromVC.imageView.hidden = YES;
    
    UITableViewCell *cell = [toVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UIImageView *imageViewOnCell = (UIImageView *)[cell viewWithTag:100];
    imageViewOnCell.hidden = YES;
    
    // Setup the initial view states
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    [containerView addSubview:imageSnapshot];
    
    
    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        // Fade out the source view controller
        fromVC.view.alpha = 0.0;
        
        // Move the image view
        CGRect rect = [containerView convertRect:imageViewOnCell.frame fromView:cell];
        imageSnapshot.frame = rect;
        
    } completion:^(BOOL finished) {
        
        // Clean up
        [imageSnapshot removeFromSuperview];
        fromVC.imageView.hidden = NO;
        imageViewOnCell.hidden = NO;
        
        // Declare that we've finished
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.4;
}


@end
