//
//  SignUpViewController.h
//  Nod
//
//  Created by Csaba Toth on 08/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"

@interface SignUpViewController : UIViewController

//isSignup or Account
@property (assign, nonatomic) int isSignUp;

//Navigation View
@property (weak, nonatomic) IBOutlet UIView *viewNavigation;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *viewMain;

//Text Fields
@property (weak, nonatomic) IBOutlet UITextField *tfFirstName;
@property (weak, nonatomic) IBOutlet UITextField *tfLastName;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
//@property (weak, nonatomic) IBOutlet UITextField *tfDob;
@property (weak, nonatomic) IBOutlet UITextField *tfPhoneNumber;

@property (weak, nonatomic) IBOutlet UILabel *lblDob;

@property (weak, nonatomic) IBOutlet UITextView *txtAlert;

//Date PickerView
@property (weak, nonatomic) IBOutlet UIView *viewDatePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbarCancelDone;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

//Notification and Alert View
@property (weak, nonatomic) IBOutlet UIView *viewNotification;
@property (weak, nonatomic) IBOutlet UIView *viewAlert;

//Buttons Event
- (IBAction)pressBackBtn:(id)sender;
- (IBAction)pressDoneBtn:(id)sender;
- (IBAction)pressCancelBtn:(id)sender;
- (IBAction)pressContinueBtn:(id)sender;
- (IBAction)pressPrivacyBtn:(id)sender;
- (IBAction)pressTermsBtn:(id)sender;

//Date PickerView Events
- (IBAction)actionCancel:(id)sender;
- (IBAction)actionDone:(id)sender;


@end
