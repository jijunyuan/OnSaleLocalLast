//
//  RateAppViewController.m
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-29.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "RateAppViewController.h"

@interface RateAppViewController ()

@end

@implementation RateAppViewController

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
    
    self.l_navTitle.text = @"Rate App";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *  path = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=1&type=Purple+Software",APP_ID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
    });
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
