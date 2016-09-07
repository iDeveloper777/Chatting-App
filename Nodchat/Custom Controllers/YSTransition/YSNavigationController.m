//
//  YSNavigationController.m
//  YSTransitionExample
//
//  Created by ysakui on 2013/11/01.
//  Copyright (c) 2013年 YoshimitsuSakui. All rights reserved.
//

#import "YSNavigationController.h"
#import <QuartzCore/QuartzCore.h>

@interface YSNavigationController ()
@property (nonatomic, strong) CALayer *animationLayer;
@end

@implementation YSNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        
        // Default
        _transitionDuration = 0.6f;
        _timingFunction = [CAMediaTimingFunction functionWithControlPoints: 0.075 : 0.82 : 0.165 : 1.0];
    }
    return self;
}


#pragma mark - Instance methods

- (void)pushViewController:(UIViewController *)viewController withTransitionType:(YSTransitionType)transitionType {
    [self setAnimationWithTransitionType:transitionType forKey:@"pushAnimation"];
    [super pushViewController:viewController animated:NO];
}

- (UIViewController *)popViewControllerWithTransitionType:(YSTransitionType)transitionType {
    [self setAnimationWithTransitionType:transitionType forKey:@"popAnimation"];
    return [super popViewControllerAnimated:NO];
}


#pragma mark - Private methods

- (void)setAnimationWithTransitionType:(YSTransitionType)transitionType forKey:(NSString *)key {
    
    [self.animationLayer removeFromSuperlayer];
    [self.view.window.layer addSublayer:self.animationLayer];
    
    UIImage *layerImage = [YSTransitionUtil getCaptureOfView:self.view];
    self.animationLayer.contents = (id)layerImage.CGImage;
    self.animationLayer.hidden = NO;
    
    CABasicAnimation *oldViewAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    oldViewAnimation.timingFunction = self.timingFunction;
    oldViewAnimation.duration = self.transitionDuration;
    oldViewAnimation.delegate = self;
    oldViewAnimation.removedOnCompletion = NO;
    oldViewAnimation.fillMode = kCAFillModeForwards;
    oldViewAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    CABasicAnimation *nextViewAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    nextViewAnimation.timingFunction = self.timingFunction;
    nextViewAnimation.duration = self.transitionDuration;
    nextViewAnimation.delegate = self;
    nextViewAnimation.removedOnCompletion = NO;
    nextViewAnimation.fillMode = kCAFillModeForwards;
    nextViewAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    CGSize size = self.view.window.bounds.size;
    
    if (transitionType == YSTransitionTypeFromRight) {
        oldViewAnimation.toValue    = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-size.width, 0, 0)];
        nextViewAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation( size.width, 0, 0)];
    } else if (transitionType == YSTransitionTypeFromLeft) {
        oldViewAnimation.toValue    = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation( size.width, 0, 0)];
        nextViewAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-size.width, 0, 0)];
    } else if (transitionType == YSTransitionTypeFromTop) {
        oldViewAnimation.toValue    = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0,  size.height, 0)];
        nextViewAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -size.height, 0)];
    } else if (transitionType == YSTransitionTypeFromBottom) {
        oldViewAnimation.toValue    = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -size.height, 0)];
        nextViewAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0,  size.height, 0)];
    }
    
    [self.animationLayer addAnimation:oldViewAnimation forKey:key];
    [self.view.layer addAnimation:nextViewAnimation forKey:key];
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
