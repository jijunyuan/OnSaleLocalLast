//
//  StoryDisplayCell.h
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-13.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StorycellView.h"

@interface StoryDisplayCell : UITableViewCell
@property (nonatomic,strong) StorycellView * leftView;
@property (nonatomic,strong) StorycellView * rightView;
@end
