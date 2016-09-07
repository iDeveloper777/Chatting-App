//
//  NodModel.h
//  Nodchat
//
//  Created by Csaba Toth on 21/05/15.
//  Copyright (c) 2015 Digi. All rights reserved.
//

#ifndef Nodchat_NodModel_h
#define Nodchat_NodModel_h

#import <Foundation/Foundation.h>

@protocol NodModel
@end


@interface NodModel : NSObject

@property (assign, nonatomic) long id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *generalMessage;
@property (assign, nonatomic) int timeout;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *yesMessage;
@property (strong, nonatomic) NSString *yesImage;
@property (strong, nonatomic) NSString *noMessage;
@property (strong, nonatomic) NSString *noImage;
@property (assign, nonatomic) int yesUsersCount;
@property (assign, nonatomic) int noUsersCount;
@property (assign, nonatomic) int invitedUsersCount;
@property (strong, nonatomic) NSString *onCreated;
@property (strong, nonatomic) NSString *onUpdated;
@property (strong, nonatomic) NSString *onPublished;
@property (assign, nonatomic) long creator_id;
@property (strong, nonatomic) NSString *users;


- (instancetype) initNodData;
- (instancetype) initNodWithDic: (NSDictionary *) dic;
- (NSMutableDictionary *) getDictionary;
@end

#endif
