//
//  CreateANodViewController.h
//  Nodchat
//
//  Created by Csaba Toth on 18/5/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"

@interface CreateANodViewController : UIViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate, ZLSwipeableViewDataSource, ZLSwipeableViewDelegate, UITextViewDelegate, CropImageDelegate, UINavigationControllerDelegate>

//Navigation View
@property (weak, nonatomic) IBOutlet UIView *viewNavigation;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

//Main View
@property (weak, nonatomic) IBOutlet UIView *viewMain;

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


//Input View
@property (weak, nonatomic) IBOutlet UIView *viewInput;
@property (weak, nonatomic) IBOutlet UILabel *lblTo;
@property (weak, nonatomic) IBOutlet UITextView *txtFriends;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;

//Note View
@property (weak, nonatomic) IBOutlet UIView *viewNote;
@property (weak, nonatomic) IBOutlet UIImageView *ivUploadImage;
@property (weak, nonatomic) IBOutlet UITextView *txtMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblYourNod;
@property (weak, nonatomic) IBOutlet UIButton *btnYes;
@property (weak, nonatomic) IBOutlet UIButton *btnNo;

//Time View
@property (weak, nonatomic) IBOutlet UIView *viewTime;
@property (weak, nonatomic) IBOutlet UIButton *btnUp;
@property (weak, nonatomic) IBOutlet UIButton *btnDown;
@property (weak, nonatomic) IBOutlet UILabel *lblSecond;
@property (weak, nonatomic) IBOutlet UILabel *lblSec;
@property (weak, nonatomic) IBOutlet UIImageView *ivWaiting;

@property (weak, nonatomic) IBOutlet UIButton *btnSend;


//Buttons Event
- (IBAction)pressBackBtn:(id)sender;

- (IBAction)pressPlusBtn:(id)sender;

- (IBAction)pressYesBtn:(id)sender;
- (IBAction)pressNoBtn:(id)sender;

- (IBAction)pressUpBtn:(id)sender;
- (IBAction)pressDownBtn:(id)sender;

- (IBAction)pressSendBtn:(id)sender;

@end
