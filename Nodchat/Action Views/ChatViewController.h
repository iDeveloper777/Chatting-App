//
//  ChatViewController.h
//  Nodchat
//
//  Created by Csaba Toth on 19/5/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"
#import "UUInputFunctionView.h"

@interface ChatViewController : UIViewController 

@property (strong, nonatomic) ChatModel *chatModel;

//Navigation View
@property (weak, nonatomic) IBOutlet UIView *viewNavigation;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@property (weak, nonatomic) IBOutlet UIView *viewMain;

//Chat TableView
@property (weak, nonatomic) IBOutlet UITableView *tvChat;

//Buttons Event
- (IBAction)pressBackBtn:(id)sender;

@end
