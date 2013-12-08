//
//  WSObject.h
//  OnSaleLocal
//
//  Created by Kevin Zhang on 12/7/13.
//  Copyright (c) 2013 junyuan ji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSObject : NSObject

-(id)initWithData:(NSDictionary *)result;

-(NSString *) toJson;

- (NSDictionary *) toDict;

@end
