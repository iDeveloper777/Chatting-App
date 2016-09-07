//
//  SignUpViewController.m
//  Nod
//
//  Created by Csaba Toth on 08/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController (){
    AppDelegate *appDelegate;
    UIStoryboard *storyboard;
    NSString *strURL;
    
    UITextField *tmpTextField;
    NSDate *birthDate;
    
    int scrollHeight;
    int scrollContentHeight;
    
    CGRect screenSize;
}

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = [AppDelegate sharedAppDelegate];
    storyboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedAppDelegate] storyboardName] bundle:nil];
    strURL = [NSString stringWithFormat:@"%@/user", API_URL];
    
    birthDate = nil;
    
    if (_isSignUp != 1) _isSignUp = 0;
    
    screenSize = [[UIScreen mainScreen] bounds];
    scrollHeight = self.scrollView.bounds.size.height;
    scrollContentHeight = scrollHeight;
    
    [self setNeedsStatusBarAppearanceUpdate];   //Status bar
    
    [self setLayout];
    
    if (_isSignUp == 1)
        [self initUserDatas];
}

//Status Bar
- (UIStatusBarStyle) preferredStatusBarStyle{
    if (_isSignUp == 1)
        return UIStatusBarStyleLightContent;
    else
        return UIStatusBarStyleDefault;
    
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark setLayout
- (void) setLayout{
    if (_isSignUp == 0){ //if Signup
        _lblTitle.hidden = YES;
        [_btnBack setBackgroundImage:[UIImage imageNamed:@"btn_Back.png"] forState:UIControlStateNormal];
        [_btnDone setBackgroundImage:[UIImage imageNamed:@"btn_Done.png"] forState:UIControlStateNormal];
        [_viewNavigation setBackgroundColor:[UIColor whiteColor]];
    }else{  //if Account
        _lblTitle.hidden = NO;
        [_btnBack setBackgroundImage:[UIImage imageNamed:@"btn_Back_white.png"] forState:UIControlStateNormal];
        [_btnDone setBackgroundImage:[UIImage imageNamed:@"btn_Done_white.png"] forState:UIControlStateNormal];
//        [_viewNavigation setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:62.0f/255.0f blue:21.0f/255.0f alpha:1.0f]];
    }
    
    self.viewDatePicker.hidden = YES;
    [self.viewDatePicker setFrame:CGRectMake(0, self.view.bounds.size.height, self.viewDatePicker.bounds.size.width, self.viewDatePicker.bounds.size.height)];
    
    self.viewNotification.hidden = YES;
    
    //--Notification View TapGesture Event--
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    singleTap.numberOfTapsRequired = 1;
    [self.viewNotification setUserInteractionEnabled:YES];
    [self.viewNotification addGestureRecognizer:singleTap];
    
    //--Tool bar in Keyboard--
    UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    doneToolbar.barStyle = UIBarStyleDefault;
    doneToolbar.tintColor = [UIColor blackColor];
    
    // I can't pass the textField as a parameter into an @selector
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelWithKeyboard:)],
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithKeyboard:)],
                         nil];
    [doneToolbar sizeToFit];

    self.tfFirstName.inputAccessoryView = doneToolbar;
    self.tfLastName.inputAccessoryView = doneToolbar;
    self.tfEmail.inputAccessoryView = doneToolbar;
    self.tfPassword.inputAccessoryView = doneToolbar;
//    self.tfDob.inputAccessoryView = doneToolbar;
    self.tfPhoneNumber.inputAccessoryView = doneToolbar;
    
    [self.tfFirstName addTarget:self action:@selector(beginEditingTextbox:) forControlEvents:UIControlEventEditingDidBegin];
    [self.tfLastName addTarget:self action:@selector(beginEditingTextbox:) forControlEvents:UIControlEventEditingDidBegin];
    [self.tfEmail addTarget:self action:@selector(beginEditingTextbox:) forControlEvents:UIControlEventEditingDidBegin];
    [self.tfPassword addTarget:self action:@selector(beginEditingTextbox:) forControlEvents:UIControlEventEditingDidBegin];
    [self.tfPhoneNumber addTarget:self action:@selector(beginEditingTextbox:) forControlEvents:UIControlEventEditingDidBegin];
    
    //Dob Event
    UITapGestureRecognizer *singleTap01 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginEditingDob)];
    singleTap01.numberOfTapsRequired = 1;
    [self.lblDob setUserInteractionEnabled:YES];
    [self.lblDob addGestureRecognizer:singleTap01];
}

#pragma mark initUserDatas
- (void) initUserDatas{
    _tfFirstName.text = appDelegate.user.fname;
    _tfLastName.text = appDelegate.user.lname;
    _tfEmail.text = appDelegate.user.email;
    _tfPassword.text = appDelegate.password;
    _tfPhoneNumber.text = appDelegate.user.phone;
    
    NSString *strYear = [appDelegate.user.dob substringToIndex:4];
    NSString *strMonth = [appDelegate.user.dob substringWithRange:NSMakeRange(5, 2)];
    NSString *strDay = [appDelegate.user.dob substringWithRange:NSMakeRange(8, 2)];
    
    _lblDob.text = [NSString stringWithFormat:@"%@-%@-%@", strDay, strMonth, strYear];
    
    if ([appDelegate.user.dob isEqualToString:@"0000-00-00"]){
        birthDate = [NSDate date];
    }else{
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.year = [strYear intValue];
        dateComponents.month = [strMonth intValue];
        dateComponents.day = [strDay intValue];
        
        birthDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    }
    
    _datePicker.date = birthDate;
}

#pragma mark - Notification View
- (void) tapGesture: (UIGestureRecognizer *) gestureRecognizer{
    [self hideNotification];
}

- (void) openNotification{
    [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.viewNotification.hidden = NO;
    }completion:^(BOOL finished){
        
    }];
}

- (void) hideNotification{
    [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewNotification.hidden = YES;
    }completion:^(BOOL finished){
        
    }];
}

#pragma mark - Buttons Event
- (IBAction)pressBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressCancelBtn:(id)sender {
    [self hideNotification];
}

- (IBAction)pressContinueBtn:(id)sender {
    [self hideNotification];
    
}

- (IBAction)pressPrivacyBtn:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.yahoo.com/"]];
}

- (IBAction)pressTermsBtn:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.google.co.uk/"]];
}

- (IBAction)pressDoneBtn:(id)sender {
   
    if ([self isValidData] && _isSignUp == 0){ //Sign Up
        strURL = [NSString stringWithFormat:@"%@/user", API_URL];
        
        NSString *strDate;
        if (birthDate != nil){
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"dd.MM.yyyy"];
            strDate = [format stringFromDate:birthDate];
        }else{
            strDate = @"";
        }
        
        [SVProgressHUD showWithStatus:@"Loading..."];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        ASIFormDataRequest *request =[[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:strURL]];
        request.delegate=self;
        
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        [request setRequestMethod:@"POST"];
        
        [request setPostValue:self.tfFirstName.text forKey:@"fname"];
        [request setPostValue:self.tfLastName.text forKey:@"lname"];
        [request setPostValue:self.tfEmail.text forKey:@"email"];
        [request setPostValue:self.tfPhoneNumber.text forKey:@"phone"];
        [request setPostValue:strDate forKey:@"dob"];
//        [request setPostValue:[[ExtendFunctions alloc] generateSHA1:self.tfPassword.text] forKey:@"password"];
        [request setPostValue:self.tfPassword.text forKey:@"password"];
    
//        NSLog(@"%@",[[ExtendFunctions alloc] generateSHA1:@"password"]);
        
        request.tag = 100;
        [request startAsynchronous];
        
    }

    if ([self isValidData] && _isSignUp == 1){ //
        strURL = [NSString stringWithFormat:@"%@/user/profile", API_URL];
        
        NSString *strDate;
        if (birthDate != nil){
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"dd.MM.yyyy"];
            strDate = [format stringFromDate:birthDate];
        }else{
            strDate = @"";
        }
        
        [SVProgressHUD showWithStatus:@"Loading..."];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        ASIFormDataRequest *request =[[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:strURL]];
        request.delegate=self;
        
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        [request setRequestMethod:@"POST"];
        
        [request setPostValue:appDelegate.ssid forKey:@"ssid"];
        [request setPostValue:self.tfFirstName.text forKey:@"fname"];
        [request setPostValue:self.tfLastName.text forKey:@"lname"];
        [request setPostValue:self.tfEmail.text forKey:@"email"];
        [request setPostValue:self.tfPhoneNumber.text forKey:@"phone"];
        [request setPostValue:strDate forKey:@"dob"];
//        [request setPostValue:self.tfPassword.text forKey:@"password"];
        
        request.tag = 200;
        [request startAsynchronous];
        
    }
}

#pragma mark getUserInfo
- (void) getUserInfo{
    strURL = [NSString stringWithFormat:@"%@/user/profile?ssid=%@", API_URL, appDelegate.ssid];
    
    ASIFormDataRequest *request =[[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:strURL]];
    request.delegate=self;
    
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"GET"];
    
    request.tag = 300;
    [request startAsynchronous];
    
}

#pragma mark - HTTP Post Request
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:request.responseData
                                                         options:kNilOptions
                                                           error:&error];
    if (request.tag == 100){
        if([json objectForKey:@"id"] != nil){
            appDelegate.ssid = [json objectForKey:@"ssid"];
            [self getUserInfo];
        }else{
            [SVProgressHUD dismiss];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [self openNotification];
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[json objectForKey:@"message"] delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil];
//            [alertView show];
        }
    }else if (request.tag == 200){
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        if([json objectForKey:@"success"] != nil){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self openNotification];
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[json objectForKey:@"message"] delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil];
//            [alertView show];
        }
    }else if (request.tag == 300){
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        if([json objectForKey:@"id"] != nil){
            appDelegate.user = [[UserModel alloc] initUserWithDic:json];
            
            FindContactsViewController *viewController = (FindContactsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FindContactsView"];
            viewController.isLogin = 0;
            //        NodViewController *viewController = (NodViewController *)[storyboard instantiateViewControllerWithIdentifier:@"NodView"];
            [self.navigationController pushViewController:viewController animated:TRUE];
            
        }else if ([json objectForKey:@"status"] != nil){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[json objectForKey:@"message"] delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[json objectForKey:@"message"] delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }    
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot connect to server" delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil];
    [alertView show];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}

- (BOOL) beginEditingTextbox:(UITextField *)textField{
    tmpTextField = textField;
    [self.scrollView setContentOffset:CGPointMake(0, [self getStateEdit:textField])];
    
    return TRUE;
}

- (float)getStateEdit:(UITextField *)textField {
    if (textField.superview.frame.origin.y + textField.frame.origin.y + self.scrollView.frame.origin.y > self.scrollView.frame.size.height - 250 ) {
        return textField.superview.frame.origin.y + textField.frame.origin.y + self.scrollView.frame.origin.y - 200;
    } else {
        return 0;
    }
}

#pragma mark -
#pragma mark Keyboard Events
- (IBAction) doneWithKeyboard:(id) sender{
    [tmpTextField resignFirstResponder];
}

- (IBAction) cancelWithKeyboard:(id) sender{
    [tmpTextField resignFirstResponder];
}

#pragma mark UIKeyboard Notification

// Called when the UIKeyboardDidShowNotification is received
- (void)keyboardWasShown:(NSNotification *)aNotification
{
    // keyboard frame is in window coordinates
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect keyboardInfoFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // get the height of the keyboard by taking into account the orientation of the device too
    CGRect windowFrame = [self.view.window convertRect:self.view.frame fromView:self.view];
    CGRect keyboardFrame = CGRectIntersection (windowFrame, keyboardInfoFrame);
    //    CGRect coveredFrame = [self.view.window convertRect:keyboardFrame toView:self.view];
    
    // make sure the scrollview content size width and height are greater than 0
    [self.scrollView setContentSize:CGSizeMake (self.scrollView.contentSize.width, scrollContentHeight)];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.viewMain.bounds.size.width, scrollHeight)];
    
    CGRect rect = CGRectMake(0, self.scrollView.frame.origin.y, self.scrollView.bounds.size.width, scrollHeight - keyboardFrame.size.height);
    [self.scrollView setFrame:rect];
    
}

// Called when the UIKeyboardWillHideNotification is received
- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    [self.scrollView setContentSize:CGSizeMake (self.scrollView.contentSize.width, scrollContentHeight)];
    [self.viewMain setFrame:CGRectMake(0, 0, self.viewMain.bounds.size.width, scrollHeight)];
    
    [self.scrollView setFrame:CGRectMake(screenSize.origin.x, self.scrollView.frame.origin.y, screenSize.size.width, scrollHeight)];
}


#pragma mark - isValidData
- (BOOL) isValidData{
    //First Name
    if (self.tfFirstName.text == nil || [self.tfFirstName.text isEqualToString:@""]){
        [self.txtAlert setText:@"First Name is required."];
        [self.txtAlert setFont:[UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:12.0]];
        [self.txtAlert setTextColor:[UIColor colorWithRed:169.0/255.0 green:0.0 blue:0.0 alpha:1.0]];
        return FALSE;
    }
    
    //Last Name
    if (self.tfLastName.text == nil || [self.tfLastName.text isEqualToString:@""]){
        [self.txtAlert setText:@"Last Name is required."];
        [self.txtAlert setFont:[UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:12.0]];
        [self.txtAlert setTextColor:[UIColor colorWithRed:169.0/255.0 green:0.0 blue:0.0 alpha:1.0]];
        return FALSE;
    }
    
    //Email
    if (self.tfEmail.text == nil || [self.tfEmail.text isEqualToString:@""]){
        [self.txtAlert setText:@"Email address is required."];
        [self.txtAlert setFont:[UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:12.0]];
        [self.txtAlert setTextColor:[UIColor colorWithRed:169.0/255.0 green:0.0 blue:0.0 alpha:1.0]];
        return FALSE;
    }
    
    //Password
    if (self.tfPassword.text == nil || [self.tfPassword.text isEqualToString:@""]){
        [self.txtAlert setText:@"Password is required."];
        [self.txtAlert setFont:[UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:12.0]];
        [self.txtAlert setTextColor:[UIColor colorWithRed:169.0/255.0 green:0.0 blue:0.0 alpha:1.0]];
        return FALSE;
    }
    
    if (self.tfPassword.text.length < 4){
        [self.txtAlert setText:@"Password is required at least 5 characters."];
        [self.txtAlert setFont:[UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:12.0]];
        [self.txtAlert setTextColor:[UIColor colorWithRed:169.0/255.0 green:0.0 blue:0.0 alpha:1.0]];
        return FALSE;
    }
    
    //Dob
    if (self.lblDob.text == nil || [self.lblDob.text isEqualToString:@""] || [self.lblDob.text isEqualToString:@"--/--/----"]){
        [self.txtAlert setText:@"Date of birthday is required."];
        [self.txtAlert setFont:[UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:12.0]];
        [self.txtAlert setTextColor:[UIColor colorWithRed:169.0/255.0 green:0.0 blue:0.0 alpha:1.0]];
        return FALSE;
    }
    
    //Phone
    if (self.tfPhoneNumber.text == nil || [self.tfPhoneNumber.text isEqualToString:@""]){
        [self.txtAlert setText:@"Phone number is required."];
        [self.txtAlert setFont:[UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:12.0]];
        [self.txtAlert setTextColor:[UIColor colorWithRed:169.0/255.0 green:0.0 blue:0.0 alpha:1.0]];
        return FALSE;
    }
    
    // confirm email type
    if (![self isValidEmail:self.tfEmail.text Strict:YES]) {
        self.txtAlert.text = @"Incorrect Email Address! Please input Email Address again.";
        [self.txtAlert setFont:[UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:12.0]];
        [self.txtAlert setTextColor:[UIColor colorWithRed:169.0/255.0 green:0.0 blue:0.0 alpha:1.0]];
        
        return FALSE;
    }
    
    //is Success
    self.txtAlert.text = @"";
    [self.txtAlert setFont:[UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:12.0]];
    [self.txtAlert setTextColor:[UIColor colorWithRed:169.0/255.0 green:0.0 blue:0.0 alpha:1.0]];
    
    return TRUE;
}

#pragma mark Confirm Email
-(BOOL) isValidEmail:(NSString *)emailString Strict:(BOOL)strictFilter{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = strictFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailString];
}

#pragma mark - beginEditingDob
- (void) beginEditingDob{
    if (tmpTextField != nil)
        [tmpTextField resignFirstResponder];
    
    [self openDatePicker];
}

#pragma mark DatePickerView Event
- (IBAction)actionCancel:(id)sender {
    [self hideDatePicker];
}

- (IBAction)actionDone:(id)sender {
    [self hideDatePicker];
    
    NSDate *myDate = [self.datePicker date];
    birthDate = myDate;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyyy"];
    
    NSString *strDate = [format stringFromDate:myDate];
    
    self.lblDob.text = strDate;
    self.lblDob.textColor = [UIColor blackColor];
}

#pragma mark DatePicker
- (void) openDatePicker{
    self.viewDatePicker.hidden = NO;
    
    [UIView animateWithDuration:0.3 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
        [self.viewDatePicker setFrame:CGRectMake(0, self.view.bounds.size.height-self.viewDatePicker.bounds.size.height, self.viewDatePicker.bounds.size.width, self.viewDatePicker.bounds.size.height)];
    }
    completion:^(BOOL finished){
        int nOffsetYPosition = 0;
        if (_lblDob.superview.frame.origin.y + _lblDob.frame.origin.y + self.scrollView.frame.origin.y > self.scrollView.frame.size.height - 250 ) {
            nOffsetYPosition = _lblDob.superview.frame.origin.y + _lblDob.frame.origin.y + self.scrollView.frame.origin.y - 200;
        } else {
            nOffsetYPosition = 0;
        }
        [self.scrollView setContentOffset:CGPointMake(0, nOffsetYPosition)];
        
        // make sure the scrollview content size width and height are greater than 0
        [self.scrollView setContentSize:CGSizeMake (self.scrollView.contentSize.width, scrollContentHeight)];
        
        [self.viewMain setFrame:CGRectMake(0, 0, self.viewMain.bounds.size.width, scrollHeight)];
        
        CGRect rect = CGRectMake(0, self.scrollView.frame.origin.y, self.scrollView.bounds.size.width, scrollHeight - self.viewDatePicker.bounds.size.height);
        [self.scrollView setFrame:rect];
    }];
    
    
}

- (void) hideDatePicker{
    [UIView animateWithDuration:0.3 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
        [self.viewDatePicker setFrame:CGRectMake(0, self.view.bounds.size.height, self.viewDatePicker.bounds.size.width, self.viewDatePicker.bounds.size.height)];
    }
                     completion:^(BOOL finished){
                         self.viewDatePicker.hidden = YES;
                     }];
    
    [self.scrollView setContentSize:CGSizeMake (self.scrollView.contentSize.width, scrollContentHeight)];
    [self.viewMain setFrame:CGRectMake(0, 0, self.viewMain.bounds.size.width, scrollHeight)];
    
    [self.scrollView setFrame:CGRectMake(screenSize.origin.x, self.scrollView.frame.origin.y, screenSize.size.width, scrollHeight)];
}

@end
