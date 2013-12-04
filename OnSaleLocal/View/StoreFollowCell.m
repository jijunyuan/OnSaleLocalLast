//
//  StoreFollowCell.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-29.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "StoreFollowCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation StoreFollowCell
@synthesize mapview,L_name,L_homedown,Btn_follow;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
        
        MKMapView * mao = [[MKMapView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        self.mapview = mao;
        [self addSubview:mao];
        
        UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(75, 15, 220, 20)];
        self.L_name = name;
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont fontWithName:AllFont size:AllContentSize];
        [self addSubview:name];
        
        UILabel * home = [[UILabel alloc] initWithFrame:CGRectMake(75, 35, 185, 15)];
        self.L_homedown = home;
        home.backgroundColor = [UIColor clearColor];
        home.font = [UIFont fontWithName:AllFont size:AllContentSize];
        home.textColor = [UIColor colorWithRed:108.0/255.0 green:108.0/255.0 blue:108.0/255.0 alpha:1.0];
        [self addSubview:home];
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(75, 50, 20, 20)];
        self.IV_image = image;
        [self addSubview:image];
        
        UILabel * phone = [[UILabel alloc] initWithFrame:CGRectMake(100, 53, 160, 15)];
        self.L_phone = phone;
        phone.backgroundColor = [UIColor clearColor];
        phone.font = [UIFont fontWithName:AllFont size:AllContentSize];
        phone.textColor = [UIColor colorWithRed:108.0/255.0 green:108.0/255.0 blue:108.0/255.0 alpha:1.0];
        [self addSubview:phone];
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(278, 35, 30, 30)];
        self.Btn_follow = button;
        button.layer.cornerRadius = 12.5;
        [self addSubview:button];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
