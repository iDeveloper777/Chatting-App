//
//  AboutUsViewController.h
//  Nodchat
//
//  Created by Csaba Toth on 15/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"

@interface AboutUsViewController : UIViewController

//NavigationView
@property (weak, nonatomic) IBOutlet UIView *viewNavigation;

//Buttons Event
- (IBAction)pressBackBtn:(id)sender;

@end
