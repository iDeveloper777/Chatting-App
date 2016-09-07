//
//  InviteModel.h
//  Nodchat
//
//  Created by Csaba Toth on 15/06/15.
//  Copyright (c) 2015 Digi. All rights reserved.
//

#ifndef Nodchat_InviteModel_h
#define Nodchat_InviteModel_h

#import <Foundation/Foundation.h>

@protocol InviteModel
@end


@interface InviteModel : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *onCreated;
@property (strong, nonatomic) NSString *isActive;
@property (strong, nonatomic) NSString *creator_id;

- (instancetype) initUserData;
- (instancetype) initUserWithDic: (NSDictionary *) dic;
//- (NSMutableDictionary *) getDictionary;
@end

#endif
