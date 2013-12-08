//
//  ShopplusAPI.h
//  shopplus
//
//  Created by Kevin Zhang on 11/29/13.
//  Copyright (c) 2013 Gaoshin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BASE_URL @"http://onsalelocal.com/osl2"

@interface ShopplusAPI : NSObject

+ (NSString *) apiUserGetMeUrl;
+ (NSString *) apiUserLoginUrl;
+ (NSString *) apiUserLogoutUrl;
+ (NSString *) apiTrendUrl :(NSString *)location offset:(int)offset size:(int)size;

@end
