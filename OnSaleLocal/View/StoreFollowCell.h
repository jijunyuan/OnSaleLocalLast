//
//  StoreFollowCell.h
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-29.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface StoreFollowCell : UITableViewCell
@property (nonatomic,strong) UIImageView * mapview;
@property (nonatomic,strong) UILabel * L_name;
@property (nonatomic,strong) UILabel * L_homedown;
@property (nonatomic,strong) UIButton * Btn_follow;
@property (nonatomic,strong) UILabel * L_phone;
@property (nonatomic,strong) UIImageView * IV_image;
@end
