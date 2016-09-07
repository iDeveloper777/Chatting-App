//
//  ParticipantsViewController.m
//  Nodchat
//
//  Created by Csaba Toth on 13/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import "ParticipantsViewController.h"

@interface ParticipantsViewController ()

@end

@implementation ParticipantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (void) setLayout{
    
}

#pragma mark Buttons Event
- (IBAction)pressBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    return 3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"Cell";
    UITableViewCell *cell = [self.tvList dequeueReusableCellWithIdentifier:CellIndentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *lblName;
    UITextView *txtViewComment;
    UILabel *lblStatus;
    
    lblName = (UILabel *)[cell viewWithTag:100];
    txtViewComment = (UITextView *)[cell viewWithTag:200];
    lblStatus = (UILabel *)[cell viewWithTag:300];
    
    if (indexPath.row == 0){
        lblName.text = @"Mark McBrigtht";
        lblStatus.text = @"NO";
        lblStatus.textColor = [UIColor redColor];
    }else if (indexPath.row == 1){
        lblName.text = @"Oliver Gregson";
        lblStatus.text = @"YES";
    }else if (indexPath.row == 2){
        lblName.text = @"Mark McBrigtht";
        lblStatus.text = @"YES";
    }
    
    return cell;
}
@end
