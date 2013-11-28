//
//  MeListCell.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-24.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "MeListCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MeListCell
@synthesize IV_leftImg,L_toplab,L_bottomLab,Btn_right;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIImageView * imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 50, 50)];
        imageview1.layer.cornerRadius = 25;
        imageview1.backgroundColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0];
        self.IV_leftImg = imageview1;
        [self addSubview:imageview1];
        
        UILabel * lab1 = [[UILabel alloc] initWithFrame:CGRectMake(80, 7, 160, 25)];
        lab1.textColor = [UIColor colorWithRed:88.0/255.0 green:88.0/255.0 blue:88.0/255.0 alpha:1.0];
        lab1.font = [UIFont fontWithName:AllFont size:AllContentSize];
        self.L_toplab = lab1;
        lab1.backgroundColor = [UIColor clearColor];
        [self addSubview:lab1];
        
        UILabel * lab2 = [[UILabel alloc] initWithFrame:CGRectMake(80, 32, 160, 25)];
        lab2.textColor = [UIColor colorWithRed:140.0/255.0 green:139.0/255.0 blue:139.0/255.0 alpha:1.0];
        lab2.font = [UIFont fontWithName:AllFont size:AllContentSize];
        self.L_bottomLab = lab2;
        lab2.backgroundColor = [UIColor clearColor];
        [self addSubview:lab2];
        
        UIButton * button1= [UIButton buttonWithType:UIButtonTypeCustom];
        self.Btn_right = button1;
        button1.backgroundColor = [UIColor grayColor];
        button1.frame = CGRectMake(266, 18, 28, 28);
        button1.layer.cornerRadius = 14;
        [self addSubview:button1];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
