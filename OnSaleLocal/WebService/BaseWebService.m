//
//  BaseViewController.m
//  shopplus
//
//  Created by Kevin Zhang on 11/29/13.
//  Copyright (c) 2013 Gaoshin. All rights reserved.
//

#import "BaseWebService.h"
#import "ASIHTTPRequest.h"

@implementation BaseWebService

#pragma mark - asihttp
+(void) strGet:(NSString *)url
                  onSuccess:(void (^)(ASIHTTPRequest *req, NSString *respData))successBlock
                  onError:(void (^)(ASIHTTPRequest *req))errorBlock
{
    int timeOutSec = 30;
    __block ASIHTTPRequest *httpreq = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [httpreq setUseCookiePersistence:YES];
    
    [httpreq setTimeOutSeconds:timeOutSec];
    
    [httpreq setCompletionBlock:^{
        if([httpreq responseStatusCode] == 200) {
            NSString *responseString = [[NSString alloc]initWithData:[httpreq responseData] encoding:NSUTF8StringEncoding];
            successBlock(httpreq, responseString);
        }
        else {
            errorBlock(httpreq);
        }
        httpreq = nil;
    }];
    
    [httpreq setFailedBlock:^{
        NSLog(@"errorUrl:%@",httpreq.url);
        errorBlock(httpreq);
        httpreq = nil;
    }];
    
}

+(void) strPost:(NSString *)url postData:(NSMutableData *)data
                   onSuccess:(void (^)(ASIHTTPRequest *req, NSString *respData))successBlock
                     onError:(void (^)(ASIHTTPRequest *req))errorBlock
{
    int timeOutSec = 30;
    __block ASIHTTPRequest *httpreq = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [httpreq setUseCookiePersistence:YES];
    [httpreq setRequestMethod:@"POST"];
    [httpreq setTimeOutSeconds:timeOutSec];

    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    [headers setValue:@"application/json" forKey:@"Content-type"];
    [headers setValue:@"application/json" forKey:@"Accept"];
    [httpreq setRequestHeaders:headers];

    if(data) {
        [httpreq setPostBody:data];
    }
    
    [httpreq setCompletionBlock:^{
        if([httpreq responseStatusCode] == 200) {
            NSString *responseString = [[NSString alloc]initWithData:[httpreq responseData] encoding:NSUTF8StringEncoding];
            successBlock(httpreq, responseString);
        }
        else {
            errorBlock(httpreq);
        }
        httpreq = nil;
    }];
    
    [httpreq setFailedBlock:^{
        NSLog(@"errorUrl:%@", httpreq.url);
        errorBlock(httpreq);
        httpreq = nil;
    }];
    
}


@end
