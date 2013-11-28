//
//  SearchViewController.h
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-18.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface SearchViewController : ViewController
@property (nonatomic,strong) NSString * key;
@property (nonatomic,strong) IBOutlet UIView * allSignView;
-(void)getData;
-(void)getData1;
-(void)backClick:(UIButton *)aButton;
@end
