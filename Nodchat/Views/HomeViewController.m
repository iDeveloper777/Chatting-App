//
//  HomeViewController.m
//  Nod
//
//  Created by Csaba Toth on 06/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController (){
    int nBackgroundIndex;
    NSArray *arrBackgroundImages;
    
    UIStoryboard *storyboard;
    AppDelegate *appDelegate;
    
    NSString *strURL;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self setNeedsStatusBarAppearanceUpdate];   //Status bar
    
    self.animatedImagesView.hidden = YES;
    self.animatedImagesView.delegate = self;
    arrBackgroundImages = [NSArray arrayWithObjects:@"img_home_bg01.png", @"img_home_bg02.png", @"img_home_bg03", nil];
    nBackgroundIndex = 0;
    
    storyboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedAppDelegate] storyboardName] bundle:nil];
    appDelegate = [AppDelegate sharedAppDelegate];
    [appDelegate initAllDatas];
    
    [self setLayout];
}

- (UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.animatedImagesView startAnimating];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.animatedImagesView stopAnimating];
}

#pragma mark setLayout
- (void) setLayout{
    _pgBackground.hidden = YES;
    _btnForgotPassword.hidden = YES;
}

#pragma mark - JSAnimatedImagesViewDelegate Methods
- (NSUInteger)animatedImagesNumberOfImages:(JSAnimatedImagesView *)animatedImagesView
{
    return 3;
}

- (UIImage *)animatedImagesView:(JSAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index
{
    [self.pgBackground setCurrentPage:nBackgroundIndex];
    
    UIImage *image = [UIImage imageNamed:[arrBackgroundImages objectAtIndex:nBackgroundIndex]];
    nBackgroundIndex ++;
    nBackgroundIndex = nBackgroundIndex % 3;
    return image;
}

- (IBAction)pressLoginBtn:(id)sender {
//    LogInViewController *viewController = (LogInViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LogInView"];
//    [self.navigationController pushViewController:viewController animated:TRUE];
}

- (IBAction)pressSignUpBtn:(id)sender {
//    SignUpViewController *viewController = (SignUpViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SignUpView"];
//    [self.navigationController pushViewController:viewController animated:TRUE];
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
    [request setPostValue:@"0000" forKey:@"password"];
    [request setPostValue:appDelegate.facebookPhoto forKey:@"avatarImage"];
    
    request.tag = 100;
    [request startAsynchronous];
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
    if (request.tag == 100){//facebook
        if([json objectForKey:@"ssid"] != nil){
            appDelegate.ssid = [json objectForKey:@"ssid"];
            [self getUserInfo];
            NSLog(@"%@", appDelegate.ssid);
        }else if ([json objectForKey:@"status"] != nil){
            [SVProgressHUD dismiss];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[json objectForKey:@"message"] delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil] show];
        }else{
            [SVProgressHUD dismiss];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[json objectForKey:@"message"] delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil] show];
        }
    }else if (request.tag == 300){
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        if([json objectForKey:@"id"] != nil){
            [[[UIAlertView alloc] initWithTitle:@"Notification" message:@"Your account was registered successfully. Your password was set '0000'. Please change your password from Settings page." delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil] show];
            
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

@end
