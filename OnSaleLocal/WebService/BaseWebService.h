//
//  BaseViewController.h
//  shopplus
//
//  Created by Kevin Zhang on 11/29/13.
//  Copyright (c) 2013 Gaoshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseWebService : NSObject

+(void) strGet:(NSString *)url
     onSuccess:(void (^)(ASIHTTPRequest *req, NSString *respData))successBlock
       onError:(void (^)(ASIHTTPRequest *req))errorBlock
;

+(void) strPost:(NSString *)url postData:(NSMutableData *)data
      onSuccess:(void (^)(ASIHTTPRequest *req, NSString *respData))successBlock
        onError:(void (^)(ASIHTTPRequest *req))errorBlock
;

@end
