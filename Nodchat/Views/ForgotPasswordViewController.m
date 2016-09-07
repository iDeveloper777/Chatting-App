//
//  ForgotPasswordViewController.m
//  Nodchat
//
//  Created by Csaba Toth on 11/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController (){
    NSString *strURL;
    
    UITextField *tmpTextField;
}

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNeedsStatusBarAppearanceUpdate];   //Status bar
    
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
    
    self.tfEmail.inputAccessoryView = doneToolbar;
    
    [self.tfEmail addTarget:self action:@selector(beginEditingTextbox:) forControlEvents:UIControlEventEditingDidBegin];
}

#pragma mark Buttons Event
- (IBAction)pressBackBtn:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    
    [(YSNavigationController *)self.navigationController popViewControllerWithTransitionType:YSTransitionTypeFromTop];
}

- (IBAction)pressSendEmailBtn:(id)sender {
    strURL = [NSString stringWithFormat:@"%@/user/forgot-password", API_URL];
    
    if ([self isValidData]){
        [SVProgressHUD showWithStatus:@"Loading..."];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        ASIFormDataRequest *request =[[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:strURL]];
        request.delegate=self;
        
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        [request setRequestMethod:@"POST"];
        
        [request setPostValue:self.tfEmail.text forKey:@"email"];
       
        [request startAsynchronous];
    }
}

#pragma mark - HTTP Post Request
-(void)requestFinished:(ASIHTTPRequest *)request
{
    
    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:request.responseData
                                                         options:kNilOptions
                                                           error:&error];
    
    if([json objectForKey:@"success"] != nil){
        NSString *status = [json objectForKey:@"success"];
        
        if ([status isEqualToString:@"true"]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your request was sent successfully." delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your request was failed." delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }else if ([json objectForKey:@"status"] != nil){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your request was failed." delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot connect to server" delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot connect to server" delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil];
    [alertView show];
}


#pragma mark - isValidData
- (BOOL) isValidData{
    if (self.tfEmail.text == nil || [self.tfEmail.text isEqualToString:@""]){
        [self.txtAlert setText:@"Email address is required."];
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

#pragma mark Keyboard Events
- (IBAction) doneWithKeyboard:(id) sender{
    [tmpTextField resignFirstResponder];
}

- (IBAction) cancelWithKeyboard:(id) sender{
    [tmpTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}

- (BOOL) beginEditingTextbox:(UITextField *)textField{
    tmpTextField = textField;
    
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
