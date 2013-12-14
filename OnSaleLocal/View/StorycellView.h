//
//  StorycellView.h
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-13.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLabel.h"

@interface StorycellView : UIView
@property (nonatomic,strong) UIImageView * imageView_story;
@property (nonatomic,strong) UIImageView * imageView_adress;
@property (nonatomic,strong) MSLabel * L_des;
@property (nonatomic,strong) UITextField * TF_time;
@property (nonatomic,strong) UILabel * L_Meter;
@property (nonatomic,strong) UILabel * L_collNum;
@property (nonatomic,strong) UIButton * Btn_share;
@property (nonatomic,strong) UIButton * Btn_collect;
@property (nonatomic,strong) UILabel * L_storename;
@property (nonatomic,strong) UIButton * Btn_temp;

@property (nonatomic,strong) NSString * idStr;

- (id)initWithFrame:(CGRect)frame andImageHeight:(float)aHeight andWidth:(float)aWidth;
@end
