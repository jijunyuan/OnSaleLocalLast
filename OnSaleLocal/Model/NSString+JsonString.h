//
//  NSString+JsonString.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-17.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JsonString)
+(NSArray *)ConverfromData:(NSData *)aData name:(NSString *)aName;
+(NSString *)ConverStringfromData:(NSData *)aData name:(NSString *)aName;
+(NSString *)ErrorCodeAndErrorMsgFromReciveData:(NSData *)aReciveData;
@end
