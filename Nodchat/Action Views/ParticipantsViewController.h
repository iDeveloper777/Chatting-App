//
//  ParticipantsViewController.h
//  Nodchat
//
//  Created by Csaba Toth on 13/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"

@interface ParticipantsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

//Navigation View
@property (weak, nonatomic) IBOutlet UIView *viewNavigation;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

//Main View
@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UITableView *tvList;

//Buttons Event
- (IBAction)pressBackBtn:(id)sender;

@end
