//
//  ViewController.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-12.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

//453783284729624
//fb376543752464584

#import "ViewController.h"

#import "StoryDisplayCell.h"
#import "AppDelegate.h"
#import "JASidePanelController.h"
#import "SmallActiveView.h"
#import "Reachability.h"
#import "WaterFlowView.h"
#import "StorycellView.h"
#import "Map1ViewController.h"
#import "TrendDetailViewController.h"
#import "TKHttpRequest.h"
#import "SafewayViewController.h"
#import "UMSocial.h"
#import "LoginViewController.h"
#import "LoginSelectedViewController.h"
#import "Container.h"
#import "CreatePasswordViewController.h"
#import "LoginViewController.h"


@interface ViewController ()<WaterFlowViewDelegate,WaterFlowViewDataSource,EGORefreshTableHeaderDelegate,UIScrollViewDelegate,CLLocationManagerDelegate,NSURLConnectionDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{

    LoginViewController * login;
}
////开始重新加载时调用的方法
- (void)reloadTableViewDataSource;
////完成加载时调用的方法
- (void)doneLoadingTableViewData;
-(IBAction)slideMenu:(id)sender;
-(void)likeButtonClick:(UIButton *)aButton;
-(void)stopClick:(UITapGestureRecognizer *)aTap;
-(void)stopClick1:(UIButton *)aButton;
-(void)ShareClick:(UIButton *)aButton;
-(void)addWaterfolow;
-(void)commentAddOne:(NSNotification *)aNotification;


-(void)emailClick:(UITapGestureRecognizer *)aTap;
-(void)faceBookClick:(UITapGestureRecognizer *)aTap;
-(void)skipClick:(UITapGestureRecognizer *)aTap;
-(void)likedata:(NSNotification *)aNotification;
-(void)getData2;

@end

@implementation ViewController
@synthesize dataArr;
@synthesize IV_result,L_result;
@synthesize IV_email,IV_facebook,L_skip,allSignView,dic_recodeClick;
@synthesize dic_lab_num;
@synthesize isFromMeLikes;
@synthesize isFromeSetting;
@synthesize myAllSignView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"commentAddOne" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentAddOne:) name:@"commentAddOne" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"likeData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likedata:) name:@"likeData" object:nil];
    self.navigationController.navigationBarHidden = YES;
    NSLog(@"isRefresh = %d",isRefresh);
    self.myAllSignView = allSignView;
//    if (self.isLoading)
//    {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [self getData1];
//        });
//    }
}

-(void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"commentAddOne" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"likeData" object:nil];
}

- (void) dealloc
{
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([self dataChanged]) {
//        [waterFlow reloadData];
        self.dataChangedTime = 0;
    }
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)commentAddOne:(NSNotification *)aNotification
{
    [self getData1];
}

-(void)likedata:(NSNotification *)aNotification
{
}

-(void)emailClick:(UITapGestureRecognizer *)aTap
{
    LoginViewController * login1;
    if (iPhone5)
    {
        login1 = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    }
    else
    {
        login1 = [[LoginViewController alloc] initWithNibName:@"LoginViewController4" bundle:nil];
    }
    login1.isBack = YES;
    [self.navigationController pushViewController:login1 animated:YES];
}
-(void)faceBookClick:(UITapGestureRecognizer *)aTap
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
//    if (appDelegate.session.isOpen)
//    {
//        [appDelegate.session closeAndClearTokenInformation];
//    }
//    else
//    {
        if (appDelegate.session.state != FBSessionStateCreated)
        {
            NSArray *permissions = [NSArray arrayWithObjects:@"email", @"publish_stream", @"user_about_me", @"publish_actions", nil];
            appDelegate.session = [[FBSession alloc] initWithPermissions:permissions];
        }
        [appDelegate.session openWithBehavior:FBSessionLoginBehaviorWithFallbackToWebView completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            [self updateView];
        }];
        //        [appDelegate.session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        //            [self updateView];
        //        }];
   // }
}
- (void)updateView
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
//    if (appDelegate.session.isOpen)
//    {
        NSString* token = appDelegate.session.accessTokenData.accessToken;
        NSString* url = [NSString stringWithFormat:@"%@/ws/user/facebook-login",DO_MAIN];
        NSDictionary* _params = @{@"token":token};
        NSLog(@"params = %@",_params);
        request_fb = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:
                                  [cookieJar cookies]];
        [request_fb setAllHTTPHeaderFields:headers];
        NSUUID* uuid = [[UIDevice currentDevice]identifierForVendor];
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        NSString* userID = [[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_LOGIN];
        NSString *header = [NSString stringWithFormat:@"ios;%@;%@;%@;%f;%f;%ld",[uuid UUIDString], version, userID,0.0, 0.0, (long)[[NSDate date]timeIntervalSince1970]];
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:_params options:kNilOptions error:&error];
        
        [request_fb setHTTPMethod:@"POST"];
        [request_fb setHTTPBody: jsonData];
        [request_fb setValue:header forHTTPHeaderField:@"Reqid"];
        [request_fb setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        [request_fb setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request_fb setHTTPShouldHandleCookies:YES];
        
        NSString *msgLength = [NSString stringWithFormat:@"%d", [jsonData length]];
        [request_fb addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        [NSURLConnection connectionWithRequest:request_fb delegate:self];
//    }
//    else
//    {
//        NSLog(@"***********");
//    }
}

-(void)skipClick:(UITapGestureRecognizer *)aTap
{
    // [self.allSignView removeFromSuperview];
    self.allSignView.alpha = 0.0;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.L_result.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.L_skip.font = [UIFont fontWithName:AllFont size:AllContentSize];
   // self.l_navTitle.font = [UIFont fontWithName:AllFont size:All_h2_size];
    
    test = 0;
    currPage = 0;
    isfirstloading = NO;
    isRefresh = NO;
    self.dic_recodeClick = [NSMutableDictionary dictionaryWithCapacity:0];
    self.dic_lab_num = [NSMutableDictionary dictionaryWithCapacity:0];
    
    tempDict = [NSMutableDictionary dictionaryWithCapacity:0];
    tempDictLab = [NSMutableDictionary dictionaryWithCapacity:0];
    requestArr = [NSMutableArray arrayWithCapacity:0];
    mutable_dic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.l_navTitle.font = [UIFont fontWithName:AllFontBold size:All_h2_size];
    self.l_navTitle.text = [@"Trending" uppercaseString];
    
   // self.l_navTitle.font = [UIFont fontWithName:AllFont size:AllContentSize];
    //    UIButton * buttonMap = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [buttonMap addTarget:self action:@selector(mapClick) forControlEvents:UIControlEventTouchUpInside];
    //    buttonMap.frame = CGRectMake(280, 7, 30, 30);
    //    [buttonMap setImage:[UIImage imageNamed:@"map_view.png"] forState:UIControlStateNormal];
    //    [self.view addSubview:buttonMap];
    
    self.view.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:231.0/255.0  blue:231.0/255.0  alpha:1.0];
    
    //get Data
    if ([WebService isConnectionAvailable])
    {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
        {
            //[self.allSignView removeFromSuperview];
            self.allSignView.alpha = 0.0;
        }
        [self getData];
    }
    
    
    if (waterFlow != nil)
    {
        waterFlow = nil;
    }
    [self addWaterfolow];
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        NSArray *permissions = [NSArray arrayWithObjects:@"email", @"publish_stream", @"user_about_me", @"publish_actions", nil];
        appDelegate.session = [[FBSession alloc] initWithPermissions:permissions];
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded)
        {
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                //[self updateView];
            }];
        }
    }
    
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
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
        login.view.alpha = 0.0;
        [self.view addSubview:login.view];
    }
    else
    {
        login.view.alpha = 0.0;
    }

    
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
    {
        if (!isFromMeLikes)
        {
            if ( !isFromeSetting)
            {
               [self.view addSubview:self.allSignView]; 
            }
        }
        
        // self.allSignView.alpha = 0.8;
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipClick:)];
        UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceBookClick:)];
        UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emailClick:)];
        self.IV_facebook.userInteractionEnabled = YES;
        self.IV_email.userInteractionEnabled = YES;
        self.L_skip.userInteractionEnabled = YES;
        [self.IV_email addGestureRecognizer:tap3];
        [self.IV_facebook addGestureRecognizer:tap2];
        [self.L_skip addGestureRecognizer:tap1];
    }
    else
    {
        // [self.allSignView removeFromSuperview];
        self.allSignView.alpha = 0.0;
    }
    
}
-(void)getData
{
    self.IV_result.alpha = 0.0;
    self.L_result.alpha = 0.0;
    
    self.view.layer.cornerRadius = 0.0;

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
    
    NSString * formatStr = [NSString stringWithFormat:@"/ws/v2/trend?latitude=%f&longitude=%f&radius=%d&offset=%d&size=20&category=&offer=1&format=json",lat,longit,10,currPage];
    NSString * url = [DO_MAIN stringByAppendingString:formatStr];
    NSLog(@"url = %@",url);
    
    __block ASIHTTPRequest * request11 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request11 setTimeOutSeconds:MAX_SECONDS_REQUEST];
    [request11 setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [request11 setNumberOfTimesToRetryOnTimeout:2]; //set times when request fail
    [request11 setDownloadCache:[TKHttpRequest ShareMyCache]];
    [request11 setSecondsToCache:60*60*2];
    [request11 setUseCookiePersistence:YES];
    [request11 buildRequestHeaders];
    NSMutableData * reciveData1 = [NSMutableData dataWithCapacity:0];
    
    [request11 setStartedBlock:^{
        [MyActivceView startAnimatedInView:self.view];
    }];
    [request11 setDataReceivedBlock:^(NSData *data) {
        [reciveData1 appendData:data];
        
    }];
    [request11 setCompletionBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        
        if ([request11 responseStatusCode] == 200)
        {
            [self.dataArr removeAllObjects];
            NSString * strRes = [[NSString alloc] initWithData:(NSData *)reciveData1 encoding:1];
            [self.dataArr addObjectsFromArray:[[strRes objectFromJSONString] valueForKey:@"items"]];
//            NSLog(@"dataArr = %@", self.dataArr);
            
            isfirstloading = YES;
          //  [self getData1];
            dispatch_async(dispatch_get_main_queue(), ^{
                [waterFlow reloadData];
                if (self.dataArr.count==0)
                {
                    self.IV_result.alpha = 1.0;
                    self.L_result.alpha = 1.0;
                }
            });
        }
        else
        {
            self.allSignView.alpha = 0.0;
        }
    }];
    __weak typeof(self) weakSelf = self;
    [request11 setFailedBlock:^{
        [MyActivceView stopAnimatedInView:weakSelf.view];
        if ([request11 responseStatusCode] != 200)
        {
            self.allSignView.alpha = 0.0;
        }
    }];
    [request11 startAsynchronous];
}
-(void)addWaterfolow
{
    waterFlow = [[WaterFlowView alloc] initWithFrame:CGRectMake(0, 44, 320, [UIScreen mainScreen].bounds.size.height-44)];
    waterFlow.delegate = self;
    waterFlow.waterFlowViewDelegate = self;
    waterFlow.waterFlowViewDatasource = self;
    waterFlow.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:231.0/255.0  blue:231.0/255.0  alpha:1.0];
    [self.view addSubview:waterFlow];
    
   
    
    
    //  waterFlow.bounces = NO;
    
    self.IV_result.alpha = 0.0;
    self.L_result.alpha = 0.0;
//    [waterFlow addSubview:self.IV_result];
//    [waterFlow addSubview:self.L_result];
    
    _refreshTableView = nil;
    if (_refreshTableView == nil)
    {
        //初始化下拉刷新控件
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - waterFlow.bounds.size.height, self.view.frame.size.width, waterFlow.bounds.size.height)];
        refreshView.delegate = self;
        //将下拉刷新控件作为子控件添加到UITableView中
        [waterFlow addSubview:refreshView];
        _refreshTableView = refreshView;
    }
    
    [waterFlow addSubview:self.IV_result];
    [waterFlow addSubview:self.L_result];
   
}
-(void)getData1
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
    isfirstloading = NO;
    
    float lat = manger.location.coordinate.latitude;
    float longit = manger.location.coordinate.longitude;
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:IS_CURR_LOCATION] isEqualToString:@"0"])
    {
        lat = [[user valueForKey:USING_LAT] floatValue];
        longit = [[user valueForKey:USING_LONG] floatValue];
    }
    
    currPage = 0;
    request1 = [WebService GetTrendListLatitude:lat longitude:longit radius:10 offset:currPage];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
    {
        [request1 setUseCookiePersistence:YES];
        [request1 buildRequestHeaders];
    }
    [request1 startSynchronous];
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    NSString * strRes = [[NSString alloc] initWithData:[request1 responseData] encoding:1];
    [self.dataArr addObjectsFromArray:[[strRes objectFromJSONString] valueForKey:@"items"]];
    [self.dataArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
        [self.dic_lab_num setValue:[obj valueForKey:@"likes"] forKey:[obj valueForKey:@"id"]];
    }];
    NSLog(@"self.dicnumber -= %@",self.dic_lab_num);
    dispatch_async(dispatch_get_main_queue(), ^{
        [waterFlow reloadData];
        if (self.dataArr.count==0)
        {
            self.IV_result.alpha = 1.0;
            self.L_result.alpha = 1.0;
        }
    });
    
    // [waterFlow relayoutDisplaySubviews];
//    NSLog(@"self.dataArr = %@",self.dataArr);
}
-(void)getData2
{
    self.IV_result.alpha = 0.0;
    self.L_result.alpha = 0.0;
    
    float lat = manger.location.coordinate.latitude;
    float longit = manger.location.coordinate.longitude;
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:IS_CURR_LOCATION] isEqualToString:@"0"])
    {
        lat = [[user valueForKey:USING_LAT] floatValue];
        longit = [[user valueForKey:USING_LONG] floatValue];
    }
    
    request1 = [WebService GetTrendListLatitude:lat longitude:longit radius:10 offset:currPage];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
    {
        [request1 setUseCookiePersistence:YES];
        [request1 buildRequestHeaders];
    }
    NSMutableData * reciveData3 = [NSMutableData dataWithCapacity:0];
    __weak typeof(self) weakSelf = self;
    [request1 setStartedBlock:^{
        [MyActivceView startAnimatedInView:weakSelf.view];
    }];
    [request1 setDataReceivedBlock:^(NSData *data) {
        [reciveData3 appendData:data];
    }];
    [request1 setCompletionBlock:^{
        NSString * strRes = [[NSString alloc] initWithData:reciveData3 encoding:1];
        NSMutableArray * arr1 = [[strRes objectFromJSONString] valueForKey:@"items"];
        weakSelf.dataArr = [NSMutableArray arrayWithArray:weakSelf.dataArr];
        [arr1 enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            NSLog(@"obj = %@",obj);
            [weakSelf.dataArr addObject:obj];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MyActivceView stopAnimatedInView:weakSelf.view];
            [waterFlow reloadData];
            if (weakSelf.dataArr.count==0)
            {
                self.IV_result.alpha = 1.0;
                self.L_result.alpha = 1.0;
            }
        });
    }];
    [request1 startAsynchronous];
    
//    NSLog(@"self.dataArr = %@",self.dataArr);
    NSLog(@"self.dataArr.count-getdata1 = %d",self.dataArr.count);
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    manger = manager;
}
#pragma mark WaterFlowViewDataSource
- (NSInteger)numberOfColumsInWaterFlowView:(WaterFlowView *)waterFlowView
{
    return 2;
}

- (NSInteger)numberOfAllWaterFlowView:(WaterFlowView *)waterFlowView
{
    return [self.dataArr count];
}

- (UIView *)waterFlowView:(WaterFlowView *)waterFlowView cellForRowAtIndexPath:(IndexPath *)indexPath
{
    //int arrIndex = indexPath.row * waterFlowView.columnCount + indexPath.column;
    int arrIndex = 0;
    if (indexPath.column == 0)
    {
        arrIndex = 2*indexPath.row;
    }
    else
    {
        arrIndex = 2*indexPath.row+1;
    }
    NSDictionary *dict = [self.dataArr objectAtIndex:arrIndex];
    float width = 0.0f;
    float height = 0.0f;
    float tempHeight = 0.0f;
    if (dict)
    {
        NSString * widthStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"width"]];
        NSString * heighStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"height"]];
        if ([widthStr isEqualToString:@"<null>"])
        {
            widthStr = @"0.0";
        }
        if ([heighStr isEqualToString:@"<null>"])
        {
            heighStr = @"0.0";
        }
        width = [widthStr floatValue];
        height = [heighStr floatValue];
        if (width == 0.0)
        {
            tempHeight = 0.0;
        }
        else
        {
            tempHeight = 150.0/width*height;
        }
    }
    StorycellView *view1 = [[StorycellView alloc] initWithFrame:CGRectMake(0, 0, 160.0, tempHeight+150.0) andImageHeight:height andWidth:width];
    return view1;
}


-(void)waterFlowView:(WaterFlowView *)waterFlowView  relayoutCellSubview:(UIView *)view withIndexPath:(IndexPath *)indexPath
{
    //arrIndex是某个数据在总数组中的索引
    // int arrIndex = indexPath.row * waterFlowView.columnCount + indexPath.column;
    int arrIndex = 0;
    if (indexPath.column == 0)
    {
        arrIndex = 2*indexPath.row;
    }
    else
    {
        arrIndex = 2*indexPath.row+1;
    }
    NSDictionary * dic = [self.dataArr objectAtIndex:arrIndex];
    
    // NSLog(@"arrindex = %d",arrIndex);
    StorycellView * leftView = (StorycellView *)view;
    leftView.tag = arrIndex;
    leftView.Btn_temp.tag = arrIndex;
    NSString * image_url = [dic valueForKey:@"smallImg"];
    if(image_url == nil)
    {
        image_url = [dic valueForKey:@"largeImg"];
    }
    
    if (leftView.imageView_story.image == nil)
    {
      [leftView.imageView_story setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:nil];
    }
    
    leftView.L_des.text = [dic valueForKey:@"title"];
    leftView.L_storename.text = [dic valueForKey:@"merchant"];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopClick:)];
    leftView.L_storename.userInteractionEnabled =YES;
    [leftView.L_storename addGestureRecognizer:tap];
    [leftView.Btn_temp addTarget:self action:@selector(stopClick1:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDateFormatter  * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:([[dic valueForKey:@"end"] floatValue]/1000)];
    NSString * dateStr = [formatter stringFromDate:date];
    leftView.TF_time.text = [NSString stringWithFormat:@"Ends %@",dateStr];
    leftView.TF_time.font = [UIFont systemFontOfSize:12];
    NSString * collumStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"likes"]];
    leftView.Btn_collect.tag = 100+arrIndex;
    [leftView.Btn_collect addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftView.Btn_share addTarget:self action:@selector(ShareClick:) forControlEvents:UIControlEventTouchUpInside];
    leftView.Btn_share.tag = arrIndex;
    
    NSLog(@"%d %d: liked: %d", indexPath.row, indexPath.column, [[dic valueForKey:@"liked"] intValue]);
    NSString * strRes = [NSString stringWithFormat:@"%@",[dic valueForKey:@"liked"]];
    [leftView.Btn_collect setImage:nil forState:UIControlStateNormal];
    
    if ([strRes intValue] == 1)
    {
        [leftView.Btn_collect setImage:[UIImage imageNamed:@"liked.png"] forState:UIControlStateNormal];
    }
    else
    {
        [leftView.Btn_collect setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
    }
    
    [tempDict setValue:[dic valueForKey:@"id"] forKey:[NSString stringWithFormat:@"%d",leftView.Btn_collect.tag]];
    [tempDictLab setValue:leftView.L_collNum forKey:[NSString stringWithFormat:@"%d",leftView.Btn_collect.tag]];
    
    leftView.L_collNum.text = collumStr;
    leftView.L_Meter.text = [NSString stringWithFormat:@"%.1f m",[[dic valueForKey:@"distance"] floatValue]];
    leftView.L_Meter.userInteractionEnabled = YES;
    NSArray * arrTempGes = [leftView gestureRecognizers];
    [arrTempGes enumerateObjectsUsingBlock:^(UITapGestureRecognizer * obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqual:tap])
        {
            *stop = YES;
        }
        else
        {
         [leftView addGestureRecognizer:tap];
         leftView.imageView_adress.userInteractionEnabled = YES;
         [leftView.imageView_adress addGestureRecognizer:tap];
        }
    }]; 
}


#pragma mark WaterFlowViewDelegate
- (CGFloat)waterFlowView:(WaterFlowView *)waterFlowView heightForRowAtIndexPath:(IndexPath *)indexPath
{
    int arrIndex = 0;
    if (indexPath.column == 0)
    {
        arrIndex = 2*indexPath.row;
    }
    else
    {
        arrIndex = 2*indexPath.row+1;
    }
    
    NSDictionary *dict = [self.dataArr objectAtIndex:arrIndex];
    
    float width = 0.0f;
    float height = 0.0f;
    float tempHeight = 0.0f;
    if (dict)
    {
        NSString * widthStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"width"]];
        NSString * heighStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"height"]];
        if ([widthStr isEqualToString:@"<null>"])
        {
            widthStr = @"0.0";
        }
        if ([heighStr isEqualToString:@"<null>"])
        {
            heighStr = @"0.0";
        }
        width = [widthStr floatValue];
        height = [heighStr floatValue];
        tempHeight = 0.0;
        if (width == 0.0)
        {
            tempHeight = 0.0;
        }
        else
        {
            tempHeight = 150.0/width*height;
        }
        
    }
    return tempHeight+150.0;
}

- (void)waterFlowView:(WaterFlowView *)waterFlowView didSelectRowAtIndexPath:(IndexPath *)indexPath
{
    TrendDetailViewController * trend;
    if (iPhone5)
    {
        trend = [[TrendDetailViewController alloc] initWithNibName:@"TrendDetailViewController" bundle:nil];
    }
    else
    {
        trend = [[TrendDetailViewController alloc] initWithNibName:@"TrendDetailViewController4" bundle:nil];
    }
    int arrIndex = 0;
    if (indexPath.column == 0)
    {
        arrIndex = 2*indexPath.row;
    }
    else
    {
        arrIndex = 2*indexPath.row+1;
    }
    trend.dic_lab_number = self.dic_lab_num;
    trend.viewController1 = self;
    
    if ([[self.dic_recodeClick valueForKey:[[self.dataArr objectAtIndex:arrIndex] valueForKey:@"id"]] isEqualToString:@"1"])
    {
        isClick = 2;
    }
    else
    {
        isClick = 1;
    }
    trend.isClick = isClick;
    isRefresh = NO;
    trend.dic_recode = self.dic_recodeClick;
    trend.likenumber = likesNum;
    trend.dic = [self.dataArr objectAtIndex:arrIndex];
    [self.navigationController pushViewController:trend animated:YES];
}
- (void)reloadTableViewDataSource
{
    _reloading = YES;
    [NSThread detachNewThreadSelector:@selector(doInBackground) toTarget:self withObject:nil];
}
////完成加载时调用的方法
- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:waterFlow];
    [waterFlow reloadData];
}
-(void)doInBackground
{
    if ([WebService isConnectionAvailable])
    {
        [self getData1];
    }
    [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:YES];
}
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    NSLog(@"%s",__FUNCTION__);
    [self reloadTableViewDataSource];
}

-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}

-(NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    waterFlow.bounces = YES;
    return [NSDate date];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshTableView egoRefreshScrollViewDidScroll:scrollView];
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    CGFloat currentOffset = offset.y+bounds.size.height-inset.bottom;
    CGFloat maximumOffset = size.height;
    
    // NSLog(@"currofset = %d,max = %d",[[NSNumber numberWithFloat:currentOffset] intValue],[[NSNumber numberWithFloat:maximumOffset] intValue]);
    
    currY = scrollView.contentOffset.y;
    
    //  NSLog(@"=cyrry = %f=oldy=%f===%d",currY,oldY,currY>oldY);
    if (currY>oldY)
    {
        if (currY == 0.0)
        {
            waterFlow.bounces = YES;
        }
        else
        {
            waterFlow.bounces = NO;
        }
        
        if (([[NSNumber numberWithFloat:currentOffset] intValue] == [[NSNumber numberWithFloat:maximumOffset] intValue]))
        {
            // NSLog(@"\n*********************************\n");
            if (self.dataArr.count>=(currPage+20))
            {
                // NSLog(@"\n***xxxxxxxxxxxxxxxxx*******\n");
                currPage += 20;
                NSLog(@"currpage = %d",currPage);
                [self getData2];
            }
        }
    }
    else
    {
        waterFlow.bounces = YES;
    }
    oldY = currY;
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshTableView egoRefreshScrollViewDidEndDragging:scrollView];
    
}
-(IBAction)slideMenu:(id)sender
{
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
    [controller showLeftPanelAnimated:YES];
}
-(void)backClick:(UIButton *)aButton
{
    [request cancel];
    [request1 cancel];
    [requestArr enumerateObjectsUsingBlock:^(ASIHTTPRequest * obj, NSUInteger idx, BOOL *stop) {
        [obj cancel];
    }];
    
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionMoveIn;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//    
//    [self.navigationController popViewControllerAnimated:YES];
    [controller showLeftPanelAnimated:YES];
}
-(void)likeButtonClick:(UIButton *)aButton
{
    if (self.isFromMeLikes)
    {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
        {
            currButton = aButton;
            button_tag = aButton.tag;
            
            NSString * idstr = [tempDict valueForKey:[NSString stringWithFormat:@"%d",aButton.tag]];
            if ([aButton.imageView.image isEqual:[UIImage imageNamed:@"liked.png"]])
            {
                NSString * idstr = [tempDict valueForKey:[NSString stringWithFormat:@"%d",currButton.tag]];
                [self likeUnlike :idstr :NO :nil];
            }
            else
            {
                [self likeUnlike :[[self.dataArr objectAtIndex:currButton.tag-100] valueForKey:@"id"] :YES :nil];
            }
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you want to login？" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Yes", nil];
            [alert show];
        }

        //[MyActivceView startAnimatedInView1:self.view];
           }
    else
    {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
        {
           // [MyActivceView startAnimatedInView1:self.view];
            currButton = aButton;
            button_tag = aButton.tag;
            NSString * idstr = [tempDict valueForKey:[NSString stringWithFormat:@"%d",aButton.tag]];
            if ([aButton.imageView.image isEqual:[UIImage imageNamed:@"liked.png"]])
            {
                NSString * idstr = [tempDict valueForKey:[NSString stringWithFormat:@"%d",currButton.tag]];
                [self likeUnlike :idstr :NO :nil];
            }
            else
            {
                [self likeUnlike :[[self.dataArr objectAtIndex:currButton.tag-100] valueForKey:@"id"] :YES :nil];
            }
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you want to login？" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Yes", nil];
            [alert show];
        }
    }
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
//            [self.view insertSubview:self.allSignView belowSubview:_refreshTableView];
//            
//            UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipClick:)];
//            UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceBookClick:)];
//            UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emailClick:)];
//            self.IV_facebook.userInteractionEnabled = YES;
//            self.IV_email.userInteractionEnabled = YES;
//            self.L_skip.userInteractionEnabled = YES;
//            [self.IV_email addGestureRecognizer:tap3];
//            [self.IV_facebook addGestureRecognizer:tap2];
//            [self.L_skip addGestureRecognizer:tap1];
//            
//            self.allSignView.alpha = 0.8;
             login.view.alpha = 1.0;
        
        }
    }
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    reciveData = [NSMutableData dataWithCapacity:0];
    httpResponse = (NSHTTPURLResponse *)response;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [reciveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [MyActivceView stopAnimatedInView:self.view];
    NSLog(@"data = %@",[[NSString alloc] initWithData:reciveData encoding:4]);
    if ([httpResponse statusCode] == 200)
    {
        if (self.isFromMeLikes)
        {
            [self getData1];
            [waterFlow reloadData];
        }
        else
        {
            if ([(NSMutableURLRequest *)[connection currentRequest] isEqual:request_fb])
            {
                NSDictionary * dic = [reciveData objectFromJSONData];
                NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                [user setValue:[dic valueForKey:@"birthYear"] forKey:LOGIN_BIRTHYEAR];
                [user setValue:[dic valueForKey:@"created"] forKey:LOGIN_CREATED];
                [user setValue:[dic valueForKey:@"firstName"] forKey:LOGIN_FIRST_NAME];
                NSString *genderStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"gender"]];
                [user setValue:genderStr forKey:LOGIN_GENDER];
                [user setValue:[dic valueForKey:@"id"] forKey:LOGIN_ID];
                [user setValue:[dic valueForKey:@"lastName"] forKey:LOGIN_LAST_NAME];
                [user setValue:[dic valueForKey:@"login"] forKey:LOGIN_LOGIN];
                [user setValue:[dic valueForKey:@"noti"] forKey:LOGIN_NOTI];
                
                if([dic valueForKey:@"password"]) {
                    NSString * pwdStr = [NSString stringWithFormat:@"%@",[dic valueForKey:LOGIN_GENDER]];
                    if (![pwdStr isEqualToString:@"(null)"] && ![pwdStr isEqualToString:@"<null>"]) {
                        [user setValue:pwdStr forKey:LOGIN_PASSWORD];
                    }
                }
                if([dic valueForKey:@"zipcode"]) {
                    NSString * zipcode = [NSString stringWithFormat:@"%@",[dic valueForKey:LOGIN_ZIPCODE]];
                    if (![zipcode isEqualToString:@"(null)"] && ![zipcode isEqualToString:@"<null>"]) {
                        [user setValue:zipcode forKey:LOGIN_ZIPCODE];
                    }
                }
                
                [user setValue:[dic valueForKey:@"updated"] forKey:LOGIN_UPDATED];
                [user setValue:[dic valueForKey:@"img"] forKey:LOGIN_IMAGE];
                [user setValue:[dic valueForKey:@"notifications"] forKey:LOGIN_NOTIFICATION];
                [user setValue:@"1" forKey:LOGIN_STATUS];
                
                NSString * result1 = [NSString stringWithFormat:@"%@",[dic valueForKey:@"status"]];
                if ([result1 isEqualToString:@"Inactive"])
                {
                    CreatePasswordViewController * createPWD;
                    if (iPhone5)
                    {
                        createPWD = [[CreatePasswordViewController alloc] initWithNibName:@"CreatePasswordViewController" bundle:nil];
                    }
                    else
                    {
                        createPWD = [[CreatePasswordViewController alloc] initWithNibName:@"CreatePasswordViewController4" bundle:nil];
                    }
                    NSLog(@"dic = %@",dic);
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        NSString * strTemp = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:DEVIVE_TOKEN]];
                        if (strTemp.length>0)
                        {
                            [WebService RegisterNotification:strTemp];
                        }
                    });
                    [UIView animateWithDuration:0.3 animations:^{
                        self.allSignView.alpha = 0.0;
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [self getData1];
                        });
                    }];
                    createPWD.email = [user valueForKey:LOGIN_LOGIN];
                    createPWD.zipcode = [user valueForKey:LOGIN_ZIPCODE];
                    [self.navigationController pushViewController:createPWD animated:YES];
                }
                else
                {
                    [UIView animateWithDuration:0.3 animations:^{
                        self.allSignView.alpha = 0.0;
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [self getData1];
                        });
                    }];
                }
                
                
            }
            else
            {
                if ([(NSMutableURLRequest *)[connection currentRequest] isEqual:request_fb])
                {
                    [UIView animateWithDuration:0.3 animations:^{
                        self.allSignView.alpha = 0.0;
                    }];
                    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:LOGIN_STATUS];
                }
            }
        }
    }
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [MyActivceView stopAnimatedInView:self.view];
    if ([(NSMutableURLRequest *)[connection currentRequest] isEqual:request_fb])
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.allSignView.alpha = 0.0;
        }];
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:LOGIN_STATUS];
    }
}

-(void)stopClick:(UITapGestureRecognizer *)aTap
{
    StorycellView * cellview = (StorycellView *)[[aTap view] superview];
    NSDictionary * dic = [self.dataArr objectAtIndex:cellview.tag];
    
    SafewayViewController * safe;
    if (iPhone5)
    {
        safe = [[SafewayViewController alloc] initWithNibName:@"SafewayViewController" bundle:nil];
    }
    else
    {
        safe = [[SafewayViewController alloc] initWithNibName:@"SafewayViewController4" bundle:nil];
    }
    safe.merchanName = [dic valueForKey:@"merchant"];
    safe.merchantId = [dic valueForKey:@"merchantId"];
    [self.navigationController pushViewController:safe animated:YES];
}
-(void)stopClick1:(UIButton *)aButton
{
    //StorycellView * cellview = (StorycellView *)[[aTap view] superview];
    NSDictionary * dic = [self.dataArr objectAtIndex:aButton.tag];
    
    SafewayViewController * safe;
    if (iPhone5)
    {
        safe = [[SafewayViewController alloc] initWithNibName:@"SafewayViewController" bundle:nil];
    }
    else
    {
        safe = [[SafewayViewController alloc] initWithNibName:@"SafewayViewController4" bundle:nil];
    }
    safe.merchanName = [dic valueForKey:@"merchant"];
    safe.merchantId = [dic valueForKey:@"merchantId"];
    [self.navigationController pushViewController:safe animated:YES];
}
-(void)ShareClick:(UIButton *)aButton
{
    NSLog(@"====================share btn clicked");
    NSDictionary * dic = [self.dataArr objectAtIndex:aButton.tag];
     NSString * linkStr = [NSString stringWithFormat:@"%@/offer/details/index.jsp.oo",DO_MAIN];
    NSLog(@"dic = %@",dic);
    NSString * contentStr = [NSString stringWithFormat:@"%@,%@,$%g,%@",[dic valueForKey:@"title"],[dic valueForKey:@"merchant"],[[dic valueForKey:@"price"] doubleValue],linkStr];
    
    NSMutableAttributedString * attribut = [[NSMutableAttributedString alloc] initWithString:contentStr];
    [attribut removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(0, 10)];
    [attribut addAttribute:NSForegroundColorAttributeName value:(id)[UIColor redColor].CGColor range:NSMakeRange(2, 10)];
    
    NSURLRequest *request5 = [NSURLRequest requestWithURL:[NSURL URLWithString:[dic valueForKey:@"smallImg"]]];
    NSData * data1 = [NSURLConnection sendSynchronousRequest:request5 returningResponse:nil error:nil];
    
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:UM_APP_KEY
//                                      shareText:[attribut string]
//                                     shareImage:[UIImage imageWithData:data1]
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToFacebook,UMShareToSms,UMShareToTwitter,UMShareToEmail,nil]
//                                       delegate:nil];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UM_APP_KEY
                                      shareText:[attribut string]
                                     shareImage:[UIImage imageWithData:data1]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToFacebook,UMShareToTwitter,nil]
                                       delegate:nil];
}

//    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on FaceBook",@"Share via Email",@"Flag as Inappropriate", nil];
//    [sheet showInView:self.view];

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0)
//    {
//        [UMSocialSnsService presentSnsIconSheetView:self
//                                             appKey:UM_APP_KEY
//                                          shareText:@"content"
//                                         shareImage:[UIImage imageNamed:@"icon.png"]
//                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToFacebook,nil]
//                                           delegate:nil];
//    }
//    if (buttonIndex == 1)
//    {
//        [UMSocialSnsService presentSnsIconSheetView:self
//                                             appKey:UM_APP_KEY
//                                          shareText:@"content"
//                                         shareImage:[UIImage imageNamed:@"icon.png"]
//                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSms,nil]
//                                           delegate:nil];
//    }
//    if (buttonIndex == 2)
//    {
//        //flag
//    }
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)changeOfferLikeState:(NSString *)likedOfferId liked:(BOOL)like
{
    NSNumber *liked = [NSNumber numberWithBool:like];
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:[self.dataArr count]];
    for (int i=0; i<[self.dataArr count]; i++) {
        NSMutableDictionary *item = [self.dataArr objectAtIndex:i];
        NSString *offerId = [item objectForKey:@"id"];
        if([offerId isEqualToString:likedOfferId]) {
            StorycellView *cell = [self searchStorycellViewByTag:i];
            NSMutableDictionary *newItem = [NSMutableDictionary dictionaryWithDictionary:item];
            [newItem setValue:liked forKey:@"liked"];
            if([liked intValue] == 0) {
                NSNumber *likes = [NSNumber numberWithInt:([[item objectForKey:@"likes"] intValue] - 1)];
                [newItem setValue:likes forKey:@"likes"];
                if(cell) {
                    [cell.Btn_collect setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
                    cell.L_collNum.text = [likes stringValue];
                }
            }
            else {
                NSNumber *likes = [NSNumber numberWithInt:([[item objectForKey:@"likes"] intValue] + 1)];
                [newItem setValue:likes forKey:@"likes"];
                if(cell) {
                    [cell.Btn_collect setImage:[UIImage imageNamed:@"liked.png"] forState:UIControlStateNormal];
                    cell.L_collNum.text = [likes stringValue];
                }
            }
            [newArray addObject:newItem];
        }
        else {
            [newArray addObject:item];
        }
    }
    self.dataArr = newArray;
}

-(void)dataChangedNotificationCallback:(NSNotification *)noti
{
    [super dataChangedNotificationCallback:noti];
    NSDictionary *userInfo = noti.userInfo;
    NSNumber *liked = [userInfo objectForKey:@"liked"];
    if(liked) {
        NSString * likedOfferId = [userInfo objectForKey:@"offerId"];
        [self changeOfferLikeState:likedOfferId liked:[liked boolValue]];
    }
}

-(id) searchStorycellViewByTag:(int)tag
{
    for(UITableView *tv in waterFlow.tableviews) {
        for (int i=0; i<1000; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow: i inSection: 0];
            UITableViewCell *cell = [tv cellForRowAtIndexPath:indexPath];
            for (UIView *view in  cell.contentView.subviews){
                if ([view isKindOfClass:[StorycellView class]] && view.tag == tag){
                    return (id)view;
                }
            }
        }
    }
    return nil;
}
@end
