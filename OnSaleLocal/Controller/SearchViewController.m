//
//  SearchViewController.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-18.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "SearchViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "TKHttpRequest.h"
#import "AppDelegate.h"
#import "JASidePanelController.h"
#import <QuartzCore/QuartzCore.h>
#import "SetViewController.h"
#import "LoginViewController.h"

@interface SearchViewController ()<CLLocationManagerDelegate>
{
    NSHTTPURLResponse * httpResponse;
   CLLocationManager * manger;
   LoginViewController * login;
}

@end

@implementation SearchViewController
@synthesize key;
@synthesize allSignView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSuccessRef" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:@"loginSuccessRef" object:nil];
   self.allSignView.alpha=0.0;
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
    if (waterFlow != nil)
    {
        waterFlow = nil;
    }
    [self addWaterfolow];
    
     tempDictLab = [NSMutableDictionary dictionaryWithCapacity:0];
    self.l_navTitle.font = [UIFont fontWithName:AllFontBold size:All_h2_size];
    self.l_navTitle.text = @"Seach";
 
    self.IV_result.alpha = 0.0;
    self.L_result.alpha = 0.0;
    self.allSignView.alpha = 0.0;
}
-(void)getData
{
    if (waterFlow != nil)
    {
        waterFlow = nil;
    }
    [self addWaterfolow];
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
    
    NSString * resultStr = [self.key stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSLog(@"resultstr = %@",resultStr);
    NSString * formatStr = [NSString stringWithFormat:@"/ws/v2/search?latitude=%f&longitude=%f&radius=10&offset=0&size=20&category=%@&keywords=%@&format=json",lat,longit,@"",resultStr];
    NSString * url = [DO_MAIN stringByAppendingString:formatStr];
   __block ASIHTTPRequest * request4 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request4 setTimeOutSeconds:MAX_SECONDS_REQUEST];//ASIAskServerIfModifiedCachePolicy,ASIAskServerIfModifiedWhenStaleCachePolicy
    [request4 setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    //[ request setNumberOfTimesToRetryOnTimeout:3]; //set times when request fail
    [request4 setDownloadCache:[TKHttpRequest ShareMyCache]];
    [request4 setSecondsToCache:60*60*2];
    [request4 setUseCookiePersistence:YES];
    [request4 buildRequestHeaders];
    [request4 startAsynchronous];
   __block  NSMutableData * reciveData1 = [NSMutableData dataWithCapacity:0];
   
    [request4 setDataReceivedBlock:^(NSData *data) {
         [MyActivceView startAnimatedInView:self.view];
        [reciveData1 appendData:data];
    }];
    [request4 setCompletionBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        if (request4.responseStatusCode == 200)
        {
            NSString * strRes = [[NSString alloc] initWithData:(NSData *)reciveData1 encoding:1];
            self.dataArr = (NSMutableArray *)[[strRes objectFromJSONString] valueForKey:@"items"];

            NSLog(@"self.dataArr = %@",self.dataArr);
            if (self.dataArr.count>0)
            {
                self.IV_result.alpha = 0.0;
                self.L_result.alpha = 0.0;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                [self addWaterfolow];
                    
                    isfirstloading = YES;
                    [waterFlow reloadData];   
                });
            }
            else
            {
                self.IV_result.alpha = 1.0;
                self.L_result.alpha = 1.0;
            }
            
        }
        else
        {
            self.IV_result.alpha = 0.0;
            self.L_result.alpha = 0.0;
          // [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData1] title:@""];
        }
    }];
    [request setFailedBlock:^{
        self.IV_result.alpha = 0.0;
        self.L_result.alpha = 0.0;
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
        //[manger startUpdatingLocation];
        NSLog(@"be able to get current location");
    }
    else
    {
        NSLog(@"Unable to get current location");
    }
    
    float lat = manger.location.coordinate.latitude;
    float longit = manger.location.coordinate.longitude;    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:IS_CURR_LOCATION] isEqualToString:@"0"])
    {
        lat = [[user valueForKey:USING_LAT] floatValue];
        longit = [[user valueForKey:USING_LONG] floatValue];
    }

//#warning mark - change value
    
    //test 37.378536   -122.086586
     NSString * resultStr = [self.key stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    ASIHTTPRequest * request7 = (ASIHTTPRequest *)[WebService SearchTrendkeywords:resultStr latitude:lat longitude:longit category:@""];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
    {
        [request7 setUseCookiePersistence:YES];
        [request7 buildRequestHeaders];
    }
    [request7 startSynchronous];
    NSString * strRes = [[NSString alloc] initWithData:[request7 responseData] encoding:1];
    self.dataArr = (NSMutableArray *)[[strRes objectFromJSONString] valueForKey:@"items"];
 
    
    [waterFlow reloadData];
    
    if (self.dataArr.count == 0)
    {
        self.IV_result.alpha = 1.0;
        self.L_result.alpha = 1.0;
    }
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
    float longit = manger.location.coordinate.longitude;    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:IS_CURR_LOCATION] isEqualToString:@"0"])
    {
        lat = [[user valueForKey:USING_LAT] floatValue];
        longit = [[user valueForKey:USING_LONG] floatValue];
    }
    
    //#warning mark - change value
    
    //test 37.378536   -122.086586
    NSString * resultStr = [self.key stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    ASIHTTPRequest * request7 = (ASIHTTPRequest *)[WebService SearchTrendkeywords:resultStr latitude:lat longitude:longit category:@""];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
    {
        [request7 setUseCookiePersistence:YES];
        [request7 buildRequestHeaders];
    }
    [request7 startSynchronous];
    NSString * strRes = [[NSString alloc] initWithData:[request7 responseData] encoding:1];
    self.dataArr = (NSMutableArray *)[[strRes objectFromJSONString] valueForKey:@"items"];


    [waterFlow reloadData];
    if (self.dataArr.count == 0)
    {
        self.IV_result.alpha = 1.0;
        self.L_result.alpha = 1.0;
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    manger = manager;
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
   // [MyAlert ShowAlertMessage:@"Unable to get current location." title:nil];
}
-(void)backClick:(UIButton *)aButton
{
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
    
    SetViewController * leftcontroller = (SetViewController *)controller.leftPanel;
    leftcontroller.searchBar.backgroundColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
    for (UIView *subview in leftcontroller.searchBar.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;
        }
    }
    leftcontroller.searchBar.text = @"";
    leftcontroller.searchBar.frame = CGRectMake(10, 4, 204, 44);
    leftcontroller.searchBar.showsCancelButton = NO;
    leftcontroller.searchBar.showsSearchResultsButton = NO;
    [leftcontroller.searchBar resignFirstResponder];
    [controller showLeftPanelAnimated:YES];
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
            login.view.alpha = 0.9;
            [self.view addSubview:login.view];
        }
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
