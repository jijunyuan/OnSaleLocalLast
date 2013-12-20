//
//  BuyNowViewController.m
//  OnSaleLocal
//
//  Created by tiankong360 on 13-10-29.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "BuyNowViewController.h"

@interface BuyNowViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) IBOutlet UIWebView * myWebView;
@end

@implementation BuyNowViewController
@synthesize myWebView;
@synthesize buyUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    self.l_navTitle.font = [UIFont fontWithName:AllFontBold size:All_h2_size];
    self.l_navTitle.text = [@"Buy Now" uppercaseString];
    self.myWebView.delegate = self;
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.buyUrl]]];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MyActivceView startAnimatedInView2:self.view];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MyActivceView stopAnimatedInView:self.view];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MyActivceView stopAnimatedInView:self.view];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
