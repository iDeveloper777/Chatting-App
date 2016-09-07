//
//  FindUsersViewController.h
//  Nodchat
//
//  Created by Csaba Toth on 13/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"

@class UserModel;

@interface FindUsersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate>

//Navigation View
@property (weak, nonatomic) IBOutlet UIView *viewNavigation;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

//MainView
@property (weak, nonatomic) IBOutlet UIView *viewMain;

//Search View
@property (weak, nonatomic) IBOutlet UIView *viewSearch;
@property (weak, nonatomic) IBOutlet UIImageView *ivSearchIcon;
@property (weak, nonatomic) IBOutlet UITextField *tfUserName;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;

@property (weak, nonatomic) IBOutlet UITableView *tvList;

//Buttons Event
- (IBAction)pressBackBtn:(id)sender;
- (IBAction)pressCloseBtn:(id)sender;

@end
