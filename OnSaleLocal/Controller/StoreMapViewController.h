//
//  StoreMapViewController.h
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-26.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "BaseViewController.h"

@interface StoreMapViewController : BaseViewController
@property (nonatomic,assign) float lat;
@property (nonatomic,assign) float longt;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * merchantId;
@property (nonatomic,strong) NSMutableDictionary * dic;
@end
