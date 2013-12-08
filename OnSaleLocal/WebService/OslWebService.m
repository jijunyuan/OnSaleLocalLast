//
//  OslWebService.m
//  OnSaleLocal
//
//  Created by Kevin Zhang on 12/7/13.
//  Copyright (c) 2013 junyuan ji. All rights reserved.
//

#import "OslWebService.h"

@implementation OslWebService

+ (NSString *)baseUrl
{
    static NSString *BASE_URL = @"http://onsalelocal.com/osl2";
    return BASE_URL;
}

+ (void) registerIosPnId:(NSString *)token
               onSuccess:(void (^)(ASIHTTPRequest *req, NSDictionary *respDict))successBlock
                 onError:(void (^)(ASIHTTPRequest *req))errorBlock
{
    NSString *url = [NSString stringWithFormat:@"%@/ws/user/register-ios-pn/%@", [OslWebService baseUrl], token];
    [JsonWebService jsonPost:url postDict:nil onSuccess:successBlock onError:errorBlock];
}

+ (void) me:(void (^)(ASIHTTPRequest *req, User *ume))successBlock
    onError:(void (^)(ASIHTTPRequest *req))errorBlock
{
    NSString *url = [NSString stringWithFormat:@"%@/ws/user/me", [OslWebService baseUrl]];
    [ObjWebService objGet:url respClsName:@"User"
                onSuccess:(void (^)(ASIHTTPRequest *req, WSObject *respObj))successBlock
                  onError:errorBlock];
}

@end
