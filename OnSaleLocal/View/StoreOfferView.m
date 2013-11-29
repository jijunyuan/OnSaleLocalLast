//
//  StoreOfferView.m
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-26.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "StoreOfferView.h"
#import <QuartzCore/QuartzCore.h>

@implementation StoreOfferView
@synthesize IV_call,IV_collect,IV_imageview,IV_share,L_storename,TF_time,L_collectNumber;
@synthesize L_title;

- (id)initWithFrame:(CGRect)frame andImageHeigh:(float)aHeigh andWeigh:(float)aWeigh
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        
        UIImageView * imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake((294-aWeigh)/2.0+3, 3, aWeigh-6, aHeigh)];
        imageView1.backgroundColor = [UIColor clearColor];
        self.IV_imageview = imageView1;
        [self addSubview:imageView1];
        
        UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(7, aHeigh+8, 280, 20)];
        self.L_title = titleLab;
        titleLab.font = [UIFont fontWithName:AllFont size:AllContentSize];;
        titleLab.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLab];
        
        aHeigh = aHeigh+20;
        
        UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(7, aHeigh+10, 183, 40)];
        self.L_storename = name;
        name.font = [UIFont fontWithName:AllFont size:AllContentSize];
        name.numberOfLines = 2;
        name.backgroundColor = [UIColor clearColor];
        [self addSubview:name];
        
        UIImageView * adressImage = [[UIImageView alloc] initWithFrame:CGRectMake(190, aHeigh+20, 18, 20)];
        adressImage.image = [UIImage imageNamed:@"location.png"];
        [self addSubview:adressImage];
        
        UILabel * distanceLab = [[UILabel alloc] initWithFrame:CGRectMake(210, aHeigh+15, 55, 30)];
        self.L_distance = distanceLab;
        distanceLab.backgroundColor = [UIColor clearColor];
        distanceLab.textColor = [UIColor blackColor];
        distanceLab.font = [UIFont fontWithName:AllFont size:AllContentSize];
        [self addSubview:distanceLab];

        
        UITextField * txtfield = [[UITextField alloc] initWithFrame:CGRectMake(57, aHeigh+60, 180, 25)];
        self.TF_time = txtfield;
        txtfield.userInteractionEnabled = NO;
        txtfield.textAlignment = NSTextAlignmentCenter;
        txtfield.layer.borderWidth = 1;
        txtfield.textColor = [UIColor colorWithRed:196.0/255.0 green:196.0/255.0 blue:196.0/255.0 alpha:1.0];
        txtfield.layer.borderColor = [UIColor colorWithRed:196.0/255.0 green:196.0/255.0 blue:196.0/255.0 alpha:1.0].CGColor;
        txtfield.font = [UIFont fontWithName:AllFont size:AllContentSize-2];
        [self addSubview:txtfield];
        
        UIImageView * imageView_share = [[UIImageView alloc] initWithFrame:CGRectMake(7, aHeigh+90, 30, 30)];
        imageView_share.image = [UIImage imageNamed:@"share.png"];
        self.IV_share = imageView_share;
        [self addSubview:imageView_share];
        
        UIImageView * imageView_collect = [[UIImageView alloc] initWithFrame:CGRectMake(120, aHeigh+90, 30, 30)];
        imageView_collect.image = [UIImage imageNamed:@"like.png"];
        self.IV_collect = imageView_collect;
        [self addSubview:imageView_collect];
        
        UILabel * labLike = [[UILabel alloc] initWithFrame:CGRectMake(160, aHeigh+93, 40, 30)];
        self.L_collectNumber = labLike;
        labLike.backgroundColor = [UIColor clearColor];
        labLike.font = [UIFont fontWithName:AllFont size:AllContentSize];
        [self addSubview:labLike];
        
        UIImageView * imageView_call = [[UIImageView alloc] initWithFrame:CGRectMake(257, aHeigh+90, 30, 30)];
        imageView_call.userInteractionEnabled = YES;
        imageView_call.image = [UIImage imageNamed:@"call.png"];
        self.IV_call = imageView_call;
        [self addSubview:imageView_call];
        
        UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, aHeigh+133, 294, 20)];
        view1.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
        [self addSubview:view1];
    }
    return self;
}


@end
