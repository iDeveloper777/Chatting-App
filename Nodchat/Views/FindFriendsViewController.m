//
//  FindFriendsViewController.m
//  Nodchat
//
//  Created by Csaba Toth on 11/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import "FindFriendsViewController.h"

@interface FindFriendsViewController (){
    UIStoryboard *storyboard;
}

@end

@implementation FindFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    storyboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedAppDelegate] storyboardName] bundle:nil];
    
    [self setNeedsStatusBarAppearanceUpdate];   //Status bar
    
}

//Status Bar
- (UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Buttons Event
- (IBAction)pressFindfriendsBtn:(id)sender {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedAppDelegate] storyboardName] bundle:nil];
//    FindContactsViewController *viewController = (FindContactsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FindContactsView"];
//    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)pressSkipBtn:(id)sender {
    if (_isLogin == 0){
        NodViewController *viewController = (NodViewController *)[storyboard instantiateViewControllerWithIdentifier:@"NodView"];
        [self.navigationController pushViewController:viewController animated:TRUE];
    }else
        [self.navigationController popViewControllerAnimated:YES];
}
@end
