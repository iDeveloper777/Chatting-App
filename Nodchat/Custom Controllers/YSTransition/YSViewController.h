//
//  YSViewController.h
//  YSTransitionExample
//
//  Created by ysakui on 2013/11/01.
//  Copyright (c) 2013年 YoshimitsuSakui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTransitionUtil.h"

@interface YSViewController : UIViewController

@property (nonatomic, assign, readwrite) CGFloat transitionDuration;
@property (nonatomic, strong, readwrite) CAMediaTimingFunction *timingFunction;

- (void)presentViewController:(UIViewController *)viewControllerToPresent
           withTransitionType:(YSTransitionType)transitionType
                   completion:(void (^)(void))completion;

- (void)dismissViewControllerWithTransitionType:(YSTransitionType)transitionType
                                     completion:(void (^)(void))completion;

@end
