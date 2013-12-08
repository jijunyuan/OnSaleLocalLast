//
//  OslWebService.h
//  OnSaleLocal
//
//  Created by Kevin Zhang on 12/7/13.
//  Copyright (c) 2013 junyuan ji. All rights reserved.
//

#import "ObjWebService.h"
#import "User.h"

@interface OslWebService : ObjWebService

+ (NSString *) baseUrl;

+ (void) registerIosPnId:(NSString *)token
               onSuccess:(void (^)(ASIHTTPRequest *req, NSDictionary *respDict))successBlock
                 onError:(void (^)(ASIHTTPRequest *req))errorBlock
;

+ (void) me:(void (^)(ASIHTTPRequest *req, User *ume))successBlock
    onError:(void (^)(ASIHTTPRequest *req))errorBlock
;

@end
