//
//  TrendDetailViewController.h
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-20.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "BaseViewController.h"

@class  SafewayViewController;
@class ViewController;
@class MeRootViewController;

@interface TrendDetailViewController : BaseViewController
@property (nonatomic,strong) NSDictionary * dic;
@property (nonatomic) BOOL isClick;
@property (nonatomic) int likenumber;
@property (nonatomic,assign) BOOL isSafeway;
@property (nonatomic,strong) NSMutableDictionary * dic_recode;
@property (nonatomic,strong) SafewayViewController * safewayController;
@property (nonatomic) BOOL isFromTrendStore;
@property (nonatomic,strong) ViewController * viewController1;
@property (nonatomic,strong) MeRootViewController * meRootController;

@property (nonatomic,strong) NSMutableDictionary * dic_lab_number;
@property (nonatomic) BOOL isFromNotification;
@property (nonatomic,strong) NSString * userId_notification;



@property (nonatomic)BOOL isNotification;
@end
