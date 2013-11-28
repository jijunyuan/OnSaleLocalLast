//
//  MeViewController.h
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-14.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowsViewController.h"

@class MeRootViewController;
@interface MeViewController : FollowsViewController

@property (nonatomic,strong) NSString * userId;
@property (nonatomic,strong) MeRootViewController * meRootController;
-(void)getData;
@end
