//
//  NotificationsViewController.h
//  Nodchat
//
//  Created by Csaba Toth on 18/5/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

//Navigation View
@property (weak, nonatomic) IBOutlet UIView *viewNavigation;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;

//Main view
@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UITableView *tvList;

//Button Event
- (IBAction)pressBackBtn:(id)sender;
- (IBAction)pressPlusBtn:(id)sender;

@end
