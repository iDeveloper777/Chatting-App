//
//  ServiceDataModel.h
//  Nodchat
//
//  Created by Csaba Toth on 21/05/15.
//  Copyright (c) 2015 Digi. All rights reserved.
//

#import "ServiceDataModel.h"

@implementation ServiceDataModel

- (instancetype) initUserData{
    _id = @"";
    _name = @"";
    _url= @"";
    _email = @"";
    _photo = @"";
   
    return self;
}

- (instancetype) initUserWithDic:(NSDictionary *)dic{
    _id = @"";
    _name = @"";
    _url= @"";
    _email = @"";
    _photo = @"";
    
    if ([dic objectForKey:@"id"] != nil)
        _id = [NSString stringWithFormat:@"%ld", [[dic objectForKey:@"id"] longValue]];
    
    NSString *str;
    str = [dic objectForKey:@"name"];
    if (str != nil && [str isKindOfClass:[NSString class]])
         _name = [dic objectForKey:@"name"];
    
    str = [dic objectForKey:@"url"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _url = [dic objectForKey:@"url"];
    
    str = [dic objectForKey:@"email"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _email = [dic objectForKey:@"email"];
    
    str = [dic objectForKey:@"photo"];
    if (str != nil && [str isKindOfClass:[NSString class]])
        _photo = [dic objectForKey:@"photo"];
    
    return self;
}

@end
