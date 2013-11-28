//
//  MyActivceView.m
//  LocalService
//
//  Created by x f on 13-3-14.
//  Copyright (c) 2013年 tjg. All rights reserved.
//

#import "MyActivceView.h"
#import <QuartzCore/QuartzCore.h>

#define LOAD_TIME 20

@interface MyActivceView()
+(UIActivityIndicatorView *)loadMyProgressView;
@end

@implementation MyActivceView

+(UIActivityIndicatorView *)loadMyProgressView
{
    UIActivityIndicatorView *active = [[UIActivityIndicatorView alloc] init];
    if (iPad) {
        active.frame=CGRectMake(344, [UIScreen mainScreen].bounds.size.height/2-40, 80, 80);
    }
    else
    {
        active.frame=CGRectMake(120, [UIScreen mainScreen].bounds.size.height/2-40, 80, 80);
    }

    active.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
   // active.backgroundColor = [UIColor blackColor];
    active.alpha = 1.0;
   // active.layer.borderWidth = 1;
    active.layer.borderColor = [UIColor grayColor].CGColor;
    active.layer.cornerRadius = 5;
    return active;
}
+(UIActivityIndicatorView *)loadMyProgressView1
{
    UIActivityIndicatorView *active = [[UIActivityIndicatorView alloc] init];
    if (iPad) {
        active.frame=CGRectMake(344, [UIScreen mainScreen].bounds.size.height/2-40, 80, 80);
    }
    else
    {
        active.frame=CGRectMake(120, [UIScreen mainScreen].bounds.size.height/2-40, 80, 80);
    }
    
    active.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    //active.backgroundColor = [UIColor whiteColor];
    active.alpha = 1.0;
    //active.layer.borderWidth = 1;
    active.layer.borderColor = [UIColor grayColor].CGColor;
    active.layer.cornerRadius = 5;
    return active;
}
+(UIActivityIndicatorView *)loadMyProgressView2
{
    UIActivityIndicatorView *active = [[UIActivityIndicatorView alloc] init];
    if (iPad) {
        active.frame=CGRectMake(344, [UIScreen mainScreen].bounds.size.height/2-40, 80, 80);
    }
    else
    {
        active.frame=CGRectMake(120, [UIScreen mainScreen].bounds.size.height/2-40, 80, 80);
    }
    
    active.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    //active.backgroundColor = [UIColor whiteColor];
    active.alpha = 1.0;
    //active.layer.borderWidth = 1;
    active.layer.borderColor = [UIColor grayColor].CGColor;
    active.layer.cornerRadius = 5;
    return active;
}
+(void)startAnimatedInView2:(UIView *)aView
{
    aView.userInteractionEnabled=NO;
    UIActivityIndicatorView * active = [MyActivceView loadMyProgressView2];
    [aView addSubview:active];
    [active startAnimating];
}
+(void)startAnimatedInView1:(UIView *)aView
{
    aView.userInteractionEnabled=NO;
    UIActivityIndicatorView * active = [MyActivceView loadMyProgressView1];
    [aView addSubview:active];
    [active startAnimating];
}
+(void)startAnimatedInView:(UIView *)aView
{
    aView.userInteractionEnabled=NO;
    UIActivityIndicatorView * active = [MyActivceView loadMyProgressView];
    [aView addSubview:active];
    [active startAnimating];
}
+(void)stopAnimatedInView:(UIView *)aView
{
    aView.userInteractionEnabled=YES;
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
