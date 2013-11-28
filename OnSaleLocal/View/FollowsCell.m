//
//  FollowsCell.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-26.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "FollowsCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation FollowsCell
@synthesize IV_photo,L_name,L_homedown,Btn_follow;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
        imageView.layer.cornerRadius = 20;
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        self.IV_photo = imageView;
        [self addSubview:imageView];
        
        UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 185, 20)];
        self.L_name = name;
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont fontWithName:AllFont size:AllContentSize];
        [self addSubview:name];
        
        UILabel * home = [[UILabel alloc] initWithFrame:CGRectMake(75, 30, 185, 20)];
        self.L_homedown = home;
        home.backgroundColor = [UIColor clearColor];
        home.font = [UIFont fontWithName:AllFont size:AllContentSize];
        home.textColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0];
        [self addSubview:home];
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(278, 15, 30, 30)];
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
