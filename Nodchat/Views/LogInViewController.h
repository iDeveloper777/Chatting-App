//
//  LogInViewController.h
//  Nod
//
//  Created by Csaba Toth on 06/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"

@interface LogInViewController : UIViewController <ASIHTTPRequestDelegate>

//Main View
@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UITextField *tfUsername;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;

@property (weak, nonatomic) IBOutlet UITextView *txtAlert;

@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;

//Buttons Event
- (IBAction)pressBackBtn:(id)sender;

- (IBAction)pressLogInBtn:(id)sender;
- (IBAction)pressForgotPasswordBtn:(id)sender;
- (IBAction)pressFacebookBtn:(id)sender;

@end
