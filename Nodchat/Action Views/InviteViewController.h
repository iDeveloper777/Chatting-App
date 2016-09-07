//
//  InviteViewController.h
//  Nodchat
//
//  Created by Csaba Toth on 12/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"

@class UserModel;
@class InviteModel;

@interface InviteViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ABPeoplePickerNavigationControllerDelegate, ASIHTTPRequestDelegate>

//Navigation view
@property (weak, nonatomic) IBOutlet UIView *viewNavigation;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;

//Main view
@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UITableView *tvInviteList;

//Notification and Alert View
@property (weak, nonatomic) IBOutlet UIView *viewNotification;
@property (weak, nonatomic) IBOutlet UIView *viewAlert;
@property (weak, nonatomic) IBOutlet UITextView *txtMessage;

//Button Event
- (IBAction)pressBackBtn:(id)sender;
- (IBAction)pressPlusBtn:(id)sender;

- (IBAction)pressCancelBtn:(id)sender;
- (IBAction)pressContinueBtn:(id)sender;

@end
