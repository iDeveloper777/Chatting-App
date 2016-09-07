//
//  SettingsViewController.h
//  Nodchat
//
//  Created by Csaba Toth on 13/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"

@interface SettingsViewController : UIViewController

//Navigation View
@property (weak, nonatomic) IBOutlet UIView *viewNavigation;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

//Main View
@property (weak, nonatomic) IBOutlet UIView *viewMain;

@property (weak, nonatomic) IBOutlet UIImageView *ivProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

//Buttons
@property (weak, nonatomic) IBOutlet UIButton *btnAccount;
@property (weak, nonatomic) IBOutlet UIButton *btnNotifications;
@property (weak, nonatomic) IBOutlet UIButton *btnTellAFriend;
@property (weak, nonatomic) IBOutlet UIButton *btnAboutUs;

//Buttons Event
- (IBAction)pressBackBtn:(id)sender;

- (IBAction)pressAccountBtn:(id)sender;
- (IBAction)pressNotificationsBtn:(id)sender;
- (IBAction)pressTellAFriendBtn:(id)sender;
- (IBAction)pressAboutUSBtn:(id)sender;


@end
