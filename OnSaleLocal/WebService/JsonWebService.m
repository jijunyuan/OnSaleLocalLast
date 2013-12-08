//
//  JsonWebService.m
//  OnSaleLocal
//
//  Created by Kevin Zhang on 12/7/13.
//  Copyright (c) 2013 junyuan ji. All rights reserved.
//

#import "JsonWebService.h"
#import "NSString+Json.h"

@implementation JsonWebService

+(void) jsonGet:(NSString *)url
      onSuccess:(void (^)(ASIHTTPRequest *req, NSDictionary *respDict))successBlock
        onError:(void (^)(ASIHTTPRequest *req))errorBlock
{
    [BaseWebService strGet:url
                onSuccess:^(ASIHTTPRequest *req, NSString *respData){
                    NSError *error;
                    NSData *data = [respData dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                    if (json == nil) {
                        errorBlock(req);
                    }
                    else {
                        successBlock(req, json);
                    }
                }
     
                  onError:errorBlock
     ];
}


+(void) jsonPost:(NSString *)url postDict:(NSDictionary *)dict
       onSuccess:(void (^)(ASIHTTPRequest *req, NSDictionary *respData))successBlock
         onError:(void (^)(ASIHTTPRequest *req))errorBlock
{
    NSString *json = [NSString jsonStringWithDictionary:dict];
    NSMutableData *data = [[json dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    [BaseWebService strPost:url postData:data
                 onSuccess:^(ASIHTTPRequest *req, NSString *respData){
                     NSError *error;
                     NSData *data = [respData dataUsingEncoding:NSUTF8StringEncoding];
                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                     if (json == nil) {
                         errorBlock(req);
                     }
                     else {
                         successBlock(req, json);
                     }
                 }
     
                   onError:errorBlock
     ];
}


@end
