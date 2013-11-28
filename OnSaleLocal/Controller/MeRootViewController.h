//
//  MeRootViewController.h
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-29.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "BaseSettingViewController.h"

@interface MeRootViewController : BaseSettingViewController
@property (nonatomic,strong) NSString * userid;
@property (nonatomic)BOOL isLoading;
@property (nonatomic,strong) NSString * followNumLabNum;
@property (nonatomic,strong) NSString * followingLabNum;
@property (nonatomic,strong) NSString * storefollowsNum;
@property (nonatomic)BOOL isFromSetting;


@property (nonatomic) BOOL isNotification;
@end
