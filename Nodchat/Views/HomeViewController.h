//
//  HomeViewController.h
//  Nod
//
//  Created by Csaba Toth on 06/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"

@interface HomeViewController : UIViewController <JSAnimatedImagesViewDelegate>

@property (weak, nonatomic) IBOutlet JSAnimatedImagesView *animatedImagesView;
@property (weak, nonatomic) IBOutlet UIPageControl *pgBackground;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassword;

- (IBAction)pressFacebookBtn:(id)sender;
- (IBAction)pressLoginBtn:(id)sender;
- (IBAction)pressSignUpBtn:(id)sender;

- (IBAction)pressForgotPasswordBtn:(id)sender;
@end
