//
//  YSViewController.m
//  YSTransitionExample
//
//  Created by ysakui on 2013/11/01.
//  Copyright (c) 2013年 YoshimitsuSakui. All rights reserved.
//

#import "YSViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface YSViewController ()
@property (nonatomic, strong) CALayer *animationLayer;
@end

@implementation YSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Default
        _transitionDuration = 0.6f;
        _timingFunction = [CAMediaTimingFunction functionWithControlPoints: 0.075 : 0.82 : 0.165 : 1.0];
    }
    return self;
}


#pragma mark - Instance methods

- (void)presentViewController:(UIViewController *)viewController
           withTransitionType:(YSTransitionType)transitionType
                   completion:(void (^)(void))completion {
    
    [self.animationLayer removeFromSuperlayer];
    [self.view.window.layer addSublayer:self.animationLayer];
    
    UIImage *layerImage = [YSTransitionUtil getCaptureOfView:self.view.window];
    self.animationLayer.contents = (id)layerImage.CGImage;
    self.animationLayer.hidden = NO;
    
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    baseAnimation.timingFunction = self.timingFunction;
    baseAnimation.duration = self.transitionDuration;
    baseAnimation.delegate = self;
    baseAnimation.removedOnCompletion = NO;
    baseAnimation.fillMode = kCAFillModeForwards;
    baseAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    baseAnimation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.00001, 1, 0, 0)];
    
    CABasicAnimation *presentAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    presentAnimation.timingFunction = self.timingFunction;
    presentAnimation.duration = self.transitionDuration;
    presentAnimation.delegate = self;
    presentAnimation.removedOnCompletion = NO;
    presentAnimation.fillMode = kCAFillModeForwards;
    presentAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];

    CGSize size = self.view.window.bounds.size;
    
    if (transitionType == YSTransitionTypeFromRight) {
        presentAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation( size.width, 0, 0)];
    } else if (transitionType == YSTransitionTypeFromLeft) {
        presentAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-size.width, 0, 0)];
    } else if (transitionType == YSTransitionTypeFromTop) {
        presentAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0,  size.height, 0)];
    } else if (transitionType == YSTransitionTypeFromBottom) {
        presentAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -size.height, 0)];
    }
    
    
    [self.animationLayer addAnimation:baseAnimation forKey:@"presentAnimation"];
    [viewController.view.layer addAnimation:presentAnimation forKey:@"presentAnimation"];

    [self presentViewController:viewController animated:NO completion:completion];
}

- (void)dismissViewControllerWithTransitionType:(YSTransitionType)transitionType completion:(void (^)(void))completion {
    
    [self.animationLayer removeFromSuperlayer];
    [self.view.window.layer addSublayer:self.animationLayer];
    
    BOOL isTranslucent = NO;
    if (self.navigationController && !self.navigationController.navigationBarHidden && self.navigationController.navigationBar.translucent) {
        isTranslucent = YES;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    UIImage *layerImage = [YSTransitionUtil getCaptureOfView:self.view.window];
    self.animationLayer.contents = (id)layerImage.CGImage;
    self.animationLayer.hidden = NO;
    
    if (isTranslucent)
        self.navigationController.navigationBar.translucent = YES;
    
    
    CABasicAnimation *dismissAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    dismissAnimation.timingFunction = self.timingFunction;
    dismissAnimation.duration = self.transitionDuration;
    dismissAnimation.delegate = self;
    dismissAnimation.removedOnCompletion = NO;
    dismissAnimation.fillMode = kCAFillModeBoth;
    dismissAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    CGSize size = self.view.window.bounds.size;
    
    if (transitionType == YSTransitionTypeFromRight) {
        dismissAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-size.width, 0, 0)];
    } else if (transitionType == YSTransitionTypeFromLeft) {
        dismissAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation( size.width, 0, 0)];
    } else if (transitionType == YSTransitionTypeFromTop) {
        dismissAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -size.height, 0)];
    } else if (transitionType == YSTransitionTypeFromBottom) {
        dismissAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0,  size.height, 0)];
    }
    
    [self.animationLayer addAnimation:dismissAnimation forKey:@"dismissAnimation"];
    
    [self dismissViewControllerAnimated:NO completion:completion];
}


#pragma mark - Animation delegate

- (void)animationDidStart:(CAAnimation *)anim {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.animationLayer.contents = nil;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}


#pragma mark - Accessor

- (CALayer *)animationLayer {
    if (!_animationLayer) {
        _animationLayer = [CALayer layer];
        _animationLayer.frame = CGRectMake(0, 0, self.view.window.bounds.size.width, self.view.window.bounds.size.height);
        _animationLayer.position = CGPointMake(self.view.window.bounds.size.width, self.view.window.bounds.size.height);
        _animationLayer.anchorPoint = CGPointMake(1, 1);
        _animationLayer.masksToBounds = YES;
        _animationLayer.delegate = self;
    }
    return _animationLayer;
}

@end
