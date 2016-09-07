//
//  WalkthroughViewController.h
//  Nodchat
//
//  Created by Csaba Toth on 18/5/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"

@interface WalkthroughViewController : UIViewController <JSAnimatedImagesViewDelegate>

@property (weak, nonatomic) IBOutlet JSAnimatedImagesView *animatedImagesView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *pgBackground;

- (IBAction)pressGetStartedButton:(id)sender;

@end
