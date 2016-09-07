//
//  ReplyNodDetailViewController.h
//  Nodchat
//
//  Created by Csaba Toth on 19/5/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"

@interface ReplyNodDetailViewController : UIViewController <ZLSwipeableViewDataSource,ZLSwipeableViewDelegate, UUMessageCellDelegate>

@property (assign, nonatomic) int nReplyStyle;
@property (strong, nonatomic) ChatModel *chatModel;

//Navigation View
@property (weak, nonatomic) IBOutlet UIView *viewNavigation;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

//Main View
@property (weak, nonatomic) IBOutlet UIView *viewMain;
//Card View
@property (weak, nonatomic) IBOutlet UIView *viewCard;
//Left View
@property (weak, nonatomic) IBOutlet UIView *viewLeft;
@property (weak, nonatomic) IBOutlet UIImageView *ivLeft;
@property (weak, nonatomic) IBOutlet UITextView *txtLeft;
//Right View
@property (weak, nonatomic) IBOutlet UIView *viewRight;
@property (weak, nonatomic) IBOutlet UIImageView *ivRight;
@property (weak, nonatomic) IBOutlet UITextView *txtRight;

//Swipe View
@property (weak, nonatomic) IBOutlet ZLSwipeableView *swipeableView;

//Note View
@property (weak, nonatomic) IBOutlet UIView *viewNote;
@property (weak, nonatomic) IBOutlet UIImageView *ivUploadImage;
@property (weak, nonatomic) IBOutlet UITextView *txtMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnNod;
@property (weak, nonatomic) IBOutlet UIImageView *ivIfYes;
@property (weak, nonatomic) IBOutlet UIImageView *ivIfNo;

//Buttons
@property (weak, nonatomic) IBOutlet UIButton *btnYesNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnWaitingNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnNoNumber;

@property (weak, nonatomic) IBOutlet UIButton *btnYes;
@property (weak, nonatomic) IBOutlet UIButton *btnWaiting;
@property (weak, nonatomic) IBOutlet UIButton *btnNo;

@property (weak, nonatomic) IBOutlet UIButton *btnAllComments;

//Chat TableView
@property (weak, nonatomic) IBOutlet UITableView *tvChat;


//Buttons Event
- (IBAction)pressBackBtn:(id)sender;
- (IBAction)pressNodBtn:(id)sender;
- (IBAction)pressAllComments:(id)sender;

- (IBAction)pressYesBtn:(id)sender;
- (IBAction)pressNoBtn:(id)sender;
- (IBAction)pressWaitingBtn:(id)sender;


@end
