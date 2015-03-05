//
//  FirstToSecondTransition.m
//  WhatsApp Contacts Custom Transition
//
//  Created by Hasan on 05/03/2015.
//  Copyright (c) 2015 Wasi Ahmed. All rights reserved.
//

#import "FirstToSecondTransition.h"
#import "SecondViewController.h"
#import "ViewController.h"

@interface FirstToSecondTransition ()

@property (nonatomic ,strong) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation FirstToSecondTransition

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
    ViewController *fromVC = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    SecondViewController *toVC = (SecondViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    UITableViewCell *cell = [fromVC.tableView cellForRowAtIndexPath:[fromVC.tableView indexPathForSelectedRow]];
    
    UIImageView *imageViewOnCell = (UIImageView *)[cell viewWithTag:100];
    UIView *snapshotViewFromImageView = [imageViewOnCell snapshotViewAfterScreenUpdates:NO];
    snapshotViewFromImageView.frame = [containerView convertRect:imageViewOnCell.frame fromView:imageViewOnCell.superview];
    
    imageViewOnCell.hidden = YES;
    toVC.imageView.image = imageViewOnCell.image;
    toVC.imageView.layer.cornerRadius = toVC.imageView.frame.size.width * 0.45;
    
    // Setup the initial view states
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0;
    toVC.imageView.hidden = YES;
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:snapshotViewFromImageView];
    
    
    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // Fade in the second view controller's view
        toVC.view.alpha = 1.0;
        
        // Move the cell snapshot so it's over the second view controller's image view
        CGRect frame = [containerView convertRect:toVC.imageView.frame fromView:toVC.view];
        snapshotViewFromImageView.frame = frame;
        
    } completion:^(BOOL finished) {
        
        // Clean up
        [snapshotViewFromImageView removeFromSuperview];
        toVC.imageView.hidden = NO;
        cell.hidden = NO;
        
        // Declare that we've finished
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

-(void)animationEnded:(BOOL)transitionCompleted
{
    if(transitionCompleted){
        
         ViewController *fromVC = (ViewController *)[self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
         UITableViewCell *cell = [fromVC.tableView cellForRowAtIndexPath:[fromVC.tableView indexPathForSelectedRow]];
         UIImageView *imageViewOnCell = (UIImageView *)[cell viewWithTag:100];
        imageViewOnCell.hidden = NO;

    }
}

@end
