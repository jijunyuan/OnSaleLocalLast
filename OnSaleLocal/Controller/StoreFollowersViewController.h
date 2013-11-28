//
//  StoreFollowersViewController.h
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-29.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "BaseViewController.h"

@class MeRootViewController;
@interface StoreFollowersViewController : BaseViewController
@property (nonatomic,strong) NSString * userid;
@property (nonatomic) BOOL isLikes;
@property (nonatomic,strong) MeRootViewController * meRootController;
@end
