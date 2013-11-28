//
//  FollowsViewController.h
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-26.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "BaseViewController.h"

@class SafewayViewController;
@interface FollowsViewController : BaseViewController
@property (nonatomic,strong) NSString * storeId;
@property (nonatomic,strong) IBOutlet UITableView * myTableView;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) SafewayViewController * safeWay;
@property (nonatomic)int currFollowings;
@property (nonatomic) BOOL isFollowing;

-(void)getData;
-(void)getdata1;

-(void)buttonClick:(UIButton *)aButton;
-(void)photoClick:(UITapGestureRecognizer *)aTap;

-(void)didFinishReciveData1;
@end
