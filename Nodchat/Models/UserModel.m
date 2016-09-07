//
//  UserModel.h
//  Nodchat
//
//  Created by Csaba Toth on 21/05/15.
//  Copyright (c) 2015 Digi. All rights reserved.
//

#import "UserModel.h"
#import "Public.h"


@implementation UserModel

- (instancetype) initUserData{
    _id = @"";
    _avatarImage = @"";
    _username = @"";
    _fname = @"";
    _lname = @"";
    _email = @"";
    _phone = @"";
    _dob = @"";
    _onCreated = @"";
    _onLastLogin = @"";
    _onUpdated = @"";
    _status = @"";
    _serviceId = @"";
    _serviceName = @"";
    _serviceData = [[ServiceDataModel alloc] init];
    _invite_id = @"";

    return self;
}

- (instancetype) initUserWithDic:(NSDictionary *)dic{
    _id = @"";
    _avatarImage = @"";
    _username = @"";
    _fname = @"";
    _lname = @"";
    _email = @"";
    _phone = @"";
    _dob = @"";
    _onCreated = @"";
    _onLastLogin = @"";
    _onUpdated = @"";
    _status = @"";
    _serviceId = @"";
    _serviceName = @"";
    _serviceData = [[ServiceDataModel alloc] init];
    _invite_id = @"";
    
    NSString *str;
    
    if ([dic objectForKey:@"id"] != nil)
        _id = [NSString stringWithFormat:@"%ld", [[dic objectForKey:@"id"] longValue]];
    
    str = [dic objectForKey:@"avatarImage"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _avatarImage = [dic objectForKey:@"avatarImage"];
    
    str = [dic objectForKey:@"username"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _username = [dic objectForKey:@"username"];
    
    str = [dic objectForKey:@"fname"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _fname = [dic objectForKey:@"fname"];
    
    str = [dic objectForKey:@"lname"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _lname = [dic objectForKey:@"lname"];
    
    str = [dic objectForKey:@"email"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _email = [dic objectForKey:@"email"];
    
    str = [dic objectForKey:@"phone"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _phone = [dic objectForKey:@"phone"];
    
    str = [dic objectForKey:@"dob"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _dob = [dic objectForKey:@"dob"];
    
    if ([dic objectForKey:@"onCreated"] != nil)
        _onCreated = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"onCreated"] longValue]];
    
    str = [dic objectForKey:@"onLastLogin"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _onLastLogin = [dic objectForKey:@"onLastLogin"];
    
    str = [dic objectForKey:@"onUpdated"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _onUpdated = [dic objectForKey:@"onUpdated"];
    
    if ([dic objectForKey:@"status"] != nil)
        _status = [NSString stringWithFormat:@"%d", [[dic objectForKey:@"status"] intValue]];
    
    str = [dic objectForKey:@"serviceId"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _serviceId = [dic objectForKey:@"serviceId"];
    
    str = [dic objectForKey:@"serviceName"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _serviceName = [dic objectForKey:@"serviceName"];
    
    NSDictionary *tempDic = (NSDictionary *) [dic objectForKey:@"serviceData"];
    if (tempDic != nil && [tempDic isKindOfClass:[NSDictionary class]])
        _serviceData = [[ServiceDataModel alloc] initUserWithDic:[dic objectForKey:@"serviceData"]];
    
    if ([dic objectForKey:@"invite_id"] != nil)
        _invite_id = [NSString stringWithFormat:@"%d", [[dic objectForKey:@"invite_id"] intValue]];
    
    return self;
}

- (NSMutableDictionary *) getDictionary{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setValue:_id forKey:@"id"];
    [dic setValue:_avatarImage forKey:@"avatarImage"];
    [dic setValue:_username forKey:@"username"];
    [dic setValue:_fname forKey:@"fname"];
    [dic setValue:_lname forKey:@"lname"];
    [dic setValue:_email forKey:@"email"];
    [dic setValue:_phone forKey:@"phone"];
    [dic setValue:_dob forKey:@"dob"];
    [dic setValue:_onCreated forKey:@"onCreated"];
    [dic setValue:_onLastLogin forKey:@"onLastLogin"];
    [dic setValue:_status forKey:@"status"];
    [dic setValue:_serviceId forKey:@"serviceId"];
    [dic setValue:_serviceName forKey:@"serviceName"];
    [dic setValue:_invite_id forKey:@"invite_id"];
    
    return dic;
}
@end
