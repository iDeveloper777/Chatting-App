//
//  SettingsViewController.m
//  Nodchat
//
//  Created by Csaba Toth on 13/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController (){
    UIStoryboard *storyboard;
}
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    storyboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedAppDelegate] storyboardName] bundle:nil];
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
    //Profile image
    _ivProfile.layer.cornerRadius = _ivProfile.frame.size.height / 2;
    _ivProfile.layer.masksToBounds = YES;
    _ivProfile.layer.borderWidth = 2;
    _ivProfile.layer.borderColor = [UIColor grayColor].CGColor;
}

#pragma mark Buttons Event
- (IBAction)pressBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressAccountBtn:(id)sender {
    SignUpViewController *viewController = (SignUpViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SignUpView"];
    viewController.isSignUp = 1;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)pressNotificationsBtn:(id)sender {
}

- (IBAction)pressTellAFriendBtn:(id)sender {
}

- (IBAction)pressAboutUSBtn:(id)sender {
}
@end
