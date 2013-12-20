//
//  PictureDoneViewController.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-29.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "PictureDoneViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "JASidePanelController.h"
#import "UploadPictureViewController.h"
#import "SafewayViewController.h"
#import "TrendDetailViewController.h"

@interface PictureDoneViewController ()
@property (nonatomic,strong) IBOutlet UIButton * bt1;
@property (nonatomic,strong) IBOutlet UIButton * bt2;
-(IBAction)GoToThisIdea:(id)sender;
-(IBAction)ShareThisIdea:(id)sender;
@end

@implementation PictureDoneViewController
@synthesize dic,storeId,storeName;
@synthesize bt1,bt2;

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
    self.l_navTitle.font = [UIFont fontWithName:AllFontBold size:All_h2_size];
    self.l_navTitle.text = [@"Done" uppercaseString];
    
    self.bt1.titleLabel.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.bt2.titleLabel.font = [UIFont fontWithName:AllFont size:AllContentSize];
    
    if ([WebService ISIOS7])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(IBAction)GoToThisIdea:(id)sender
{
    TrendDetailViewController * trend;
    if (iPhone5)
    {
        trend = [[TrendDetailViewController alloc] initWithNibName:@"TrendDetailViewController" bundle:nil];
    }
    else
    {
       trend = [[TrendDetailViewController alloc] initWithNibName:@"TrendDetailViewController4" bundle:nil];
    }
//    trend.dic = self.dic;
//    NSLog(@"self.dic = %@",self.dic);
    
    trend.userId_notification = [self.dic valueForKey:@"id"];
    NSLog(@"trend1.userId_notification = %@",trend.userId_notification);
    trend.isNotification = YES;
    trend.isFromNotification = YES;
    
    trend.isClick = NO;
    [self.navigationController pushViewController:trend animated:YES];
}
-(IBAction)ShareThisIdea:(id)sender
{
    for (UIViewController * controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[UploadPictureViewController class]])
        {
          UploadPictureViewController * controller1 = (UploadPictureViewController *)controller;
            controller1.imageView.image = nil;
          [self.navigationController popToViewController:controller1 animated:YES];
        }
    }
}
-(void)backClick:(UIButton *)aButton
{
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    JASidePanelController * controller1 = (JASidePanelController *)delegate.viewController1;
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [controller1 showLeftPanelAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
