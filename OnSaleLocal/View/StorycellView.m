//
//  StorycellView.m
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-13.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "StorycellView.h"
#import <QuartzCore/QuartzCore.h>

@implementation StorycellView
@synthesize L_collNum;
@synthesize L_des;
@synthesize L_Meter;
@synthesize TF_time;
@synthesize imageView_story;
@synthesize Btn_collect;
@synthesize Btn_share;
@synthesize idStr;
@synthesize L_storename;
@synthesize imageView_adress;
@synthesize Btn_temp;

- (id)initWithFrame:(CGRect)frame andImageHeight:(float)aHeight andWidth:(float)aWidth;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor colorWithRed:229.0/255.0 green:226.0/255.0 blue:223.0/255.0 alpha:1.0].CGColor;
        self.layer.borderWidth = 5;
        float height1 = 0.0;
        if (aWidth == 0.0)
        {
            height1 = 0.0;
        }
        else
        {
            height1 = 150.0/aWidth*aHeight;
        }

        self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 150, height1)];
        self.imageView_story = imageView;
        [self addSubview:imageView];
        
        MSLabel * des = [[MSLabel alloc] initWithFrame:CGRectMake(8, height1+10, 128, 48)];
        des.textColor = [UIColor blackColor];
        //des.font = [UIFont systemFontOfSize:14];
        des.font = [UIFont fontWithName:AllFont size:AllContentSize];
        des.numberOfLines = 2;
        des.lineHeight = 18;
        des.backgroundColor = [UIColor clearColor];
        self.L_des = des;
        [self addSubview:des];
        
       // height1 = height1+5;
        UITextField * textfield = [[UITextField alloc] initWithFrame:CGRectMake(20, height1+50+3, 120, 30)];
        textfield.textColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0];
        textfield.textAlignment = NSTextAlignmentCenter;
        textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textfield.layer.borderWidth = 0.6;
        textfield.font = [UIFont fontWithName:AllFont size:AllContentSmallSize];
        textfield.layer.borderColor =[UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0].CGColor;
        textfield.userInteractionEnabled = NO;
        self.TF_time = textfield;
        [self addSubview:textfield];
        
        UILabel * safewayLab = [[UILabel alloc] initWithFrame:CGRectMake(8, height1+80+5, 84, 30)];
        self.L_storename = safewayLab;
        safewayLab.backgroundColor = [UIColor clearColor];
        safewayLab.textColor = [UIColor blackColor];
        safewayLab.font = [UIFont fontWithName:AllFont size:AllContentSize];
        [self addSubview:safewayLab];
        
        UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        self.Btn_temp = button1;
        button1.frame = CGRectMake(8, height1+80, 153, 30);
        [self addSubview:button1];
        
        UIImageView * adressImage = [[UIImageView alloc] initWithFrame:CGRectMake(92, height1+85+5, 18, 20)];
        self.imageView_adress = adressImage;
        adressImage.image = [UIImage imageNamed:@"location.png"];
        [self addSubview:adressImage];
        
        UILabel * distanceLab = [[UILabel alloc] initWithFrame:CGRectMake(110, height1+80+5, 55, 30)];
        self.L_Meter = distanceLab;
        distanceLab.textAlignment = NSTextAlignmentLeft;
        distanceLab.backgroundColor = [UIColor clearColor];
        distanceLab.textColor = [UIColor blackColor];
        distanceLab.font = [UIFont fontWithName:AllFont size:AllContentSmallSize+1];
        [self addSubview:distanceLab];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(8, height1+110+3, 144, 0.6)];
        line.backgroundColor = [UIColor colorWithRed:196.0/255.0 green:196.0/255.0 blue:196.0/255.0 alpha:1.0];
        [self addSubview:line];
        
        UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.Btn_share = shareBtn;
        [shareBtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        shareBtn.frame = CGRectMake(20, height1+110+8, 30, 25);
        [self addSubview:shareBtn];
        
        UIButton * collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.Btn_collect = collectBtn;
        [collectBtn setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        collectBtn.frame = CGRectMake(80, height1+110+8, 30, 25);
        [self addSubview:collectBtn];
        
        UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(110, height1+110+8, 34, 25)];
        self.L_collNum = number;
        number.textAlignment = NSTextAlignmentCenter;
        number.backgroundColor = [UIColor clearColor];
        number.textColor = [UIColor blackColor];
        number.font = [UIFont fontWithName:AllFont size:AllContentSize];
        [self addSubview:number];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

}
*/

@end
