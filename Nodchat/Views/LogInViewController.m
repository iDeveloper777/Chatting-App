//
//  LogInViewController.m
//  Nod
//
//  Created by Csaba Toth on 06/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController (){
    AppDelegate *appDelegate;
    UIStoryboard *storyboard;
    
    UITextField *tmpTextField;
    NSString *strURL;
}

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];   //Status bar
    
    appDelegate = [AppDelegate sharedAppDelegate];
    storyboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedAppDelegate] storyboardName] bundle:nil];
    
    [self setLayout];
}

//Status Bar
- (UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark setLayout
- (void) setLayout{
    //Facebook button hidden
    _btnFacebook.hidden = YES;
    
//    _tfUsername.text = @"csabatoth0218@hotmail.com";
//    _tfPassword.text = @"password";
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
    
    self.tfUsername.inputAccessoryView = doneToolbar;
    self.tfPassword.inputAccessoryView = doneToolbar;
    
    [self.tfUsername addTarget:self action:@selector(beginEditingTextbox:) forControlEvents:UIControlEventEditingDidBegin];
    [self.tfPassword addTarget:self action:@selector(beginEditingTextbox:) forControlEvents:UIControlEventEditingDidBegin];
}

#pragma mark Buttons Event
- (IBAction)pressBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressLogInBtn:(id)sender {
    strURL = [NSString stringWithFormat:@"%@/user/login", API_URL];
    
    if ([self isValidData]){
        
        [SVProgressHUD showWithStatus:@"Loading..."];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        ASIFormDataRequest *request =[[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:strURL]];
        request.delegate=self;
        
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        [request setRequestMethod:@"POST"];
        
        [request setPostValue:self.tfUsername.text forKey:@"email"];
        [request setPostValue:self.tfPassword.text forKey:@"password"];
        
        if (appDelegate.deviceToken != nil && ![appDelegate.deviceToken isEqualToString:@""])
            [request setPostValue:appDelegate.deviceToken forKey:@"deviceToken"];
        
//        [request setPostValue:[[ExtendFunctions alloc] generateSHA1:self.tfPassword.text] forKey:@"password"];
//        NSLog(@"%@",[[ExtendFunctions alloc] generateSHA1:@"password"]);
        
        request.tag = 100;
        [request startAsynchronous];
    }
}

- (IBAction)pressForgotPasswordBtn:(id)sender {
    YSTransitionType pushSubtype;

    ForgotPasswordViewController *tpViewController = [storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordView"];
    
    pushSubtype = YSTransitionTypeFromBottom;
    [(YSNavigationController *)self.navigationController pushViewController:tpViewController withTransitionType:pushSubtype];
}

- (IBAction)pressFacebookBtn:(id)sender {
    if ([FBSDKAccessToken currentAccessToken]){
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error && result) {
                 appDelegate.facebookEmail = [result objectForKey:@"email"];
                 appDelegate.facebookFName = [result objectForKey:@"first_name"];
                 appDelegate.facebookLName = [result objectForKey:@"last_name"];
                 appDelegate.facebookPhoto = [NSString stringWithFormat:@"%@%@%@",@"http://graph.facebook.com/", [result objectForKey:@"id"] ,@"/picture?type=square"];
                 [self getFBResult];
             }
         }];
    }
    else{
        [FBSDKAccessToken setCurrentAccessToken:nil];
        //        appDelegate.isFacebookLogin = 1;
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
        
        [login logInWithReadPermissions:@[@"email", @"public_profile"] handler:^(FBSDKLoginManagerLoginResult *log_result, NSError *error) {
            if (error) {
                // Process error
            } else if (log_result.isCancelled) {
                // Handle cancellations
            } else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                if ([log_result.grantedPermissions containsObject:@"email"]) {
                    if ([FBSDKAccessToken currentAccessToken]){
                        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                             if (!error && result) {
                                 appDelegate.facebookEmail = [result objectForKey:@"email"];
                                 appDelegate.facebookFName = [result objectForKey:@"first_name"];
                                 appDelegate.facebookLName = [result objectForKey:@"last_name"];
                                 appDelegate.facebookPhoto = [NSString stringWithFormat:@"%@%@%@",@"http://graph.facebook.com/", [result objectForKey:@"id"] ,@"/picture?type=square"];
                                 [self getFBResult];
                             }
                         }];
                    }
                }
            }
        }];
    }
}

#pragma mark - getFBResult
- (void) getFBResult{
    FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
    NSString *strUserID = token.userID;
    appDelegate.facebookID = strUserID;
    
    NSString *strChecksum = [NSString stringWithFormat:@"%@%@%@", strChecksum01, appDelegate.facebookID, strChecksum02];
    
    strURL = [NSString stringWithFormat:@"%@/user/facebook", API_URL];
    [SVProgressHUD showWithStatus:@"Loading..."];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    ASIFormDataRequest *request =[[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:strURL]];
    request.delegate=self;
    
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"POST"];
    
    [request setPostValue:appDelegate.facebookID forKey:@"serviceId"];
    [request setPostValue:[[ExtendFunctions alloc] generateSHA256:strChecksum] forKey:@"checksum"];
    [request setPostValue:appDelegate.facebookFName forKey:@"fname"];
    [request setPostValue:appDelegate.facebookLName forKey:@"lname"];
    [request setPostValue:appDelegate.facebookEmail forKey:@"email"];
//    [request setPostValue:appDelegate.facebookPhoto forKey:@"avatarImage"];
    
    request.tag = 200;
    [request startAsynchronous];
}

#pragma mark - HTTP Post Request
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:request.responseData
                                                         options:kNilOptions
                                                           error:&error];
    //Login
    if (request.tag == 100){
        if([json objectForKey:@"ssid"] != nil){
            appDelegate.email = _tfUsername.text;
            appDelegate.password = _tfPassword.text;
            appDelegate.ssid = [json objectForKey:@"ssid"];
            NSLog(@"%@", appDelegate.ssid);
            
            [self getUserInfo];
        }else if ([json objectForKey:@"status"] != nil){
            [SVProgressHUD dismiss];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[json objectForKey:@"message"] delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil] show];
        }else{
            [SVProgressHUD dismiss];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[json objectForKey:@"message"] delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil] show];
        }
    }else if (request.tag == 200){//facebook
        if([json objectForKey:@"ssid"] != nil){
            appDelegate.email = _tfUsername.text;
            appDelegate.password = _tfPassword.text;
            appDelegate.ssid = [json objectForKey:@"ssid"];
            NSLog(@"%@", appDelegate.ssid);
            
            [self getUserInfo];
        }else if ([json objectForKey:@"status"] != nil){
            [SVProgressHUD dismiss];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[json objectForKey:@"message"] delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil] show];
        }else{
            [SVProgressHUD dismiss];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[json objectForKey:@"message"] delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil] show];
        }
    }else if (request.tag == 300){ //Get User Info
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        if([json objectForKey:@"id"] != nil){
            appDelegate.user = [[UserModel alloc] initUserWithDic:json];
            
            FindContactsViewController *viewController = (FindContactsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FindContactsView"];
            viewController.isLogin = 0;
            //        NodViewController *viewController = (NodViewController *)[storyboard instantiateViewControllerWithIdentifier:@"NodView"];
            [self.navigationController pushViewController:viewController animated:TRUE];
            
        }else if ([json objectForKey:@"status"] != nil){
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[json objectForKey:@"message"] delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil] show];
        }else{
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[json objectForKey:@"message"] delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil] show];
        }
    }

}

- (void)requestFailed:(ASIHTTPRequest *)request{
    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot connect to server" delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil] show];
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

#pragma mark - Keyboard Events
- (IBAction) doneWithKeyboard:(id) sender{
    [tmpTextField resignFirstResponder];
    [_viewMain setFrame:CGRectMake(0, 64, _viewMain.bounds.size.width, _viewMain.bounds.size.height)];
}

- (IBAction) cancelWithKeyboard:(id) sender{
    [tmpTextField resignFirstResponder];
    [_viewMain setFrame:CGRectMake(0, 64, _viewMain.bounds.size.width, _viewMain.bounds.size.height)];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_viewMain setFrame:CGRectMake(0, 64, _viewMain.bounds.size.width, _viewMain.bounds.size.height)];
    [textField resignFirstResponder];
    return  YES;
}

- (BOOL) beginEditingTextbox:(UITextField *)textField{
    tmpTextField = textField;
    
    if (textField.tag == 100){
        [_viewMain setFrame:CGRectMake(0, 64-50-(_tfPassword.frame.origin.y-_tfUsername.frame.origin.y), _viewMain.bounds.size.width, _viewMain.bounds.size.height)];
    }else{
        [_viewMain setFrame:CGRectMake(0, 64-(_tfPassword.frame.origin.y-_tfUsername.frame.origin.y), _viewMain.bounds.size.width, _viewMain.bounds.size.height)];
    }
    
    return TRUE;
}

#pragma mark isValidData
- (BOOL) isValidData{
    if (self.tfUsername.text == nil || [self.tfUsername.text isEqualToString:@""]){
        [self.txtAlert setText:@"Username is required."];
        [self.txtAlert setFont:[UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:12.0]];
        [self.txtAlert setTextColor:[UIColor colorWithRed:169.0/255.0 green:0.0 blue:0.0 alpha:1.0]];
        return FALSE;
    }
    
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

@end
