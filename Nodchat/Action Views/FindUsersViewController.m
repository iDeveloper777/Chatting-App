//
//  FindUsersViewController.m
//  Nodchat
//
//  Created by Csaba Toth on 13/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import "FindUsersViewController.h"

@interface FindUsersViewController (){
    AppDelegate *appDelegate;
    
    NSString *strURL;
    NSString *strIds;
    
    NSMutableArray *contactsArray;
    NSMutableArray *userArray;
    NSMutableArray *selectedUserArray;
    NSMutableArray *userIndexArray;
    NSMutableArray *originalArray;
    NSMutableArray *flagArray;
}

@end

@implementation FindUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = [AppDelegate sharedAppDelegate];
    
    [self getContacts];
    [self getExistUsers];
    [self setLayout];
}

//Status Bar
- (UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getContacts
- (void) getContacts{
    [appDelegate getPersonOutOfAddressBook];
    contactsArray = [NSMutableArray new];
    
    for (int i=0; i<appDelegate.arrContacts.count; i++){
        UserModel *user = [appDelegate.arrContacts objectAtIndex:i];
        [contactsArray addObject:user];
    }
}

#pragma mark - getExistUsers
- (void) getExistUsers{
    userArray  = [NSMutableArray new];
    selectedUserArray = [NSMutableArray new];
    userIndexArray = [NSMutableArray new];
    originalArray = [NSMutableArray new];
    flagArray = [NSMutableArray new];
    
    NSString *strEmails;
    strEmails = @"&tids=";
    if (contactsArray.count > 0){
        UserModel *user = [contactsArray objectAtIndex:0];
        strEmails = [NSString stringWithFormat:@"%@%@", strEmails, user.email];
    }
    for (int i=1; i<contactsArray.count; i++){
        UserModel *user = [contactsArray objectAtIndex:i];
        strEmails = [NSString stringWithFormat:@"%@,%@", strEmails, user.email];
    }
    
    strURL = [NSString stringWithFormat:@"%@/user/existence?ssid=%@&type=email&%@", API_URL, appDelegate.ssid, strEmails];
    
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

#pragma mark getUserInfo
- (void) getUserInfo{
    strURL = [NSString stringWithFormat:@"%@/user?ids=%@", API_URL, strIds];
    
    ASIFormDataRequest *request =[[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:strURL]];
    request.delegate=self;
    
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"GET"];
    
    request.tag = 200;
    [request startAsynchronous];
}

#pragma mark - HTTP Post Request
-(void)requestFinished:(ASIHTTPRequest *)request
{
//    [SVProgressHUD dismiss];
//    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:request.responseData
                                                         options:kNilOptions
                                                           error:&error];
    //Get Users
    if (request.tag == 100){
        NSMutableArray *arrUsers = (NSMutableArray *)json;
        if ([arrUsers isKindOfClass:[NSMutableArray class]] && arrUsers.count > 0){
            for (int i=0; i<contactsArray.count; i++){
                NSNumber *nId = (NSNumber *)[arrUsers objectAtIndex:i];
                UserModel *user = [contactsArray objectAtIndex:i];
                
                user.id = [NSString stringWithFormat:@"%ld", [nId longValue]];
                [contactsArray removeObjectAtIndex:i];
                [contactsArray insertObject:user atIndex:i];
            }
            
            //if 0, remove
            int j = 0;
            while (j<contactsArray.count) {
                UserModel *user = [contactsArray objectAtIndex:j];
                if ([user.id isEqualToString:@"0"])
                    [contactsArray removeObjectAtIndex:j];
                else
                    j++;
            }
            
            strIds = @"";
            if (contactsArray.count == 1){
                UserModel *user = [contactsArray objectAtIndex:0];
                strIds = [NSString stringWithFormat:@"[0,%@]", user.id];
            }else if (contactsArray.count > 1){
                UserModel *user = [contactsArray objectAtIndex:0];
                strIds = [NSString stringWithFormat:@"[0,%@", user.id];
                
                for (int i=1; i<contactsArray.count; i++){
                    UserModel *user = [contactsArray objectAtIndex:i];
                    
                    if (i == contactsArray.count-1)
                        strIds = [NSString stringWithFormat:@"%@,%@]", strIds, user.id];
                    else
                        strIds = [NSString stringWithFormat:@"%@,%@", strIds, user.id];
                }
            }
            
            if (contactsArray.count > 0){
                [self getUserInfo];
            }
        }else{
            [SVProgressHUD dismiss];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    }else if (request.tag == 200){ //Get User Info
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        NSMutableArray *arrUsers = (NSMutableArray *)json;
        if(arrUsers.count > 0){
            for (int i=0; i<arrUsers.count; i++){
                NSDictionary *tmpDic = (NSDictionary *)[arrUsers objectAtIndex:i];
                UserModel *tmpUser = [[UserModel alloc] initUserWithDic:tmpDic];
                
                [originalArray addObject:tmpUser];
                [userArray addObject:tmpUser];
                [userIndexArray addObject:[NSString stringWithFormat:@"%d", i]];
                [flagArray addObject:@"0"];
            }
        }
        
        [_tvList reloadData];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot connect to server" delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark setLayout
- (void) setLayout{
    //Border
    _viewSearch.layer.borderWidth = 0.5f; _viewSearch.layer.borderColor = [[UIColor grayColor] CGColor];
    _tvList.layer.borderWidth = 0.5f; _tvList.layer.borderColor = [[UIColor grayColor] CGColor];
    
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
    self.tfUserName.inputAccessoryView = doneToolbar;
    
    [_tfUserName addTarget:self action:@selector(beginEditingTextbox:) forControlEvents:UIControlEventEditingDidEnd];
    [_tfUserName addTarget:self action:@selector(beginEditingTextbox:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark beginEditingTextbox
- (BOOL) beginEditingTextbox:(UITextField *)textField{
    userArray = [[NSMutableArray alloc] init];
    userIndexArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<originalArray.count; i++){
        [userArray addObject:[originalArray objectAtIndex:i]];
        [userIndexArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    if ([_tfUserName.text isEqualToString:@""])
    {
        [_tvList reloadData];
        return TRUE;
    }
    
    //    NSLog(self.txtSearchItem.text);
    int i = 0;
    
    while (i < userArray.count) {
        UserModel *tmpUser = [userArray objectAtIndex:i];
        NSString *strUser= (NSString *)[NSString stringWithFormat:@"%@ %@", tmpUser.fname, tmpUser.lname];
        
        NSString *lowerString = [strUser lowercaseString];
        NSString *compareLowerString = [_tfUserName.text lowercaseString];
        
        //        NSLog([NSString stringWithFormat:@"%@", radioModel.station_name]);
        if ([lowerString rangeOfString:compareLowerString].location == NSNotFound) {
            [userArray removeObjectAtIndex:i];
            [userIndexArray removeObjectAtIndex:i];
        }
        else
            i++;
    }
    
    [_tvList reloadData];
    return TRUE;
}


#pragma mark Keyboard Events
- (IBAction) doneWithKeyboard:(id) sender{
    [_tfUserName resignFirstResponder];
}

- (IBAction) cancelWithKeyboard:(id) sender{
    [_tfUserName resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return userArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tvList cellForRowAtIndexPath:indexPath];
    UIImageView *imgSelected = (UIImageView *)[cell viewWithTag:200];
    
    NSString *strIndex = [userIndexArray objectAtIndex:indexPath.row];
    NSString *strFlag = [flagArray objectAtIndex:[strIndex integerValue]];
    
    if ([strFlag isEqual:@"0"]){
        [flagArray removeObjectAtIndex:[strIndex integerValue]];
        [flagArray insertObject:@"1" atIndex:[strIndex integerValue]];
        imgSelected.hidden = NO;
    }else{
        [flagArray removeObjectAtIndex:[strIndex integerValue]];
        [flagArray insertObject:@"0" atIndex:[strIndex integerValue]];
        imgSelected.hidden = YES;
    }
    
    selectedUserArray = [NSMutableArray new];
    for (int i=0; i<originalArray.count; i++){
        if ([[flagArray objectAtIndex:i] isEqualToString:@"1"]){
            UserModel *tmpUser = (UserModel *)[originalArray objectAtIndex:i];
            [selectedUserArray addObject:tmpUser];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"Cell";
    UITableViewCell *cell = [self.tvList dequeueReusableCellWithIdentifier:CellIndentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *lblName;
    UIImageView *imgSelected;
    
    lblName = (UILabel *)[cell viewWithTag:100];
    imgSelected = (UIImageView *)[cell viewWithTag:200];
    
    UserModel *tmpUser = [userArray objectAtIndex:indexPath.row];
    lblName.text = [NSString stringWithFormat:@"%@ %@", tmpUser.fname, tmpUser.lname];
    
    NSString *strIndex = [userIndexArray objectAtIndex:indexPath.row];
    NSString *strFlag = [flagArray objectAtIndex:[strIndex integerValue]];
    if ([strFlag isEqual:@"0"])
        imgSelected.hidden = YES;
    else
        imgSelected.hidden = NO;
    
    return cell;
}

#pragma mark Buttons Event
- (IBAction)pressBackBtn:(id)sender {
    appDelegate.arrSelectedUsers = [NSMutableArray new];
    
    for (int i=0; i<selectedUserArray.count; i++){
        UserModel *tmpUser = (UserModel *) [selectedUserArray objectAtIndex:i];
        [appDelegate.arrSelectedUsers addObject:tmpUser];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressCloseBtn:(id)sender {
    [_tfUserName resignFirstResponder];
    
    _tfUserName.text = @"";
    
    userArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<originalArray.count; i++){
        [userArray addObject:[originalArray objectAtIndex:i]];
        [userIndexArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    [_tvList reloadData];
}
@end
