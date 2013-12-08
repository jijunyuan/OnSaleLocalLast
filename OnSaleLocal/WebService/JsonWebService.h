//
//  JsonWebService.h
//  OnSaleLocal
//
//  Created by Kevin Zhang on 12/7/13.
//  Copyright (c) 2013 junyuan ji. All rights reserved.
//

#import "BaseWebService.h"

@interface JsonWebService : BaseWebService

+(void) jsonGet:(NSString *)url
      onSuccess:(void (^)(ASIHTTPRequest *req, NSDictionary *respDict))successBlock
        onError:(void (^)(ASIHTTPRequest *req))errorBlock
;

+(void) jsonPost:(NSString *)url postDict:(NSDictionary *)dict
       onSuccess:(void (^)(ASIHTTPRequest *req, NSDictionary *respDict))successBlock
         onError:(void (^)(ASIHTTPRequest *req))errorBlock
;

@end
