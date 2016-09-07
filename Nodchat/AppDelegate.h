//
//  AppDelegate.h
//  Nod
//
//  Created by Csaba Toth on 06/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"

@class UserModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
//UserModel
@property (strong, nonatomic) UserModel *user;

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;

//FacebookID
@property (strong, nonatomic) NSString *facebookID;
@property (strong, nonatomic) NSString *facebookFName;
@property (strong, nonatomic) NSString *facebookLName;
@property (strong, nonatomic) NSString *facebookEmail;
@property (strong, nonatomic) NSString *facebookPhoto;

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic) int imageWidth;
@property (assign, nonatomic) int imageHeight;

//Global variables
@property (strong, nonatomic) NSString *deviceToken;
@property (strong, nonatomic) NSString *ssid;

//Contacts Array
@property (strong, nonatomic) NSMutableArray *arrContacts;
@property (strong, nonatomic) NSMutableArray *arrSelectedUsers;

+ (AppDelegate *) sharedAppDelegate;
- (NSString *) storyboardName;
- (void) initAllDatas;
- (void) saveContacts;

- (void) getPersonOutOfAddressBook;
@end

