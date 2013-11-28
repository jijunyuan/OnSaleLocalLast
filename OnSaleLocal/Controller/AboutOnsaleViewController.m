//
//  AboutOnsaleViewController.m
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-29.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "AboutOnsaleViewController.h"

@interface AboutOnsaleViewController ()

@end

@implementation AboutOnsaleViewController
@synthesize myWebView;

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
    
    self.l_navTitle.text = @"OnsaleLocal";
    
    self.myWebView.scrollView.bounces = NO;
    
    NSString * formatStr = [NSString stringWithFormat:@"%@/about.html",DO_MAIN];
 //   NSString * str = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
   // NSString * content = [NSString stringWithContentsOfFile:str encoding:4 error:nil];
    //[self.myWebView loadHTMLString:content baseURL:nil];
    NSURLRequest * request= [NSURLRequest requestWithURL:[NSURL URLWithString:formatStr]];
    [self.myWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
