//
//  BaseViewController.h
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-19.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic,strong) UILabel * l_navTitle;
@property (nonatomic,strong) UIButton * rightBtn;
@property (nonatomic,strong) UIButton * backBtn;
@property (nonatomic,strong) UIView * bgView;
-(void)backClick:(UIButton *)aButton;

@end
