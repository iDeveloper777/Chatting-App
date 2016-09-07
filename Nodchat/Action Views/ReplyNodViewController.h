//
//  ReplyNodViewController.h
//  Nodchat
//
//  Created by Csaba Toth on 12/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"

@interface ReplyNodViewController : UIViewController <ZLSwipeableViewDataSource, ZLSwipeableViewDelegate>

@property (strong, nonatomic) NSString *strTitle;
//Navigation View
@property (weak, nonatomic) IBOutlet UIView *viewNavigation;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;


//Main View
@property (weak, nonatomic) IBOutlet UIView *viewMain;

//Note View
@property (weak, nonatomic) IBOutlet UIView *viewNote;
@property (weak, nonatomic) IBOutlet UIImageView *ivNote;
@property (weak, nonatomic) IBOutlet UITextView *txtNote;

@property (weak, nonatomic) IBOutlet ZLSwipeableView *swipeableView;

@property (weak, nonatomic) IBOutlet UIButton *btnNo;
@property (weak, nonatomic) IBOutlet UIButton *btnYes;

//Time View
@property (weak, nonatomic) IBOutlet UIView *viewTime;
@property (weak, nonatomic) IBOutlet UIImageView *ivTimeBg;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblSecond;
@property (weak, nonatomic) IBOutlet UILabel *lblMiSecond;

@property (weak, nonatomic) IBOutlet CERoundProgressView *viewAnimation;

//Buttons Event
- (IBAction)pressBackBtn:(id)sender;

- (IBAction)pressYesBtn:(id)sender;
- (IBAction)pressNoBtn:(id)sender;

@end
