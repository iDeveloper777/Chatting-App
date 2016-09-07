//
//  YSTransitionUtil.m
//  YSTransitionExample
//
//  Created by ysakui on 2013/11/01.
//  Copyright (c) 2013年 YoshimitsuSakui. All rights reserved.
//

#import "YSTransitionUtil.h"

@implementation YSTransitionUtil

+ (UIImage *)getCaptureOfView:(UIView *)view {
    CGSize imageSize = view.bounds.size;
    
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillRect(context, CGRectMake(0, 0, imageSize.width/2, imageSize.height/2));
    
    [view.layer renderInContext:context];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return viewImage;
}

@end
