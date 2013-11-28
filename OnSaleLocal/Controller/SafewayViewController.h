//
//  SafewayViewController.h
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-24.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "BaseViewController.h"

@class TrendDetailViewController;
@interface SafewayViewController : BaseViewController
@property (nonatomic,strong) NSString * merchantId;
@property (nonatomic,strong) NSString * merchanName;
@property (nonatomic,strong) TrendDetailViewController * trend;

@property (nonatomic) BOOL isNotification;

@property (nonatomic)BOOL isLoading;
@end
