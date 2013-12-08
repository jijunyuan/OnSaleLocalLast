//
//  WSObject.m
//  OnSaleLocal
//
//  Created by Kevin Zhang on 12/7/13.
//  Copyright (c) 2013 junyuan ji. All rights reserved.
//

#import "WSObject.h"
#import "NSString+Json.h"
#import <objc/runtime.h>

@implementation WSObject

-(NSString *) toJson
{
    return [NSString jsonStringWithDictionary:[self toDict]];
}

- (NSDictionary *) toDict
{
    
    Class clazz = [self class];
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray* valueArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        objc_property_t prop=properties[i];
        const char* propertyName = property_getName(prop);
        [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        id value =  [self performSelector:NSSelectorFromString([NSString stringWithUTF8String:propertyName])];
        if(value ==nil)
            [valueArray addObject:@""];
        else {
            [valueArray addObject:value];
        }
    }
    free(properties);
    NSDictionary* dtoDic = [NSDictionary dictionaryWithObjects:valueArray forKeys:propertyArray];
    return dtoDic;
}

-(id)initWithData:(NSDictionary *)result
{
    [self dictionaryForObject:result];
    return self;
}

- (void)dictionaryForObject:(NSDictionary*) dict
{
    for (NSString *key in [dict allKeys]) {
        id value = [dict objectForKey:key];
        
        if (value==[NSNull null]) {
            continue;
        }
        if ([value isKindOfClass:[NSDictionary class]]) {
            id subObj = [self valueForKey:key];
            if (subObj)
                [subObj dictionaryForObject:value];
        }
        else{
            Class clazz = [self class];
            objc_property_t property = class_getProperty(clazz, [key cString]);
            if(property) {
                [self setValue:value forKeyPath:key];
            }
        }
    }
}

@end
