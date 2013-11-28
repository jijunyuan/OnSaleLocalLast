//
//  PictureDetailViewController.h
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-28.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "BaseViewController.h"

@interface PictureDetailViewController : BaseViewController
@property (nonatomic,strong) NSData * imageData;
@property (nonatomic,strong) NSString * classId;
@property (nonatomic)double lat;
@property (nonatomic)double longt;
@end
