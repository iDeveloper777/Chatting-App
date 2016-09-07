//
//  ExtendFunctions.h
//  Adplotter
//
//  Created by Csaba Toth on 31/05/15.
//  Copyright (c) 2015 Digi. All rights reserved.
//

#ifndef Nodchat_ExtendFunctions_h
#define Nodchat_ExtendFunctions_h

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>

@protocol ExtendFunctions
@end


@interface ExtendFunctions : NSObject

- (NSString *)generateSHA1:(NSString *)str;
- (NSString *)generateSHA256:(NSString *)str;

@end

#endif
