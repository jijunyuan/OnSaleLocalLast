//
//  NotificationCell.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-10-1.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell
@synthesize IV_imageView,L_time,L_people,L_name;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView * mao = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        self.IV_imageView = mao;
        [self addSubview:mao];
        
//        UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(75, 5, 120, 20)];
//       // self.L_people = name;
//        name.backgroundColor = [UIColor clearColor];
//        name.font = [UIFont systemFontOfSize:17];
//        [self addSubview:name];
        
        UILabel * home = [[UILabel alloc] initWithFrame:CGRectMake(75, 5, 200, 42)];
        home.numberOfLines = 3;
        self.L_name = home;
        home.backgroundColor = [UIColor clearColor];
        home.font = [UIFont fontWithName:AllFont size:AllContentSize];
       // home.textColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0];
        [self addSubview:home];

        
        UILabel * phone = [[UILabel alloc] initWithFrame:CGRectMake(75, 45, 160, 15)];
        self.L_time = phone;
        phone.backgroundColor = [UIColor clearColor];
        phone.font = [UIFont fontWithName:AllFont size:AllContentSize];
        phone.textColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0];
        [self addSubview:phone];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
