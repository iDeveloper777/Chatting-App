//
//  InviteModel.h
//  Nodchat
//
//  Created by Csaba Toth on 15/06/15.
//  Copyright (c) 2015 Digi. All rights reserved.
//

#import "InviteModel.h"
#import "Public.h"

@implementation InviteModel

- (instancetype) initUserData{
    _id = @"";
    _email = @"";
    _onCreated = @"";
    _isActive = @"";
    _creator_id = @"";

    return self;
}

- (instancetype) initUserWithDic:(NSDictionary *)dic{
    _id = @"";
    _email = @"";
    _onCreated = @"";
    _isActive = @"";
    _creator_id = @"";
    
    NSString *str;
    
    if ([dic objectForKey:@"id"] != nil)
        _id = [NSString stringWithFormat:@"%ld", [[dic objectForKey:@"id"] longValue]];
    
    str = [dic objectForKey:@"email"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _email = [dic objectForKey:@"email"];
    
    if ([dic objectForKey:@"onCreated"] != nil)
        _onCreated = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"onCreated"] longValue]];
    
    if ([dic objectForKey:@"isActive"] != nil)
        _isActive = [NSString stringWithFormat:@"%d", [[dic objectForKey:@"isActive"] intValue]];
    
    if ([dic objectForKey:@"creator_id"] != nil)
        _creator_id = [NSString stringWithFormat:@"%d", [[dic objectForKey:@"creator_id"] intValue]];
    
    return self;
}


@end
