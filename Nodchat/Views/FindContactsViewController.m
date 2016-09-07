//
//  FindContactsViewController.m
//  Nodchat
//
//  Created by Csaba Toth on 11/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import "FindContactsViewController.h"

@interface FindContactsViewController (){
    UIStoryboard *storyboard;
}

@end

@implementation FindContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setNeedsStatusBarAppearanceUpdate];   //Status bar
    
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
    
}

#pragma mark Buttons Event
- (IBAction)pressFacebookBtn:(id)sender {
//    InviteViewController *viewController = (InviteViewController *)[storyboard instantiateViewControllerWithIdentifier:@"InviteView"];
//    [self.navigationController pushViewController:viewController animated:TRUE];
}

- (IBAction)pressContactsBtn:(id)sender {
    InviteViewController *viewController = (InviteViewController *)[storyboard instantiateViewControllerWithIdentifier:@"InviteView"];
    [self.navigationController pushViewController:viewController animated:TRUE];
}

- (IBAction)pressSkipBtn:(id)sender {
    NodViewController *viewController = (NodViewController *)[storyboard instantiateViewControllerWithIdentifier:@"NodView"];
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
