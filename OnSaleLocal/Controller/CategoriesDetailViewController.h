//
//  CategoriesDetailViewController.h
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-23.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "ViewController.h"
#import "SearchViewController.h"
#import "ViewController.h"
@interface CategoriesDetailViewController : ViewController
@property (nonatomic,strong) IBOutlet UIView * allSignView;
@property (nonatomic,strong) NSString * key;
-(void)backClick:(UIButton *)aButton;
-(void)getData;
-(void)getData1;
@end
