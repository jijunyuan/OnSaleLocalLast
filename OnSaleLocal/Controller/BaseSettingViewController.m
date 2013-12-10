//
//  BaseSettingViewController.m
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-14.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "BaseSettingViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "JASidePanelController.h"

@interface BaseSettingViewController ()

@end

@implementation BaseSettingViewController
@synthesize l_navTitle;
@synthesize rightBtn;
@synthesize leftButton;

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
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    view1.backgroundColor = [UIColor whiteColor];
    view1.alpha = 0.85;
    [self.view addSubview:view1];
    
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
    view2.alpha = 0.85;
    view2.backgroundColor = [UIColor colorWithRed:60.0/255.0 green:60.0/255.0 blue:60.0/255.0 alpha:1.0];
    [view1 addSubview:view2];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    self.leftButton = backBtn;
    backBtn.showsTouchWhenHighlighted = YES;
    backBtn.frame = CGRectMake(10, 2, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [view1 addSubview:backBtn];
    
    UIButton * rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn = rightBtn1;
    rightBtn1.showsTouchWhenHighlighted = YES;
    rightBtn1.frame = CGRectMake(260, 7, 50, 30);
    [view1 addSubview:rightBtn1];
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(80, 7, 160, 30)];
    self.l_navTitle = lab;
   // lab.font = [UIFont systemFontOfSize:20];
    lab.font = [UIFont fontWithName:AllFont size:All_h2_size];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor colorWithRed:178.0/255.0 green:0 blue:0 alpha:1.0];
    [view1 addSubview:lab];
    
   // UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backClick:)];
    UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backClick:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
    
}
-(void)backClick:(UIButton *)aButton
{
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
    [controller showLeftPanelAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
