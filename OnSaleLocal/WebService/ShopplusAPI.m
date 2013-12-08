//
//  ShopplusAPI.m
//  shopplus
//
//  Created by Kevin Zhang on 11/29/13.
//  Copyright (c) 2013 Gaoshin. All rights reserved.
//

#import "ShopplusAPI.h"

@implementation ShopplusAPI

+ (NSString *) apiUserGetMeUrl
{
    return [NSString stringWithFormat:@"%@/ws/user/me", BASE_URL];
}

+ (NSString *) apiUserLoginUrl
{
    return [NSString stringWithFormat:@"%@/ws/user/login", BASE_URL];
}

+ (NSString *) apiUserLogoutUrl
{
    return [NSString stringWithFormat:@"%@/ws/user/logout", BASE_URL];
}

+ (NSString *) apiTrendUrl :(NSString *)location offset:(int)offset size:(int)size
{
    NSArray * loc = [location componentsSeparatedByString:@","];
    NSString *latitude = @"37.3575479";
    NSString *longitude = @"-122.0226";
    if(loc.count > 1) {
        latitude = [loc objectAtIndex:0];
        longitude = [loc objectAtIndex:1];
    }
    return [NSString stringWithFormat:@"%@/ws/v2/trend?latiude=%@&longitude=%@&offset=%d&size=%d", BASE_URL, latitude, longitude, offset, size];
}


@end
