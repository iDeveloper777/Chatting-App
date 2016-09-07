//
//  YSNavigationController.h
//  YSTransitionExample
//
//  Created by ysakui on 2013/11/01.
//  Copyright (c) 2013年 YoshimitsuSakui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTransitionUtil.h"

@interface YSNavigationController : UINavigationController

@property (nonatomic, assign, readwrite) CGFloat transitionDuration;
@property (nonatomic, strong, readwrite) CAMediaTimingFunction *timingFunction;

- (void)pushViewController:(UIViewController *)viewController withTransitionType:(YSTransitionType)transitionType;
- (UIViewController *)popViewControllerWithTransitionType:(YSTransitionType)transitionType;

@end
