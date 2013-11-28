//
//  StoreOfferView.h
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-26.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreOfferView : UIView
@property (nonatomic,strong) UIImageView * IV_imageview;
@property (nonatomic,strong) UILabel * L_storename;
@property (nonatomic,strong) UITextField * TF_time;
@property (nonatomic,strong) UIImageView * IV_share;
@property (nonatomic,strong) UIImageView * IV_collect;
@property (nonatomic,strong) UIImageView * IV_call;
@property (nonatomic,strong) UILabel * L_collectNumber;
@property (nonatomic,strong) UILabel * L_distance;
@property (nonatomic,strong) UILabel * L_title;

- (id)initWithFrame:(CGRect)frame andImageHeigh:(float)aHeigh andWeigh:(float)aWeigh;
@end
