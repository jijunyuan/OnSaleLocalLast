//
//  CategoriesDetailViewController.m
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-23.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "CategoriesDetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "TKHttpRequest.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface CategoriesDetailViewController ()<CLLocationManagerDelegate>
{
    NSHTTPURLResponse * httpResponse;
    CLLocationManager * manger;
    // NSMutableArray * requestArr;
     LoginViewController * login;
}
@end

@implementation CategoriesDetailViewController
@synthesize allSignView;
@synthesize key;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
 
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSuccessRef" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:@"loginSuccessRef" object:nil];
    login.view.alpha = 0.0;
    if (self.isLoading)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getData];
        });
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.leftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    self.l_navTitle.text = self.key;
    self.IV_result.alpha = 0.0;
    self.L_result.alpha = 0.0;
    self.allSignView.alpha = 0.0;
    if (waterFlow != nil)
    {
        waterFlow = nil;
    }
    [self addWaterfolow];
    
    
}

-(void)getData
{
    
    self.IV_result.alpha = 0.0;
    self.L_result.alpha = 0.0;
    
    if (!isfirstloading)
    {
        if (waterFlow != nil)
        {
            waterFlow = nil;
            _refreshTableView = nil;
        }
        [self addWaterfolow];
    }
    

    
    //获取当前经纬度
    if ([CLLocationManager locationServicesEnabled])
    {
        manger = [[CLLocationManager alloc] init];
        manger.desiredAccuracy = kCLLocationAccuracyBest;
        [manger setDistanceFilter:kCLDistanceFilterNone];
        manger.delegate = self;
        //[manger startUpdatingLocation];
        NSLog(@"be able to get current location");
    }
    else
    {
        NSLog(@"Unable to get current location");
    }
    
    float lat = manger.location.coordinate.latitude;
    float longit = manger.location.coordinate.longitude;

    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:IS_CURR_LOCATION] isEqualToString:@"0"])
    {
        lat = [[user valueForKey:USING_LAT] floatValue];
        longit = [[user valueForKey:USING_LONG] floatValue];
    }
    
    
    //test 37.378536   -122.086586
//#warning mark - change value
    //   __weak ASIHTTPRequest * request = (ASIHTTPRequest *)[WebService SearchTrendkeywords:self.key latitude:37.378536 longitude:-122.086586 category:@""];
    NSString * resultStr = [self.key stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSLog(@"resultstr = %@",resultStr);
    NSString * formatStr = [NSString stringWithFormat:@"/ws/v2/search?latitude=%f&longitude=%f&radius=10&offset=0&size=20&category=%@&keywords=%@&format=json",lat,longit,resultStr,resultStr];
    NSString * url = [DO_MAIN stringByAppendingString:formatStr];
    NSLog(@"url = %@",url);
    __weak ASIHTTPRequest * request3 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request3 setTimeOutSeconds:MAX_SECONDS_REQUEST];//ASIAskServerIfModifiedCachePolicy,ASIAskServerIfModifiedWhenStaleCachePolicy
    [request3 setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [ request3 setNumberOfTimesToRetryOnTimeout:3]; //set times when request fail
    [request3 setDownloadCache:[TKHttpRequest ShareMyCache]];
    [request3 setSecondsToCache:60*60*2];
    [request3 setUseCookiePersistence:YES];
    [request3 buildRequestHeaders];
    [request3 startAsynchronous];
    __block  NSMutableData * reciveData2 = [NSMutableData dataWithCapacity:0];
    
    self.IV_result.alpha = 0.0;
    self.L_result.alpha = 0.0;
    [request3 setStartedBlock:^{
         [MyActivceView startAnimatedInView:self.view];
    }];
    [request3 setDataReceivedBlock:^(NSData *data) {
        [reciveData2 appendData:data];
    }];
    [request3 setCompletionBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        NSLog(@"self.dataArr = %@",[[reciveData2 objectFromJSONData] valueForKey:@"items"]);
        if (request3.responseStatusCode == 200)
        {
            self.dataArr = nil;
            self.dataArr = [NSMutableArray arrayWithCapacity:0];
            self.dataArr = [[reciveData2 objectFromJSONData] valueForKey:@"items"];
            NSLog(@"self.dataArr = %@",self.dataArr);
            if (self.dataArr.count>0)
            {
                isfirstloading = YES;
                [self getData1];
                 [waterFlow reloadData];
                 
            }
            else
            {
                self.IV_result.alpha = 1.0;
                self.L_result.alpha = 0.0;
            }
        }
        else
        {
          //  [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData2] title:@""];
        }
    }];
    [request setFailedBlock:^{
         [MyActivceView stopAnimatedInView:self.view];
    }];
}
-(void)getData1
{
    if (!isfirstloading)
    {
        if (waterFlow != nil)
        {
            waterFlow = nil;
            _refreshTableView = nil;
        }
        [self addWaterfolow];
    }
    

      isfirstloading = NO;
    //获取当前经纬度
    if ([CLLocationManager locationServicesEnabled])
    {
        manger = [[CLLocationManager alloc] init];
        manger.desiredAccuracy = kCLLocationAccuracyBest;
        [manger setDistanceFilter:kCLDistanceFilterNone];
        manger.delegate = self;
    }
    else
    {
        NSLog(@"Unable to get current location");
    }
    
    float lat = manger.location.coordinate.latitude;
    float longit = manger.location.coordinate.longitude;

    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:IS_CURR_LOCATION] isEqualToString:@"0"])
    {
        lat = [[user valueForKey:USING_LAT] floatValue];
        longit = [[user valueForKey:USING_LONG] floatValue];
    }
    
//#warning mark - change value
    
    //test 37.378536   -122.086586
     NSString * resultStr = [self.key stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    ASIHTTPRequest * request2 = (ASIHTTPRequest *)[WebService SearchTrendkeywords:resultStr latitude:lat longitude:longit category:@""];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
    {
        [request2 setUseCookiePersistence:YES];
        [request2 buildRequestHeaders];
    }
    [request2 startSynchronous];
    self.dataArr = nil;
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.dataArr = [[[request2 responseData] objectFromJSONData] valueForKey:@"items"];
    dispatch_async(dispatch_get_main_queue(), ^{
                
        [waterFlow reloadData];
        self.IV_result.alpha = 0.0;
       // self.L_result.alpha = 0.0;
    });
}
-(void)getData2
{
    if (!isfirstloading)
    {
        if (waterFlow != nil)
        {
            waterFlow = nil;
            _refreshTableView = nil;
        }
        [self addWaterfolow];
    }

    //获取当前经纬度
    if ([CLLocationManager locationServicesEnabled])
    {
        manger = [[CLLocationManager alloc] init];
        manger.desiredAccuracy = kCLLocationAccuracyBest;
        [manger setDistanceFilter:kCLDistanceFilterNone];
        manger.delegate = self;
        //[manger startUpdatingLocation];
        NSLog(@"be able to get current location");
    }
    else
    {
        NSLog(@"Unable to get current location");
    }
    
    float lat = manger.location.coordinate.latitude;
    float longit = manger.location.coordinate.longitude;
    
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:IS_CURR_LOCATION] isEqualToString:@"0"])
    {
        lat = [[user valueForKey:USING_LAT] floatValue];
        longit = [[user valueForKey:USING_LONG] floatValue];
    }
    
    //#warning mark - change value
    
    //test 37.378536   -122.086586
    NSString * resultStr = [self.key stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    ASIHTTPRequest * request2 = (ASIHTTPRequest *)[WebService SearchTrendkeywords:resultStr latitude:lat longitude:longit category:@""];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
    {
        [request2 setUseCookiePersistence:YES];
        [request2 buildRequestHeaders];
    }
    [request2 startSynchronous];
    
    
    self.dataArr = nil;
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.dataArr = [[[request2 responseData] objectFromJSONData] valueForKey:@"items"];
    [waterFlow reloadData];
    self.IV_result.alpha = 0.0;
    self.L_result.alpha = 0.0;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3333)
    {
        if (buttonIndex == 1)
        {
            //meroot change number
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"refreshRoot" object:nil]];
            
            NSString * idstr = [tempDict valueForKey:[NSString stringWithFormat:@"%d",currButton.tag]];
            request12 = [WebService UnLikeOffer:idstr];
            [NSURLConnection connectionWithRequest:request12 delegate:self];
        }
    }
    else
    {
        if (buttonIndex == 1)
        {
            if (iPhone5)
            {
                login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            }
            else
            {
                login = [[LoginViewController alloc] initWithNibName:@"LoginViewController4" bundle:nil];
            }
            login.isQukyLogin = YES;
            login.view.alpha = 0.8;
            [self.view addSubview:login.view];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    manger = manager;
}
-(void)backClick:(UIButton *)aButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
