//
//  SecondToFirstTransition.h
//  WhatsApp Contacts Custom Transition
//
//  Created by Hasan on 05/03/2015.
//  Copyright (c) 2015 Wasi Ahmed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SecondToFirstTransition : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign, getter = isInteractive) BOOL interactive;
@property (nonatomic, assign) UINavigationController *navigationController;
@property (nonatomic, strong) UIView *viewForInteraction;

-(instancetype)initWithNavigationController:(UINavigationController *)controller;
-(void)handlePinch:(UIPinchGestureRecognizer *)pinch;
@end
