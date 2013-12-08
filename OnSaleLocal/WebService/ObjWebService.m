//
//  ObjWebService.m
//  OnSaleLocal
//
//  Created by Kevin Zhang on 12/8/13.
//  Copyright (c) 2013 junyuan ji. All rights reserved.
//

#import "ObjWebService.h"

@implementation ObjWebService

+(void) objGet:(NSString *)url
   respClsName:(NSString *)clsName
     onSuccess:(void (^)(ASIHTTPRequest *req, WSObject *respObj))successBlock
       onError:(void (^)(ASIHTTPRequest *req))errorBlock
{
    [JsonWebService jsonGet:url
        onSuccess:^(ASIHTTPRequest *req, NSDictionary *respDict){
            if (!respDict) {
                errorBlock(req);
            }
            else {
                WSObject *resp = (WSObject *)[[NSClassFromString(clsName) alloc] init];
                resp = [resp initWithData:respDict];
                successBlock(req, resp);
            }
        }
        onError:errorBlock];
}

+(void) objPost:(NSString *)url postObj:(WSObject *)reqObj
    respClsName:(NSString *)clsName
      onSuccess:(void (^)(ASIHTTPRequest *req, WSObject *respObj))successBlock
        onError:(void (^)(ASIHTTPRequest *req))errorBlock
{
    [JsonWebService jsonPost:url
            postDict:[reqObj toDict]
            onSuccess:^(ASIHTTPRequest *req, NSDictionary *respDict){
                if (!respDict) {
                    errorBlock(req);
                }
                else {
                    WSObject *resp = (WSObject *)[[NSClassFromString(clsName) alloc] init];
                    resp = [resp initWithData:respDict];
                    successBlock(req, resp);
                }
            }
            onError:errorBlock];
}

@end
