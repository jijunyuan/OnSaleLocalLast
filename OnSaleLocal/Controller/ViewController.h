//
//  ViewController.h
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-12.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"
#import "WaterFlowView.h"
#import <CoreLocation/CoreLocation.h>
#import "EGORefreshTableHeaderView.h"

@interface ViewController : BaseSettingViewController
{
   WaterFlowView * waterFlow;
    
    EGORefreshTableHeaderView *_refreshTableView;
    BOOL _reloading;
    int test;
    CLLocationManager * manger;
    int currPage;
    ASIHTTPRequest * request1;
    __weak ASIHTTPRequest * request;
    NSMutableArray * requestArr;
    NSMutableDictionary * tempDict;
    NSMutableDictionary * tempDictLab;
    
    NSMutableData * reciveData;
    NSHTTPURLResponse * httpResponse;
    
    NSMutableURLRequest *request12;
    NSMutableURLRequest *request13;
    
    int button_tag;
    UIButton * currButton;
    NSMutableDictionary * mutable_dic;
    
    float currY;
    float oldY;
    
    NSMutableURLRequest * request_get_trend;
    NSMutableURLRequest* request_fb;
    
    int likesNum;
    int isClick;
    
    BOOL isfirstloading;
    
    BOOL isRefresh;

}
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) IBOutlet UIImageView * IV_result;
@property (nonatomic,strong) IBOutlet UILabel * L_result;

@property (nonatomic,strong) IBOutlet UIView * allSignView;
@property (nonatomic,strong) IBOutlet UIImageView * IV_email;
@property (nonatomic,strong) IBOutlet UIImageView * IV_facebook;
@property (nonatomic,strong) IBOutlet UILabel * L_skip;
@property (nonatomic,strong) NSMutableDictionary * dic_recodeClick;
@property (nonatomic,strong) NSMutableDictionary * dic_lab_num;
@property (nonatomic) BOOL isFromMeLikes;
@property (nonatomic) BOOL isFromeSetting;
@property (nonatomic,strong) UIView * myAllSignView;

@property (nonatomic)BOOL isLoading;
-(void)getData;
-(void)getData1;
-(void)backClick:(UIButton *)aButton;
-(void)addWaterfolow;
@end
