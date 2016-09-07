//
//  NotificationsViewController.m
//  Nodchat
//
//  Created by Csaba Toth on 18/5/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import "NotificationsViewController.h"

@interface NotificationsViewController ()

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
}

#pragma mark Buttons Event

- (IBAction)pressBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressPlusBtn:(id)sender {
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
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"Cell";
    UITableViewCell *cell = [self.tvList dequeueReusableCellWithIdentifier:CellIndentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITextView *txtNotification;
    UILabel *lblTime;
    
    txtNotification = (UITextView *)[cell viewWithTag:100];
    lblTime = (UILabel *)[cell viewWithTag:200];
    
    if (indexPath.row == 0) {
        txtNotification.text = @"Dany Lewis sent you nod";
        lblTime.text = @"Yesterday";
    } else if (indexPath.row == 1){
        txtNotification.text = @"Larry J.Branson replied to your nod";
        lblTime.text = @"3 days";
    } else if (indexPath.row == 2){
        txtNotification.text = @"Leo replied to your nod";
        lblTime.text = @"1 week";
    } else if (indexPath.row == 3){
        txtNotification.text = @"Mark McBright has joined nod";
        lblTime.text = @"Just now";
    } else if (indexPath.row == 4){
        txtNotification.text = @"Oliver Gregson accepted your invite";
        lblTime.text = @"11:36 PM";
    }
    
    return cell;
}

@end
