//
//  AboutBackViewController.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-30.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "AboutBackViewController.h"

@interface AboutBackViewController ()

@end

@implementation AboutBackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([WebService ISIOS7])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.l_navTitle.text = @"Feedback";
    self.myWebView.scrollView.bounces = NO;
    NSString * formatStr = [NSString stringWithFormat:@"%@/contact.html",DO_MAIN];
    NSURLRequest * request= [NSURLRequest requestWithURL:[NSURL URLWithString:formatStr]];
    [self.myWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
