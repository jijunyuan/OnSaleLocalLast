//
//  BaseViewController.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-19.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize l_navTitle;
@synthesize rightBtn;
@synthesize backBtn;
@synthesize bgView;

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
    self.bgView = view1;
    view1.backgroundColor = [UIColor whiteColor];
    view1.alpha = 0.85;
    [self.view addSubview:view1];
    
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
    view2.alpha = 0.85;
    view2.backgroundColor = [UIColor colorWithRed:60.0/255.0 green:60.0/255.0 blue:60.0/255.0 alpha:1.0];
    [self.view addSubview:view2];
    
    UIButton * backBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn = backBtn1;
    [backBtn1 addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    backBtn1.showsTouchWhenHighlighted = YES;
    backBtn1.frame = CGRectMake(10, 7, 30, 30);
    backBtn1.backgroundColor = [UIColor clearColor];
    [backBtn1 setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [view1 addSubview:backBtn1];
    
    UIButton * rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.rightBtn = rightBtn1;
    rightBtn1.showsTouchWhenHighlighted = YES;
    rightBtn1.frame = CGRectMake(280, 7, 30, 30);
    rightBtn1.backgroundColor = [UIColor clearColor];
    [view1 addSubview:rightBtn1];
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(80, 7, 160, 30)];
    lab.font = [UIFont fontWithName:AllFont size:AllFontSize];
    self.l_navTitle = lab;
   // lab.font = [UIFont systemFontOfSize:20];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor colorWithRed:237.0/255.0 green:28.0/255.0 blue:36.0/255.0 alpha:1.0];
    [view1 addSubview:lab];
}
-(void)backClick:(UIButton *)aButton
{
   // [self.navigationController popViewControllerAnimated:YES];
    //AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    //JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionMoveIn;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
   // [controller showLeftPanelAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
