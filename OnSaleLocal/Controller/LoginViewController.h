//
//  LoginViewController.h
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-16.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController
@property (nonatomic)BOOL isEmail;
@property (nonatomic)BOOL isBack;
@property (nonatomic)BOOL isFromSetting;

@property (nonatomic,assign) BOOL isQukyLogin;
@end
