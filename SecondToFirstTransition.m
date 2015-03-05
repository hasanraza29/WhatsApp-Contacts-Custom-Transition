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
{
    UIView *_transitioningView;
    UIPinchGestureRecognizer *_pinchRecognizer;
    CGFloat _startScale, _completionSpeed;
}

-(void)updateWithPercent:(CGFloat)percent;
-(void)end:(BOOL)cancelled;

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation SecondToFirstTransition

@synthesize viewForInteraction = _viewForInteraction;

-(instancetype)initWithNavigationController:(UINavigationController *)controller {
    self = [super init];
    if (self) {
        self.navigationController = controller;
        _completionSpeed = 0.2;
        
        _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    }
    return self;
}

-(void)setViewForInteraction:(UIView *)viewForInteraction {
    if (_viewForInteraction && [_viewForInteraction.gestureRecognizers containsObject:_pinchRecognizer]) [_viewForInteraction removeGestureRecognizer:_pinchRecognizer];
    
    _viewForInteraction = viewForInteraction;
    [_viewForInteraction addGestureRecognizer:_pinchRecognizer];
}

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

-(void)animationEnded:(BOOL)transitionCompleted {
    self.interactive = NO;
}


#pragma mark - Interactive Transitioning

-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //Maintain reference to context
    self.transitionContext = transitionContext;
    
    //Get references to view hierarchy
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //Insert 'to' view into hierarchy
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    //Save reference for view to be scaled
    _transitioningView = fromViewController.view;
}

-(void)updateWithPercent:(CGFloat)percent {
    CGFloat scale = fabsf(percent-1.0);
    _transitioningView.transform = CGAffineTransformMakeScale(scale, scale);
    [self.transitionContext updateInteractiveTransition:percent];
}

-(void)end:(BOOL)cancelled {
    if (cancelled) {
        [UIView animateWithDuration:_completionSpeed animations:^{
            _transitioningView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            [self.transitionContext cancelInteractiveTransition];
            [self.transitionContext completeTransition:NO];
        }];
    } else {
        [UIView animateWithDuration:_completionSpeed animations:^{
            _transitioningView.transform = CGAffineTransformMakeScale(0.0, 0.0);
        } completion:^(BOOL finished) {
            [self.transitionContext finishInteractiveTransition];
            [self.transitionContext completeTransition:YES];
        }];
    }
}

-(void)handlePinch:(UIPinchGestureRecognizer *)pinch {
    CGFloat scale = pinch.scale;
    switch (pinch.state) {
        case UIGestureRecognizerStateBegan:
            _startScale = scale;
            self.interactive = YES;
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat percent = (1.0 - scale/_startScale);
            [self updateWithPercent:(percent < 0.0) ? 0.0 : percent];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            CGFloat percent = (1.0 - scale/_startScale);
            BOOL cancelled = ([pinch velocity] < 5.0 && percent <= 0.3);
            [self end:cancelled];
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            CGFloat percent = (1.0 - scale/_startScale);
            BOOL cancelled = ([pinch velocity] < 5.0 && percent <= 0.3);
            [self end:cancelled];
            break;
        }
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateFailed:
            break;
    }
}



@end
