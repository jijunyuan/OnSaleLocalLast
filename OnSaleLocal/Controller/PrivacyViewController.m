//
//  PrivacyViewController.m
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-29.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "PrivacyViewController.h"

@interface PrivacyViewController ()

@end

@implementation PrivacyViewController

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
    self.l_navTitle.font = [UIFont fontWithName:AllFontBold size:All_h2_size];
	self.l_navTitle.text = [@"Privacy" uppercaseString];
    
    self.myWebView.scrollView.bounces = NO;
    
//    NSString * str = [[NSBundle mainBundle] pathForResource:@"about-privacy" ofType:@"html"];
//    NSString * content = [NSString stringWithContentsOfFile:str encoding:4 error:nil];
//    [self.myWebView loadHTMLString:content baseURL:nil];
    NSString * formatStr = [NSString stringWithFormat:@"%@/privacy.html",DO_MAIN];
    NSURLRequest * request= [NSURLRequest requestWithURL:[NSURL URLWithString:formatStr]];
    [self.myWebView loadRequest:request];
}



@end
