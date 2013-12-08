//
//  ObjWebService.h
//  OnSaleLocal
//
//  Created by Kevin Zhang on 12/8/13.
//  Copyright (c) 2013 junyuan ji. All rights reserved.
//

#import "JsonWebService.h"
#import "WSObject.h"

@interface ObjWebService : JsonWebService

+(void) objGet:(NSString *)url
   respClsName:(NSString *)clsName
      onSuccess:(void (^)(ASIHTTPRequest *req, WSObject *respObj))successBlock
        onError:(void (^)(ASIHTTPRequest *req))errorBlock
;

+(void) objPost:(NSString *)url postObj:(WSObject *)reqObj
    respClsName:(NSString *)clsName
       onSuccess:(void (^)(ASIHTTPRequest *req, WSObject *respObj))successBlock
         onError:(void (^)(ASIHTTPRequest *req))errorBlock
;

@end
