//
//  NodViewController.m
//  Nodchat
//
//  Created by Csaba Toth on 12/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import "NodViewController.h"

@interface NodViewController (){
    UIStoryboard *storyboard;
    AppDelegate *appDelegate;
    
    NSString *strURL;
    NSString *type_id;
    
    NSMutableArray *arrNods;
    
    int isSentSelected;
    
}
@end

@implementation NodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];   //Status bar
    
    isSentSelected = 0;
    
    appDelegate = [AppDelegate sharedAppDelegate];
    storyboard = [UIStoryboard storyboardWithName:[appDelegate storyboardName] bundle:nil];
    
    type_id = @"2";
    
    [self setLayout];
    [self getNodsFromDB];
}

//Status Bar
- (UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setLayout{
    _ivNoNodsYet.hidden = YES;
    
    [self.tvList reloadData];
}

#pragma mark getNodsFromDB
- (void) getNodsFromDB{
    arrNods = [NSMutableArray new];
    
    [SVProgressHUD showWithStatus:@"Loading..."];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    strURL = [NSString stringWithFormat:@"%@/nod?ssid=%@&type_id=%@", API_URL, appDelegate.ssid, type_id];
    
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
        NSMutableArray *arrData = (NSMutableArray *)json;
        if ([arrData isKindOfClass:[NSMutableArray class]] && arrData.count > 0){
            for (int i=0; i<arrData.count; i++){
                NSDictionary *dic = [arrData objectAtIndex:i];
                NodModel *nod = [[NodModel alloc] initNodWithDic:dic];
                
                _tvList.hidden = NO;
                [arrNods addObject:nod];
            }
            [_tvList reloadData];
        }
        if ([arrData isKindOfClass:[NSMutableArray class]] && arrData.count == 0){
            _tvList.hidden = YES;
            _ivNoNodsYet.hidden = NO;
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot connect to server" delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark Buttons Event

- (IBAction)pressSettingsBtn:(id)sender {
//    SettingsViewController *viewController = (SettingsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SettingsView"];
//    [self presentViewController:viewController animated:YES completion:nil];    
}

- (IBAction)pressMoreBtn:(id)sender {
    CreateANodViewController *viewController = (CreateANodViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CreateANodView"];
    [self.navigationController pushViewController:viewController animated:YES];

}

- (IBAction)pressInboxBtn:(id)sender {
    isSentSelected = 0;
    type_id = @"2";
    
    [_btnInbox setBackgroundImage:[UIImage imageNamed:@"btn_Inbox_pressed"] forState:UIControlStateNormal];
    [_btnSent setBackgroundImage:[UIImage imageNamed:@"btn_Sent_normal"] forState:UIControlStateNormal];
    
    _tvList.hidden = NO;
    _ivNoNodsYet.hidden = YES;
    
    [self getNodsFromDB];
}

- (IBAction)pressSentBtn:(id)sender {
    isSentSelected = 1;
    type_id = @"1";
    
    [_btnInbox setBackgroundImage:[UIImage imageNamed:@"btn_Inbox_normal"] forState:UIControlStateNormal];
    [_btnSent setBackgroundImage:[UIImage imageNamed:@"btn_Sent_pressed"] forState:UIControlStateNormal];
    
//    _tvList.hidden = YES;
//    _ivNoNodsYet.hidden = NO;
    
    _tvList.hidden = NO;
    _ivNoNodsYet.hidden = YES;
    
    [self getNodsFromDB];
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
    return arrNods.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSentSelected == 1)
        return;
    
    UITableViewCell *cell = [self.tvList cellForRowAtIndexPath:indexPath];
    UILabel *lblTitle = (UILabel *)[cell viewWithTag:200];
    NSString *strTitle = lblTitle.text;
    
    ReplyNodViewController *viewController = (ReplyNodViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ReplyNodView"];
    viewController.strTitle = strTitle;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"Cell";
    UITableViewCell *cell = [self.tvList dequeueReusableCellWithIdentifier:CellIndentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *imgRedDot, *imgYesNo, *imgWaiting;
    UILabel *lblName, *lblDate, *lblSeconds, *lblYesNo, *lblDescription, *lblYesNoPerson, *lblComment;
    
    //Get Elements
    imgRedDot = (UIImageView *)[cell viewWithTag:100];
    lblName = (UILabel *)[cell viewWithTag:200];
    lblDate = (UILabel *)[cell viewWithTag:300];
    lblSeconds = (UILabel *)[cell viewWithTag:400];
    lblYesNo = (UILabel *)[cell viewWithTag:500];
    lblDescription = (UILabel *)[cell viewWithTag:600];
    imgYesNo = (UIImageView *)[cell viewWithTag:700];
    lblYesNoPerson = (UILabel *)[cell viewWithTag:800];
    lblComment = (UILabel *)[cell viewWithTag:900];
    imgWaiting = (UIImageView *)[cell viewWithTag:1000];
    
    NodModel *nod = [arrNods objectAtIndex:indexPath.row];
    lblName.text = nod.name;
    lblDate.text = @"Yesterday";
    lblSeconds.text = [NSString stringWithFormat:@"%d", nod.timeout];
    
    lblYesNo.hidden = YES;
    lblDescription.hidden = YES;
    imgYesNo.hidden = YES;
    lblYesNoPerson.hidden = YES;
    lblComment.hidden = YES;
    imgWaiting.hidden = YES;

    
//    if (indexPath.row == 0){
//        lblName.text = @"Dany Lewis";
//        lblDate.text = @"Yesterday";
//        lblSeconds.text = @"20 seconds";
//        
//        lblYesNo.hidden = YES;
//        lblDescription.hidden = YES;
//        imgYesNo.hidden = YES;
//        lblYesNoPerson.hidden = YES;
//        lblComment.hidden = YES;
//        imgWaiting.hidden = YES;
//    }else if (indexPath.row == 1){
//        lblName.text = @"Larry J.Branson";
//        lblDate.text = @"3 days";
//        lblSeconds.text = @"15 seconds";
//        
//        lblYesNo.hidden = YES;
//        lblDescription.hidden = YES;
//        imgYesNo.hidden = YES;
//        lblYesNoPerson.hidden = YES;
//        lblComment.hidden = YES;
//        imgWaiting.hidden = YES;
//    }else if (indexPath.row == 2){
//        lblName.text = @"Leo - Nancy, Steve,";
//        lblDate.text = @"1 week";
//        lblSeconds.text = @"15 seconds";
//        
//        lblYesNo.hidden = YES;
//        lblDescription.hidden = YES;
//        imgYesNo.hidden = YES;
//        lblYesNoPerson.hidden = YES;
//        lblComment.hidden = YES;
//        imgWaiting.hidden = YES;
//    }else if (indexPath.row == 3){
//        imgRedDot.hidden = YES;
//        lblName.text = @"Mark McBright";
//        lblDate.text = @"Just now";
//        lblSeconds.hidden = YES;
//        lblYesNo.text = @"No - ";
//        lblDescription.text = @"Lorem ipsum dolor sit amet, consectetur adipis...";
//        imgYesNo.image = [UIImage imageNamed:@"img_NO_small.png"];
//        lblYesNoPerson.text = @"No - 1 ⋅";
//        lblComment.text = @"1 Comment";
//        imgWaiting.hidden = YES;
//    }else if (indexPath.row == 4){
//        imgRedDot.hidden = YES;
//        lblName.text = @"Oliver Gregson";
//        lblDate.text = @"11:36 PM";
//        lblSeconds.hidden = YES;
//        lblYesNo.text = @"Yes - ";
//        lblDescription.text = @"Lorem ipsum dolor sit amet, consectetur adipis...";
//        imgYesNo.image = [UIImage imageNamed:@"img_YES_small.png"];
//        lblYesNoPerson.text = @"Yes - 1 ⋅";
//        lblComment.text = @"1 Comment";
//        imgWaiting.hidden = YES;
//    }else if (indexPath.row == 5){
//        imgRedDot.hidden = YES;
//        lblName.text = @"Sara - Mike, PJ, Patrick...";
//        lblDate.text = @"8:44 PM";
//        lblSeconds.hidden = NO;
//        lblYesNo.hidden = YES;
//        lblDescription.hidden = YES;
//        imgYesNo.image = [UIImage imageNamed:@"img_NO_small.png"];
//        lblYesNoPerson.text = @"No - 7 ⋅";
//        lblComment.text = @"     Waiting - 11";
//        imgWaiting.hidden = NO;
//    }
    
    return cell;
}
@end
