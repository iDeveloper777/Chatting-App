//
//  FindFriendsViewController.h
//  Nodchat
//
//  Created by Csaba Toth on 11/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"

@interface FindFriendsViewController : UIViewController

@property (assign, nonatomic) int isLogin;

//Buttons Event
- (IBAction)pressFindfriendsBtn:(id)sender;
- (IBAction)pressSkipBtn:(id)sender;
@end
