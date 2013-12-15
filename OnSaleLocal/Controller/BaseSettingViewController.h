//
//  BaseSettingViewController.h
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-14.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OslUIViewController.h"

@interface BaseSettingViewController : OslUIViewController
@property (nonatomic,strong) UILabel * l_navTitle;
@property (nonatomic,strong) UIButton * rightBtn;
@property (nonatomic,strong) UIButton * leftButton;
-(void)backClick:(UIButton *)aButton;
@end
