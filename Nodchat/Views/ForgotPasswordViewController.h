//
//  ForgotPasswordViewController.h
//  Nodchat
//
//  Created by Csaba Toth on 11/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"

@interface ForgotPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextView *txtAlert;

- (IBAction)pressBackBtn:(id)sender;
- (IBAction)pressSendEmailBtn:(id)sender;
@end
