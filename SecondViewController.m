//
//  SecondViewController.m
//  WhatsApp Contacts Custom Transition
//
//  Created by Hasan on 05/03/2015.
//  Copyright (c) 2015 Wasi Ahmed. All rights reserved.
//

#import "SecondViewController.h"
#import "SecondToFirstTransition.h"
#import "ViewController.h"

@interface SecondViewController ()<UINavigationControllerDelegate>
{
    SecondToFirstTransition *vc;
}
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width * 0.45;
    self.imageView.clipsToBounds = YES;
    vc = [[SecondToFirstTransition alloc]initWithNavigationController:self.navigationController];
    vc.viewForInteraction = self.view;

}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Set outself as the navigation controller's delegate so we're asked for a transitioning object
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Stop being the navigation controller's delegate
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if(fromVC == self && [toVC isKindOfClass:[ViewController class]]){
        
        return vc;
    }
    return nil;
}

@end
