//
//  StoryDisplayCell.m
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-13.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "StoryDisplayCell.h"

@implementation StoryDisplayCell
@synthesize leftView;
@synthesize rightView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        StorycellView * view1 = [[StorycellView alloc] initWithFrame:CGRectMake(10, 10, 144, 233)];
        self.leftView = view1;
        [self addSubview:view1];
        
        StorycellView * view2 = [[StorycellView alloc] initWithFrame:CGRectMake(166, 10, 144, 233)];
        self.rightView = view2;
        [self addSubview:view2];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
