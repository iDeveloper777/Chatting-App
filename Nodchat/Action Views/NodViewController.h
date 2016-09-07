//
//  NodViewController.h
//  Nodchat
//
//  Created by Csaba Toth on 12/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"

@class NodModel;

@interface NodViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

//Navigation View
@property (weak, nonatomic) IBOutlet UIView *viewNavigation;

@property (weak, nonatomic) IBOutlet UIButton *btnSettings;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;

@property (weak, nonatomic) IBOutlet UIImageView *ivNoNodsYet;

//Main view
@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UITableView *tvList;
@property (weak, nonatomic) IBOutlet UIButton *btnInbox;
@property (weak, nonatomic) IBOutlet UIButton *btnSent;

//Buttons Event
- (IBAction)pressSettingsBtn:(id)sender;
- (IBAction)pressMoreBtn:(id)sender;


- (IBAction)pressInboxBtn:(id)sender;
- (IBAction)pressSentBtn:(id)sender;
@end
