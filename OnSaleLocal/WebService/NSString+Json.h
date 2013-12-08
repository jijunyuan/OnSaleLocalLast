//
//  NSString+Json.h
//  shopplus
//
//  Created by Kevin Zhang on 11/29/13.
//  Copyright (c) 2013 Gaoshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Json)

+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;
+(NSString *) jsonStringWithObject:(id) object;
+(NSString *) jsonStringWithString:(NSString *) string;
+(NSString *) jsonStringWithArray:(NSArray *)array;

@end
