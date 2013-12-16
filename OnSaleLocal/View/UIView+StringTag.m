//
//  UIView+StringTag.m
//  OnSaleLocal
//
//  Created by Kevin Zhang on 12/16/13.
//  Copyright (c) 2013 junyuan ji. All rights reserved.
//

#import "UIView+StringTag.h"

#import <objc/runtime.h>

@implementation UIView (StringTagAdditions)
static NSString *kStringTagKey = @"StringTagKey";
- (NSString *)stringTag
{
    return objc_getAssociatedObject(self, CFBridgingRetain(kStringTagKey));
}
- (void)setStringTag:(NSString *)stringTag
{
    objc_setAssociatedObject(self, CFBridgingRetain(kStringTagKey), stringTag, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
