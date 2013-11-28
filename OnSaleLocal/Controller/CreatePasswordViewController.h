//
//  CreatePasswordViewController.h
//  OnSaleLocal
//
//  Created by tiankong360 on 13-10-7.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "BaseViewController.h"

@interface CreatePasswordViewController : BaseViewController
@property (nonatomic,strong) NSString * email;
@property (nonatomic,strong) NSString * zipcode;
@property (nonatomic)BOOL isFromSetting;
@end
