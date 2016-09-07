//
//  ServiceDataModel.h
//  Nodchat
//
//  Created by Csaba Toth on 21/05/15.
//  Copyright (c) 2015 Digi. All rights reserved.
//

#ifndef Nodchat_ServiceDataModel_h
#define Nodchat_ServiceDataModel_h

#import <Foundation/Foundation.h>

@protocol ServiceDataModel
@end


@interface ServiceDataModel : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *photo;

- (instancetype) initUserData;
- (instancetype) initUserWithDic: (NSDictionary *) dic;
@end

#endif
