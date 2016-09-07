//
//  UserModel.h
//  Nodchat
//
//  Created by Csaba Toth on 21/05/15.
//  Copyright (c) 2015 Digi. All rights reserved.
//

#ifndef Nodchat_UserModel_h
#define Nodchat_UserModel_h

#import <Foundation/Foundation.h>

@protocol UserModel
@end

@class ServiceDataModel;

@interface UserModel : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *avatarImage;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *fname;
@property (strong, nonatomic) NSString *lname;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *dob;
@property (strong, nonatomic) NSString *onCreated;
@property (strong, nonatomic) NSString *onLastLogin;
@property (strong, nonatomic) NSString *onUpdated;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *serviceId;
@property (strong, nonatomic) NSString *serviceName;
@property (strong, nonatomic) ServiceDataModel *serviceData;
@property (strong, nonatomic) NSString *invite_id;

- (instancetype) initUserData;
- (instancetype) initUserWithDic: (NSDictionary *) dic;
- (NSMutableDictionary *) getDictionary;
@end

#endif
