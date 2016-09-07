//
//  InviteViewController.m
//  Nodchat
//
//  Created by Csaba Toth on 12/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import "InviteViewController.h"

@interface InviteViewController (){
    AppDelegate *appDelegate;
    UIStoryboard *storyboard;
    
    NSString *strURL;
    NSMutableArray *arrContacts;
    NSMutableArray *arrInvites;
    NSMutableArray *arrList;
}

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = [AppDelegate sharedAppDelegate];
    storyboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedAppDelegate] storyboardName] bundle:nil];
    
    [self getContacts];
    [self getExistUsers];
    [self setLayout];
//    [self getInviteList];
    [self hideNotification];
}

//Status Bar
- (UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark setLayout
- (void) setLayout{
    _btnPlus.hidden = YES;
    
    //--Notification View TapGesture Event--
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    singleTap.numberOfTapsRequired = 1;
    [self.viewNotification setUserInteractionEnabled:YES];
    [self.viewNotification addGestureRecognizer:singleTap];
}

#pragma mark getInviteList
- (void) getInviteList{
    arrInvites = [NSMutableArray new];
    
    strURL = [NSString stringWithFormat:@"%@/invite?ssid=%@", API_URL, appDelegate.ssid];
    
    [SVProgressHUD showWithStatus:@"Loading..."];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    ASIFormDataRequest *request =[[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:strURL]];
    request.delegate=self;
    
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"GET"];
    
    request.tag = 300;
    [request startAsynchronous];

}

#pragma mark Buttons Event

- (IBAction)pressBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressPlusBtn:(id)sender {
    CreateANodViewController *viewController = (CreateANodViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CreateANodView"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)pressCancelBtn:(id)sender {
    [self hideNotification];
}

- (IBAction)pressContinueBtn:(id)sender {
    [self hideNotification];
}

#pragma mark - getContacts
- (void) getContacts{
    [appDelegate getPersonOutOfAddressBook];
    arrContacts = [NSMutableArray new];
    arrList = [NSMutableArray new];
    
    for (int i=0; i<appDelegate.arrContacts.count; i++){
        UserModel *user = [appDelegate.arrContacts objectAtIndex:i];
        [arrContacts addObject:user];
    }
}

#pragma mark getExistUsers
- (void) getExistUsers{
    NSString *strEmails;
    
    strEmails = @"&tids=";
    if (arrContacts.count > 0){
        UserModel *user = [arrContacts objectAtIndex:0];
        strEmails = [NSString stringWithFormat:@"%@%@", strEmails, user.email];
    }
    for (int i=1; i<arrContacts.count; i++){
        UserModel *user = [arrContacts objectAtIndex:i];
        strEmails = [NSString stringWithFormat:@"%@,%@", strEmails, user.email];
    }
    
    strURL = [NSString stringWithFormat:@"%@/user/existence?ssid=%@&type=email%@", API_URL, appDelegate.ssid, strEmails];

    [SVProgressHUD showWithStatus:@"Loading..."];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    ASIFormDataRequest *request =[[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:strURL]];
    request.delegate=self;
    
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"GET"];
    
    request.tag = 100;
    [request startAsynchronous];
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
    if (request.tag == 100){
        NSMutableArray *arrUsers = (NSMutableArray *)json;
        if ([arrUsers isKindOfClass:[NSMutableArray class]] && arrUsers.count > 0){
            for (int i=0; i<arrContacts.count; i++){
                NSNumber *nId = (NSNumber *)[arrUsers objectAtIndex:i];
                UserModel *user = [arrContacts objectAtIndex:i];
                
                user.id = [NSString stringWithFormat:@"%ld", [nId longValue]];
                [arrContacts removeObjectAtIndex:i];
                [arrContacts insertObject:user atIndex:i];
                
                if ([user.id isEqualToString:@"0"]){
                    [arrList addObject:user];
                }
            }
        }

        [_tvInviteList reloadData];
    }else if (request.tag == 200){ //Create Invite
        if([json objectForKey:@"success"] != nil){
            BOOL bStatus = (BOOL)[json objectForKey:@"success"];
            if (bStatus){
                [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your invitation was sent successfully!" delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil] show];
            }else{
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Your invitation was failed!" delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil] show];
            }
        }else{
            _txtMessage.text = @"Error!";
            [self openNotification];
            //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[json objectForKey:@"message"] delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil];
            //            [alertView show];
        }
    }else if (request.tag == 300){
        NSMutableArray *arrTemp = (NSMutableArray *)json;
        if (arrTemp.count > 0){
            for (int i=0; i<arrTemp.count; i++){
                InviteModel *invite = [[InviteModel alloc] initUserWithDic:(NSDictionary *)[arrTemp objectAtIndex:i]];
                [arrInvites addObject:invite];
            }
        }else{
            
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot connect to server" delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return arrList.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserModel *user = (UserModel *)[arrList objectAtIndex:(int)indexPath.row];
    
    if ([user.email isEqualToString:@""] && [user.phone isEqualToString:@""])
        return;
    
    strURL = [NSString stringWithFormat:@"%@/invite?ssid=%@", API_URL, appDelegate.ssid];
    
    [SVProgressHUD showWithStatus:@"Loading..."];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    ASIFormDataRequest *request =[[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:strURL]];
    request.delegate=self;
    
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"POST"];
    
    [request setPostValue:@"email" forKey:@"type"];
    if (![user.email isEqualToString:@""])
        [request setPostValue:user.email forKey:@"email"];
    if (![user.phone isEqualToString:@""])
        [request setPostValue:user.phone forKey:@"phone"];
    
    request.tag = 200;
    [request startAsynchronous];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"Cell";
    UITableViewCell *cell = [self.tvInviteList dequeueReusableCellWithIdentifier:CellIndentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UILabel *lblName, *lblPhone, *lblEmail;
    UIImageView *imgPhone, *imgEmail, *imgIndicator;
    
    lblName = (UILabel *)[cell viewWithTag:100];
    imgPhone = (UIImageView *)[cell viewWithTag:200];
    lblPhone = (UILabel *)[cell viewWithTag:300];
    imgEmail = (UIImageView *)[cell viewWithTag:400];
    lblEmail = (UILabel *)[cell viewWithTag:500];
    imgIndicator = (UIImageView *)[cell viewWithTag:600];
    
    UserModel *user = (UserModel *)[arrList objectAtIndexedSubscript:(int)indexPath.row];
    lblName.text = [NSString stringWithFormat:@"%@ %@", user.fname, user.lname];
    
    if ([user.phone isEqualToString:@""]){
        imgPhone.hidden = YES; lblPhone.hidden = YES;
        
        [lblName setFrame: RECT_CHANGE_y(lblName, lblName.frame.origin.y + 10)];
        [imgEmail setFrame: RECT_CHANGE_y(imgEmail, imgPhone.frame.origin.y + 10)];
        [lblEmail setFrame: RECT_CHANGE_y(lblEmail, lblPhone.frame.origin.y + 10)];
    }else{
        imgPhone.hidden = NO; lblPhone.hidden = NO;
    }
    lblPhone.text = user.phone;
    
    if ([user.email isEqualToString:@""]){
        imgEmail.hidden = YES; lblEmail.hidden = YES;
        
        if (![user.phone isEqualToString:@""])
            [lblName setFrame: RECT_CHANGE_y(lblName, lblName.frame.origin.y + 10)];
        
        [imgPhone setFrame: RECT_CHANGE_y(imgPhone, imgPhone.frame.origin.y + 10)];
        [lblPhone setFrame: RECT_CHANGE_y(lblPhone, lblPhone.frame.origin.y + 10)];
    }else{
        imgEmail.hidden = NO; lblEmail.hidden = NO;
    }
    lblEmail.text = user.email;

    imgIndicator.hidden = NO;
//    } else if (indexPath.row == 1){
//        lblName.text = @"Oliver Gregson";
//        imgPhone.hidden = YES;
//        lblPhone.hidden = YES;
//        imgEmail.hidden = NO;
//        [imgEmail setFrame: CGRectMake(imgEmail.frame.origin.x, imgPhone.frame.origin.y, imgEmail.bounds.size.width, imgEmail.bounds.size.height)];
//        lblEmail.text = @"user.name@mail.com";
//        [lblEmail setFrame: CGRectMake(lblEmail.frame.origin.x, lblPhone.frame.origin.y, lblEmail.bounds.size.width, lblEmail.bounds.size.height)];
//        imgIndicator.hidden = NO;
//    } else if (indexPath.row == 2){
//        lblName.text = @"Mark McBright";
//        imgPhone.hidden = NO;
//        lblPhone.text = @"068734651";
//        imgEmail.hidden = YES;
//        lblEmail.hidden = YES;
//        imgIndicator.hidden = NO;
//    }
    
    return cell;
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
@end
