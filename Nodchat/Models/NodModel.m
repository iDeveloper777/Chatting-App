//
//  NodModel.h
//  Nodchat
//
//  Created by Csaba Toth on 21/05/15.
//  Copyright (c) 2015 Digi. All rights reserved.
//

#import "NodModel.h"
#import "Public.h"


@implementation NodModel

- (instancetype) initNodData{
    _id = 0;
    _name = @"";
    _generalMessage = @"";
    _timeout = 0;
    _image = @"";
    _yesMessage = @"";
    _yesImage = @"";
    _noMessage = @"";
    _noImage = @"";
    _yesUsersCount = 0;
    _noUsersCount = 0;
    _invitedUsersCount = 0;
    _onCreated = @"";
    _onUpdated = @"";
    _onPublished = @"";
    _creator_id = 0;
    _users = @"";

    return self;
}

- (instancetype) initNodWithDic:(NSDictionary *)dic{
    _id = 0;
    _name = @"";
    _generalMessage = @"";
    _timeout = 0;
    _image = @"";
    _yesMessage = @"";
    _yesImage = @"";
    _noMessage = @"";
    _noImage = @"";
    _yesUsersCount = 0;
    _noUsersCount = 0;
    _invitedUsersCount = 0;
    _onCreated = @"";
    _onUpdated = @"";
    _onPublished = @"";
    _creator_id = 0;
    _users = @"";
    
    NSString *str;
    
    if ([dic objectForKey:@"id"] != nil)
        _id = [[dic objectForKey:@"id"] longValue];
    
    str = [dic objectForKey:@"name"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _name = [dic objectForKey:@"name"];
    
    str = [dic objectForKey:@"description"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _generalMessage = [dic objectForKey:@"description"];
    
    if ([dic objectForKey:@"timeout"] != nil)
        _timeout = [[dic objectForKey:@"timeout"] intValue];
    
    str = [dic objectForKey:@"image"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _image = [dic objectForKey:@"image"];
    
    str = [dic objectForKey:@"yesMessage"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _yesMessage = [dic objectForKey:@"yesMessage"];
    
    str = [dic objectForKey:@"yesImage"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _yesImage = [dic objectForKey:@"yesImage"];
    
    str = [dic objectForKey:@"noMessage"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _noMessage = [dic objectForKey:@"noMessage"];
    
    str = [dic objectForKey:@"noImage"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _noImage = [dic objectForKey:@"noImage"];
    
    if ([dic objectForKey:@"yesUserCount"] != nil)
        _yesUsersCount = [[dic objectForKey:@"yseUserCount"] intValue];
    
    if ([dic objectForKey:@"noUserCount"] != nil)
        _noUsersCount = [[dic objectForKey:@"noUserCount"] intValue];
    
    if ([dic objectForKey:@"yesUserCount"] != nil)
        _yesUsersCount = [[dic objectForKey:@"yseUserCount"] intValue];
    
    if ([dic objectForKey:@"invitedUserCount"] != nil)
        _invitedUsersCount = [[dic objectForKey:@"invitedUserCount"] intValue];
    
    if ([dic objectForKey:@"onCreated"] != nil)
        _onCreated = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"onCreated"] longValue]];
    
    str = [dic objectForKey:@"onUpdated"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _onUpdated = [dic objectForKey:@"onUpdated"];
    
    str = [dic objectForKey:@"onPublished"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _onPublished = [dic objectForKey:@"onPublished"];
    
    if ([dic objectForKey:@"creator_id"] != nil)
        _creator_id = [[dic objectForKey:@"creator_id"] longValue];
    
    str = [dic objectForKey:@"users"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _users = [dic objectForKey:@"users"];
    
    return self;
}

- (NSMutableDictionary *) getDictionary{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
        
    return dic;
}
@end
