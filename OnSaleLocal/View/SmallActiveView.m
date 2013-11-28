//
//  SmallActiveView.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-14.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "SmallActiveView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SmallActiveView
+(UIActivityIndicatorView *)loadMyProgressView
{
    UIActivityIndicatorView *active = [[UIActivityIndicatorView alloc] init];
    active.frame=CGRectMake(52, 25, 40, 40);
    active.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    return active;
}
+(void)startAnimatedInView:(UIView *)aView
{
    UIActivityIndicatorView * active = [SmallActiveView loadMyProgressView];
    [aView addSubview:active];
    [active startAnimating];
}
+(void)stopAnimatedInView:(UIView *)aView
{
    NSArray * arr = [aView subviews];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIActivityIndicatorView class]])
        {
            UIActivityIndicatorView * active = (UIActivityIndicatorView *)obj;
            [active stopAnimating];
        }
    }];
}

@end
