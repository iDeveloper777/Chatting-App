//
//  FindContactsViewController.h
//  Nodchat
//
//  Created by Csaba Toth on 11/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"

@interface FindContactsViewController : UIViewController

@property (assign, nonatomic) int isLogin;

//Buttons Event
- (IBAction)pressFacebookBtn:(id)sender;
- (IBAction)pressContactsBtn:(id)sender;
- (IBAction)pressSkipBtn:(id)sender;
@end
