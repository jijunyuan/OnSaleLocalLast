//
//  SafewayViewController.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-24.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "SafewayViewController.h"
#import "TKHttpRequest.h"
#import <MapKit/MapKit.h>
#import "StoreOfferView.h"
#import "MKAnnotation.h"
#import "StoreMapViewController.h"
#import "FollowsViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "UMSocial.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "TrendDetailViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface SafewayViewController ()<EGORefreshTableHeaderDelegate,NSURLConnectionDelegate,UIAlertViewDelegate,CLLocationManagerDelegate>
{
    EGORefreshTableHeaderView *_refreshTableView;
    BOOL _reloading;
    
    NSMutableData * reciveData1;
    NSHTTPURLResponse * httpResponse;
    NSMutableURLRequest * request_like;
    
    NSMutableDictionary * dict_lab;
    NSMutableDictionary * dict_id;
    
    int currTag;
    UIImageView * currImageView;
    NSMutableURLRequest* request_fb;
    
    NSMutableDictionary * dicLabnum;
    
    int likeNum;
    int isClick1;
    
    NSMutableArray * arr_lab;
    
    CLLocationManager * manger;
    
     LoginViewController * login;
    UIImageView *mapImageView;
}
@property (nonatomic,strong) NSDictionary * dic;
@property (nonatomic,strong) IBOutlet MKMapView * myMapview;
@property (nonatomic,strong) IBOutlet UILabel * l_name1;
@property (nonatomic,strong) IBOutlet UILabel * l_adress;
@property (nonatomic,strong) IBOutlet UILabel * l_tell;
@property (nonatomic,strong) IBOutlet UIView * V_deals;
@property (nonatomic,strong) IBOutlet UILabel * l_dealnumber;
@property (nonatomic,strong) IBOutlet UIView * V_follows;
@property (nonatomic,strong) IBOutlet UILabel * l_followNumber;
@property (nonatomic,strong) IBOutlet UIScrollView * SV_scroll;
@property (nonatomic,strong) NSMutableDictionary * dic_recodeClick;
@property (nonatomic,strong) IBOutlet UILabel * L_dealsName;
@property (nonatomic,strong) IBOutlet UILabel * L_followsName;
@property (nonatomic,strong) IBOutlet UIView * middleView;

-(void)getData;
-(void)getdata1;
-(void)chageUI;
-(void)rightButtonClick;
-(void)mapTapClick:(UITapGestureRecognizer *)aTap;
-(IBAction)followsClick:(UITapGestureRecognizer *)aTap;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
-(void)callIphone:(UITapGestureRecognizer *)aTap;
-(void)likeClick:(UITapGestureRecognizer *)aTap;
-(void)reciveNotification:(NSNotification *)aNotification;
-(void)ShareClick:(UITapGestureRecognizer *)aTap;
-(void)trendClick:(UITapGestureRecognizer *)aTap;

@property (nonatomic,strong) IBOutlet UIView * allSignView;
@property (nonatomic,strong) IBOutlet UIImageView * IV_email;
@property (nonatomic,strong) IBOutlet UIImageView * IV_facebook;
@property (nonatomic,strong) IBOutlet UILabel * L_skip;
-(void)emailClick:(UITapGestureRecognizer *)aTap;
-(void)faceBookClick:(UITapGestureRecognizer *)aTap;
-(void)skipClick:(UITapGestureRecognizer *)aTap;
-(void)callIphoneStore:(UITapGestureRecognizer *)aTap;
@end

@implementation SafewayViewController
@synthesize merchantId,merchanName;
@synthesize dic;
@synthesize l_adress,l_dealnumber,l_followNumber,l_name1,l_tell;
@synthesize myMapview,V_follows,V_deals,SV_scroll;
@synthesize IV_email,IV_facebook,L_skip,allSignView;
@synthesize trend;
@synthesize dic_recodeClick;
@synthesize L_followsName,L_dealsName;
@synthesize isNotification;
@synthesize middleView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    
    self.trend.isSafeway = YES;
    
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
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"commentAddOne" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentAddOne:) name:@"commentAddOne" object:nil];
    if (self.isLoading)
    {
        [self likesAddOne];
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
        login1= [[LoginViewController alloc] initWithNibName:@"LoginViewController4" bundle:nil];
    }
    login.isBack = YES;
    [self.navigationController pushViewController:login1 animated:YES];
}
-(void)faceBookClick:(UITapGestureRecognizer *)aTap
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen)
    {
        [appDelegate.session closeAndClearTokenInformation];
    }
    else
    {
        if (appDelegate.session.state != FBSessionStateCreated)
        {
            NSArray *permissions = [NSArray arrayWithObjects:@"email", @"publish_stream", @"user_about_me", @"publish_actions", nil];
            appDelegate.session = [[FBSession alloc] initWithPermissions:permissions];
        }
        [appDelegate.session openWithBehavior:FBSessionLoginBehaviorWithFallbackToWebView completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            [self updateView];
        }];
    }
}
- (void)updateView
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen)
    {
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
    }
    else
    {
        NSLog(@"***********");
    }
}

-(void)skipClick:(UITapGestureRecognizer *)aTap
{
    login.view.alpha = 0.0;
}

-(void)rightButtonClick
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
    {
        if ([self.rightBtn.imageView.image isEqual:[UIImage imageNamed:@"follow.png"]])
        {
            
            NSURLRequest * request = [WebService LikeStore:self.merchantId];
            NSURLResponse * response = [[NSURLResponse alloc] init];
            NSError * error = [[NSError alloc] init];
            [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            NSHTTPURLResponse * httpResponse1 = (NSHTTPURLResponse *)response;
            if (httpResponse1.statusCode == 200)
            {
                int number = [self.l_followNumber.text intValue];
                number++;
                self.l_followNumber.text = [NSString stringWithFormat:@"%d",number];
                [self.rightBtn setImage:[UIImage imageNamed:@"followed.png"] forState:UIControlStateNormal];
            }
        }
        else
        {
            NSURLRequest * request = [WebService UnLikeStore:self.merchantId];
            NSURLResponse * response = [[NSURLResponse alloc] init];
            NSError * error = [[NSError alloc] init];
            [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            NSHTTPURLResponse * httpResponse1 = (NSHTTPURLResponse *)response;
            if (httpResponse1.statusCode == 200)
            {
                int number = [self.l_followNumber.text intValue];
                number--;
                self.l_followNumber.text = [NSString stringWithFormat:@"%d",number];
                [self.rightBtn setImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
            }
        }
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you want to login？" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Yes", nil];
        [alert show];

    }
}
-(void)ShareClick:(UITapGestureRecognizer *)aTap
{
    
    UIImageView * imageView = (UIImageView *)[aTap view];
    NSDictionary * dic1 = [[self.dic valueForKey:@"items"] objectAtIndex:imageView.tag];
    
    NSString * linkStr = [NSString stringWithFormat:@"%@/offer/details/index.jsp.oo?offerId=%@",DO_MAIN,[dic1 valueForKey:@"id"]];
    NSString * contentStr = [NSString stringWithFormat:@"%@,%@,$%g,%@",[dic1 valueForKey:@"title"],[dic1 valueForKey:@"merchant"],[[dic1 valueForKey:@"price"] doubleValue],linkStr];
    
    NSMutableAttributedString * attribut = [[NSMutableAttributedString alloc] initWithString:contentStr];
    [attribut removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(0, 10)];
    [attribut addAttribute:NSForegroundColorAttributeName value:(id)[UIColor redColor].CGColor range:NSMakeRange(2, 10)];
    
    NSURLRequest *request5 = [NSURLRequest requestWithURL:[NSURL URLWithString:[dic1 valueForKey:@"smallImg"]]];
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
-(void)mapTapClick
{
    NSLog(@"====%s",__FUNCTION__);
    StoreMapViewController * store;
    if (iPhone5)
    {
        store = [[StoreMapViewController alloc] initWithNibName:@"StoreMapViewController" bundle:nil];
    }
    else
    {
        store = [[StoreMapViewController alloc] initWithNibName:@"StoreMapViewController4" bundle:nil];
    }
    store.lat = [[[self.dic valueForKey:@"storeDetails"] valueForKey:@"latitude"] floatValue];
    store.longt = [[[self.dic valueForKey:@"storeDetails"] valueForKey:@"longitude"] floatValue];
    store.name = [[[self.dic valueForKey:@"items"] objectAtIndex:0] valueForKey:@"merchant"];
    store.merchantId = self.merchantId;
    store.dic = (NSMutableDictionary *)self.dic;
    [self.navigationController pushViewController:store animated:YES];
}
-(void)mapTapClick:(UITapGestureRecognizer *)aTap
{
    NSLog(@"====%s",__FUNCTION__);
    StoreMapViewController * store;
    if (iPhone5)
    {
        store = [[StoreMapViewController alloc] initWithNibName:@"StoreMapViewController" bundle:nil];
    }
    else
    {
        store = [[StoreMapViewController alloc] initWithNibName:@"StoreMapViewController4" bundle:nil];
    }
    store.lat = [[[self.dic valueForKey:@"storeDetails"] valueForKey:@"latitude"] floatValue];
    store.longt = [[[self.dic valueForKey:@"storeDetails"] valueForKey:@"longitude"] floatValue];
    store.name = [[[self.dic valueForKey:@"items"] objectAtIndex:0] valueForKey:@"merchant"];
    store.merchantId = self.merchantId;
    store.dic = (NSMutableDictionary *)self.dic;
    [self.navigationController pushViewController:store animated:YES];
}
-(IBAction)followsClick:(UITapGestureRecognizer *)aTap
{
    if ([self.l_followNumber.text isEqualToString:@"0"])
    {
        FollowsViewController * follows;
        if (iPhone5)
        {
            follows = [[FollowsViewController alloc] initWithNibName:@"FollowsViewController" bundle:nil];
        }
        else
        {
            follows = [[FollowsViewController alloc] initWithNibName:@"FollowsViewController4" bundle:nil];
        }
        [self.navigationController pushViewController:follows animated:YES];
    }
    else
    {
        FollowsViewController * follows;
        if (iPhone5)
        {
            follows = [[FollowsViewController alloc] initWithNibName:@"FollowsViewController" bundle:nil];
        }
        else
        {
            follows = [[FollowsViewController alloc] initWithNibName:@"FollowsViewController4" bundle:nil];
        }
        follows.storeId = self.merchantId;
        follows.safeWay = self;
        [self.navigationController pushViewController:follows animated:YES];
    }
}
-(void)likesAddOne
{
    NSLog(@"%s",__FUNCTION__);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getData];
    });
}
-(void)notificationBackClick
{
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
    [controller showLeftPanelAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.isNotification)
    {
        [self.backBtn setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
        [self.backBtn addTarget:self action:@selector(notificationBackClick) forControlEvents:UIControlStateNormal];
    }
    if ([WebService ISIOS7])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.SV_scroll.frame = CGRectMake(0, 44, 320, [UIScreen mainScreen].bounds.size.height-44);
//    self.myMapview.frame = CGRectMake(0, 0, 320, 130);
//    self.myMapview.userInteractionEnabled = NO;
//    self.myMapview.scrollEnabled = NO;
//    [self.SV_scroll addSubview:self.myMapview];
    
    mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];
    mapImageView.userInteractionEnabled = YES;
    [self.SV_scroll addSubview:mapImageView];
   
   
    
    
#warning - add image
    UIImageView * imageViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65, 320, 65)];
    imageViewBg.alpha = 0.7;
    imageViewBg.userInteractionEnabled = YES;
    [mapImageView addSubview:imageViewBg];
    
    self.l_name1.frame = CGRectMake(15, 10, 150, 30);
    self.l_name1.font = [UIFont fontWithName:AllFont size:AllFontSize];
    [imageViewBg addSubview:self.l_name1];
    self.l_adress.frame = CGRectMake(15, 30, 200, 30);
    self.l_adress.font = [UIFont fontWithName:AllFont size:AllContentSmallSize];
    self.l_adress.numberOfLines = 0;
    self.l_adress.textColor = [UIColor colorWithRed:138.0/255.0 green:138.0/255.0 blue:138.0/255.0 alpha:1.0];
   // self.l_adress.backgroundColor = [UIColor whiteColor];
    [imageViewBg addSubview:self.l_adress];
    
//    self.l_tell.frame = CGRectMake(93, 52, 214, 21);
//    [imageViewBg addSubview:self.l_tell];
    
    self.middleView.frame = CGRectMake(0, 130, 320, 60);
    [self.SV_scroll addSubview:self.middleView];
    
//    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    button1.frame = CGRectMake(230, 15, 40, 40);
//    [button1 setImage:[UIImage imageNamed:@"map_store.png"] forState:UIControlStateNormal];
//    [button1 addTarget:self action:@selector(mapTapClick) forControlEvents:UIControlEventTouchUpInside];
//    [imageViewBg addSubview:button1];
    
    
    UIImageView * imageViewAdress = [[UIImageView alloc] initWithFrame:CGRectMake(230, 15, 40, 40)];
    UITapGestureRecognizer * tapAdress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapClick:)];
    [imageViewAdress addGestureRecognizer:tapAdress];
    imageViewAdress.userInteractionEnabled = YES;
    imageViewAdress.image = [UIImage imageNamed:@"map_store.png"];
    imageViewAdress.clipsToBounds = YES;
    [imageViewBg addSubview:imageViewAdress];
    
    UIImageView * imageViewTell = [[UIImageView alloc] initWithFrame:CGRectMake(270, 15, 40, 40)];
    imageViewTell.image = [UIImage imageNamed:@"call_store.png"];
    imageViewTell.userInteractionEnabled = YES;
    imageViewTell.clipsToBounds = YES;
    UITapGestureRecognizer * tapTellStore = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callIphoneStore:)];
    [imageViewTell addGestureRecognizer:tapTellStore];
    [imageViewBg addSubview:imageViewTell];

    
    
    self.dic_recodeClick = [NSMutableDictionary dictionaryWithCapacity:0];
    arr_lab = [NSMutableArray arrayWithCapacity:0];
    dicLabnum = [NSMutableDictionary dictionaryWithCapacity:0];
    
    self.l_adress.font = [UIFont fontWithName:AllFont size:AllContentSmallSize];
    self.l_dealnumber.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.l_name1.font = [UIFont fontWithName:AllFont size:AllFontSize];
    self.l_tell.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.l_followNumber.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.L_dealsName.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.L_followsName.font = [UIFont fontWithName:AllFont size:AllContentSize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotification:) name:@"change" object:nil];
    
    dict_id = [NSMutableDictionary dictionaryWithCapacity:0];
    dict_lab = [NSMutableDictionary dictionaryWithCapacity:0];
    
   // self.l_navTitle.text = self.merchanName;
    [self.rightBtn setTitle:@"+" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getData];
    });
}

-(void)reciveNotification:(NSNotification *)aNotification
{
    NSDictionary * dic2 = [aNotification userInfo];
    UIImage * image = [dic2 valueForKey:@"image"];
    [self.rightBtn setImage:image forState:UIControlStateNormal];
}
-(void)getdata1
{
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

    
    NSString * formatStr = [NSString stringWithFormat:@"/ws/v2/store/details?storeId=%@&format=json",self.merchantId];
    NSString * url = [DO_MAIN stringByAppendingString:formatStr];
    NSLog(@"url = %@",url);
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeOutSeconds:MAX_SECONDS_REQUEST];
    [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [ request setNumberOfTimesToRetryOnTimeout:3]; //set times when request fail
    [request setDownloadCache:[TKHttpRequest ShareMyCache]];
    [request setSecondsToCache:60*60*2];
    [request setUseCookiePersistence:YES];
    [request buildRequestHeaders];
    [request startSynchronous];
    NSString * strResult = [[NSString alloc] initWithData:[request responseData] encoding:1];
    self.dic = [strResult objectFromJSONString];
    NSLog(@"self.dic = %@",self.dic);
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    manger = manager;
}
-(void)getData
{
    
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
    
   // NSString * formatStr = [NSString stringWithFormat:@"/ws/v2/store/details?storeId=%@&format=json",self.merchantId];
    //NSLog(@"%@=====%@",[[NSUserDefaults standardUserDefaults] valueForKey:USING_LAT],[[NSUserDefaults standardUserDefaults] valueForKey:CURR_LAT]);
     NSString * formatStr = [NSString stringWithFormat:@"/ws/v2/store/details?storeId=%@&latitude=%f&longitude=%f&format=json",self.merchantId,lat,longit];
    NSString * url = [DO_MAIN stringByAppendingString:formatStr];
    NSLog(@"url = %@",url);
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeOutSeconds:MAX_SECONDS_REQUEST];
    [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [ request setNumberOfTimesToRetryOnTimeout:3]; //set times when request fail
    [request setDownloadCache:[TKHttpRequest ShareMyCache]];
    [request setSecondsToCache:60*60*2];
    [request setUseCookiePersistence:YES];
    [request buildRequestHeaders];
    NSMutableData * reciveData = [NSMutableData dataWithCapacity:0];
    [request setStartedBlock:^{
        // self.view.alpha = 0.0;
        [MyActivceView startAnimatedInView:self.view];
    }];
    [request setDataReceivedBlock:^(NSData *data) {
        [reciveData appendData:data];
    }];
    [request setCompletionBlock:^{
        //  self.view.alpha = 1.0;
        [MyActivceView stopAnimatedInView:self.view];
        if ([request responseStatusCode] == 200)
        {
            self.dic = [reciveData objectFromJSONData];
            NSLog(@"dic = %@",dic);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self chageUI];
            });
        }
        else
        {
            ;
        }
    }];
    __weak typeof(self) weakSelf = self;
    [request setFailedBlock:^{
        [MyActivceView stopAnimatedInView:weakSelf.view];
        if ([request responseStatusCode] != 200)
        {
            ;
        }
    }];
    [request startAsynchronous];
}
-(void)trendClick:(UITapGestureRecognizer *)aTap
{
    UIImageView * imageView = (UIImageView *)[aTap view];
    NSDictionary * dicTrend = [[self.dic valueForKey:@"items"] objectAtIndex:imageView.tag];
    TrendDetailViewController * trend1;
    if (iPhone5)
    {
        trend1 = [[TrendDetailViewController alloc] initWithNibName:@"TrendDetailViewController" bundle:nil];
    }
    else
    {
        trend1 = [[TrendDetailViewController alloc] initWithNibName:@"TrendDetailViewController4" bundle:nil];
    }
    NSString * idstr = [dicTrend valueForKey:@"id"];
    if ([[self.dic_recodeClick valueForKey:idstr] isEqualToString:@"1"])
    {
        isClick1 = 2;
    }
    else
    {
        isClick1 = 1;
    }

    trend1.isClick = isClick1;
    trend1.safewayController = self;
    trend1.dic_recode = dicLabnum;
    trend1.dic = dicTrend;
    trend1.isFromTrendStore = YES;
    trend.dic_recode = self.dic_recodeClick;
    trend1.dic_lab_number = dicLabnum;
    trend1.likenumber = [[dicLabnum valueForKey:[dicTrend valueForKey:@"id"]] intValue];
    [self.navigationController pushViewController:trend1 animated:YES];
}
-(void)chageUI
{
    CLLocationCoordinate2D location1;
    location1.latitude = [[[self.dic valueForKey:@"storeDetails"] valueForKey:@"latitude"] floatValue];
    location1.longitude = [[[self.dic valueForKey:@"storeDetails"] valueForKey:@"longitude"] floatValue];
    
    @try {
         NSString * merchanName1 = [NSString stringWithFormat:@"%@",[[self.dic valueForKey:@"storeDetails"] valueForKey:@"name"]];
        self.l_navTitle.font = [UIFont fontWithName:AllFontBold size:All_h2_size];
         self.l_navTitle.text = merchanName1;
    }
    @catch (NSException *exception) {
        NSLog(@"catch error");
    }
    
    
    NSString * path_image = [[self.dic valueForKey:@"storeDetails"] valueForKey:@"logo"];
    ASIHTTPRequest * requestImage = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:path_image]];
    NSMutableData * reciveData_iamge = [NSMutableData dataWithCapacity:0];
    [requestImage setDataReceivedBlock:^(NSData *data) {
        [reciveData_iamge appendData:data];
    }];
    [requestImage setCompletionBlock:^{
        mapImageView.image = [UIImage imageWithData:reciveData_iamge];
    }];
    [requestImage startAsynchronous];
    

//    MKCoordinateRegion region;
//    region.center = location1;
//    MKCoordinateSpan span;
//    span.latitudeDelta = 0.007;
//    span.longitudeDelta = 0.007;
//    region.center = location1;
//    region.span = span;
//    [self.myMapview setRegion:region animated:YES];
    
    
//    MKAnnotation * annotation1 = [[MKAnnotation alloc] initWithCoords:location1];
//    self.myMapview.userInteractionEnabled = NO;
//    [self.myMapview addAnnotation:annotation1];
    
    NSArray * arrKeys = [dic allKeys];
    __block BOOL isSumbit = NO;
    [arrKeys enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:@"submitter"])
        {
            isSumbit = YES;
            *stop = YES;
        }
    }];
    
    
//    if (isSumbit)
//    {
        NSString * currLogin = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_ID]];
        if ([[self.dic valueForKey:@"items"] count]>0)
        {
            if ([currLogin isEqualToString:[[[[self.dic valueForKey:@"items"] objectAtIndex:0] valueForKey:@"submitter"] valueForKey:@"id"]])
            {
                
                //*********************************
                self.rightBtn.alpha = 1.0;
                if ([[[self.dic valueForKey:@"storeDetails"] valueForKey:@"following"] intValue] == 0)
                {
                    [self.rightBtn setImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
                }
                else
                {
                    [self.rightBtn setImage:[UIImage imageNamed:@"followed.png"] forState:UIControlStateNormal];
                }
            }
            else
            {
                self.rightBtn.alpha = 1.0;
                if ([[[self.dic valueForKey:@"storeDetails"] valueForKey:@"following"] intValue] == 0)
                {
                    [self.rightBtn setImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
                }
                else
                {
                    [self.rightBtn setImage:[UIImage imageNamed:@"followed.png"] forState:UIControlStateNormal];
                }
            }
 
        }
   // }
    NSLog(@"self.dic = %@",self.dic);
    NSArray * arrTemp1 = [self.dic valueForKey:@"items"];
    if (arrTemp1.count>0)
    {
        self.l_name1.text = [[[self.dic valueForKey:@"items"] objectAtIndex:0] valueForKey:@"merchant"];
    }
    else
    {
      self.l_name1.text = @"";
    }
    self.l_adress.text = [NSString stringWithFormat:@"%@,%@",[[self.dic valueForKey:@"storeDetails"] valueForKey:@"address"],[[self.dic valueForKey:@"storeDetails"] valueForKey:@"city"]];
   // self.l_tell.text = [[self.dic valueForKey:@"storeDetails"] valueForKey:@"phone"];
    self.l_followNumber.text = [NSString stringWithFormat:@"%@",[[[self.dic valueForKey:@"storeDetails"] valueForKey:@"followers"] stringValue]];
    NSArray * arr = [self.dic valueForKey:@"items"];
    self.l_dealnumber.text = [NSString stringWithFormat:@"%d",[[[self.dic valueForKey:@"storeDetails"] valueForKey:@"offers"] intValue]];
    
    float scroll_heigh = 0.0+200;
    
    for (int i = 0; i<arr.count; i++)
    {
        NSDictionary * dic1 = [[self.dic valueForKey:@"items"] objectAtIndex:i];
        float weitht = 0.0;
        float height = 0.0;
        float height1 = [[dic1 valueForKey:@"height"] floatValue];
        float width1 = [[dic1 valueForKey:@"width"] floatValue];
        float tempHeigh = [UIScreen mainScreen].bounds.size.height/2.0;
        if (height1>tempHeigh)
        {
            if (width1>0)
            {
                weitht = tempHeigh/height1*width1;
                if (weitht>279.0)
                {
                    weitht = 279.0;
                }
                NSLog(@"h1 = %f,w1= %f",height1,width1);
                NSLog(@"weith = %f",weitht);
            }
            else
            {
                weitht = 294.0;
            }
            height = tempHeigh;
        }
        else
        {
            if (width1>0 && height1>0)
            {
              height = 320.0/width1*height1;  
            }
            weitht = 294.0;
        }
        StoreOfferView * offerView = [[StoreOfferView alloc] initWithFrame:CGRectMake(13, scroll_heigh, 294, height+176) andImageHeigh:height andWeigh:weitht];
        offerView.tag = i;
        offerView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapTrend = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(trendClick:)];
        [offerView addGestureRecognizer:tapTrend];
        
        // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [offerView.IV_imageview setImageWithURL:[NSURL URLWithString:[dic1 valueForKey:@"smallImg"]] placeholderImage:[UIImage imageNamed:@"Default.png"]];
        //  });
        
        offerView.L_title.text = [dic1 valueForKey:@"title"];
        
        offerView.L_storename.text = [dic1 valueForKey:@"merchant"];
        NSDateFormatter  * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:([[NSString stringWithFormat:@"%@",[dic1 valueForKey:@"end"]] floatValue]/1000)];
        NSString * dateStr = [formatter stringFromDate:date];
        offerView.TF_time.text = [NSString stringWithFormat:@"Expire:%@",dateStr];
         offerView.L_distance.text = [NSString stringWithFormat:@"%.1f m",[[dic1 valueForKey:@"distance"] floatValue]];
        
        if ([[dic1 valueForKey:@"liked"] intValue] == 0)
        {
            offerView.IV_collect.image = [UIImage imageNamed:@"like.png"];
        }
        else
        {
            offerView.IV_collect.image = [UIImage imageNamed:@"liked.png"];
        }
        offerView.IV_imageview.userInteractionEnabled = YES;
        offerView.L_collectNumber.userInteractionEnabled = YES;
        offerView.L_storename.userInteractionEnabled  = YES;
        
        
        offerView.L_collectNumber.text = [NSString stringWithFormat:@"%@",[dic1 valueForKey:@"likes"]];
        [arr_lab addObject:offerView.L_collectNumber];
        
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeClick:)];
        offerView.IV_collect.userInteractionEnabled = YES;
        [offerView.IV_collect addGestureRecognizer:tap1];
        offerView.IV_collect.tag = 100+i;
        [dict_id setValue:[dic1 valueForKey:@"id"] forKey:[NSString stringWithFormat:@"%d",offerView.IV_collect.tag]];
       // [dict_lab setValue:offerView.L_collectNumber.text forKey:[NSString stringWithFormat:@"%d",offerView.IV_collect.tag]];
        [dict_lab setValue:offerView.L_collectNumber.text forKey:[dic1 valueForKey:@"id"]];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callIphone:)];
        offerView.IV_call.userInteractionEnabled = YES;
        offerView.IV_call.tag = 100+i;
        [offerView.IV_call addGestureRecognizer:tap];
        
        offerView.IV_share.userInteractionEnabled = YES;
        offerView.IV_share.tag = i;
        UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShareClick:)];
        [offerView.IV_share addGestureRecognizer:tap4];
        
        
        scroll_heigh += (height+156.0);
        [self.SV_scroll addSubview:offerView];
    }
    self.SV_scroll.contentSize = CGSizeMake(320, scroll_heigh+20);
    
    if (_refreshTableView == nil)
    {
        //初始化下拉刷新控件
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.SV_scroll.bounds.size.height, self.view.frame.size.width, self.SV_scroll.bounds.size.height)];
        refreshView.delegate = self;
        //将下拉刷新控件作为子控件添加到UITableView中
        [self.SV_scroll addSubview:refreshView];
        _refreshTableView = refreshView;
    }
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
    [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:self.SV_scroll];
    // [waterFlow reloadData];
    [self chageUI];
}
-(void)doInBackground
{
    if ([WebService isConnectionAvailable])
    {
        [self getdata1];
    }
    [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:YES];
}
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
}

-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}

-(NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshTableView egoRefreshScrollViewDidScroll:scrollView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshTableView egoRefreshScrollViewDidEndDragging:scrollView];
    
}
#pragma mark - store call tell
-(void)callIphoneStore:(UITapGestureRecognizer *)aTap
{
   // NSString * strTell = [[self.dic valueForKey:@"storeDetails"] valueForKey:@"phone"];
    NSDictionary * dicTell = [self.dic valueForKey:@"storeDetails"];
    NSArray * tempArr = [dicTell allKeys];
    __block BOOL isHaveTell = NO;
    [tempArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:@"phone"])
        {
            isHaveTell = YES;
            *stop = YES;
        }
    }];
    if (isHaveTell)
    {
        NSString * strTell = [[self.dic valueForKey:@"storeDetails"] valueForKey:@"phone"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",strTell]]];
    }
    else
    {
        [MyAlert ShowAlertMessage:@"No Call" title:@"Alert"];
    }
}
-(void)callIphone:(UITapGestureRecognizer *)aTap
{
    UIImageView * currImage = (UIImageView *)[aTap view];
    int idnex = currImage.tag - 100;
    NSDictionary * dic11 = [[self.dic valueForKey:@"items"] objectAtIndex:idnex];
    NSLog(@"iphone = %@",[NSString stringWithFormat:@"tel://%@",[dic11 valueForKey:@"phone"]]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[dic11 valueForKey:@"phone"]]]];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    reciveData1 = [NSMutableData dataWithCapacity:0];
    httpResponse = (NSHTTPURLResponse *)response;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [reciveData1 appendData:data];
}

- (void) likeUnlike
{
    UILabel * lab = (UILabel *)[arr_lab objectAtIndex:currTag];
    BOOL liked = NO;
    if ([currImageView.image isEqual:[UIImage imageNamed:@"liked.png"]])
    {
        lab.text = [NSString stringWithFormat:@"%d",[lab.text intValue]-1];
        [dicLabnum setValue:lab.text forKey:[[[self.dic valueForKey:@"items"] objectAtIndex:currTag] valueForKey:@"id"]];
        [currImageView setImage:[UIImage imageNamed:@"like.png"]];
        [self.dic_recodeClick setValue:@"0" forKey:[[[self.dic valueForKey:@"items"] objectAtIndex:currTag] valueForKey:@"id"]];
        isClick1 = 1;
    }
    else
    {
        lab.text = [NSString stringWithFormat:@"%d",[lab.text intValue]+1];
        NSLog(@"currtag = %d",currTag);
        NSLog(@"============%@",[[[self.dic valueForKey:@"items"] objectAtIndex:currTag] valueForKey:@"id"]);
        [dicLabnum setValue:lab.text forKey:[[[self.dic valueForKey:@"items"] objectAtIndex:currTag] valueForKey:@"id"]];
        [currImageView setImage:[UIImage imageNamed:@"liked.png"]];
        isClick1 = 2;
        [self.dic_recodeClick setValue:@"1" forKey:[[[self.dic valueForKey:@"items"] objectAtIndex:currTag] valueForKey:@"id"]];
        liked = YES;
    }
    
    NSNumber *num = [NSNumber numberWithBool:liked];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[[self.dic valueForKey:@"items"] objectAtIndex:currTag] forKey:@"offer"];
    [userInfo setValue:num forKey:@"liked"];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"dataChangedNotification" object:nil userInfo:userInfo];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [MyActivceView stopAnimatedInView:self.view];
    NSLog(@"dic = %@",[[NSString alloc] initWithData:reciveData1 encoding:4]);
    if ([httpResponse statusCode] == 200)
    {
        if ([(NSMutableURLRequest *)[connection currentRequest] isEqual:request_like])
        {
           // UILabel * lab = (UILabel *)[dict_lab valueForKey:[NSString stringWithFormat:@"%d",currTag]];
            if ([(NSMutableURLRequest *)[connection currentRequest] isEqual:request_like])
            {
                [self likeUnlike];
            }
        }
        else if ([(NSMutableURLRequest *)[connection currentRequest] isEqual:request_fb])
        {
            NSDictionary * dic_fb = [reciveData1 objectFromJSONData];
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            [user setValue:[dic_fb valueForKey:@"birthYear"] forKey:LOGIN_BIRTHYEAR];
            [user setValue:[dic_fb valueForKey:@"created"] forKey:LOGIN_CREATED];
            [user setValue:[dic_fb valueForKey:@"firstName"] forKey:LOGIN_FIRST_NAME];
            [user setValue:[dic_fb valueForKey:@"gender"] forKey:LOGIN_GENDER];
            [user setValue:[dic_fb valueForKey:@"id"] forKey:LOGIN_ID];
            [user setValue:[dic_fb valueForKey:@"lastName"] forKey:LOGIN_LAST_NAME];
            [user setValue:[dic_fb valueForKey:@"login"] forKey:LOGIN_LOGIN];
            [user setValue:[dic_fb valueForKey:@"noti"] forKey:LOGIN_NOTI];
            [user setValue:[dic_fb valueForKey:@"password"] forKey:LOGIN_PASSWORD];
            [user setValue:[dic_fb valueForKey:@"updated"] forKey:LOGIN_UPDATED];
            [user setValue:[dic_fb valueForKey:@"zipcode"] forKey:LOGIN_ZIPCODE];
            [user setValue:[dic_fb valueForKey:@"img"] forKey:LOGIN_IMAGE];
            [user setValue:[dic_fb valueForKey:@"notifications"] forKey:LOGIN_NOTIFICATION];
            [user setValue:@"1" forKey:LOGIN_STATUS];
            [UIView animateWithDuration:0.3 animations:^{
                 login.view.alpha = 0.0;
            }];
        }
    }
    else
    {
        if ([(NSMutableURLRequest *)[connection currentRequest] isEqual:request_fb])
        {
            [UIView animateWithDuration:0.3 animations:^{
                 login.view.alpha = 0.0;
            }];
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:LOGIN_STATUS];
        }
    }
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [MyActivceView stopAnimatedInView:self.view];
    if ([(NSMutableURLRequest *)[connection currentRequest] isEqual:request_fb])
    {
        [UIView animateWithDuration:0.3 animations:^{
            login.view.alpha = 0.0;
        }];
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:LOGIN_STATUS];
    }
}
-(void)likeClick:(UITapGestureRecognizer *)aTap
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
    {
        UIImageView * imageView = (UIImageView *)[aTap view];
        currTag = imageView.tag-100;
        currImageView = imageView;
        NSString * idstr = [dict_id valueForKey:[NSString stringWithFormat:@"%d",imageView.tag]];
        if ([imageView.image isEqual:[UIImage imageNamed:@"liked.png"]])
        {
            request_like = [WebService UnLikeOffer:idstr];
            [self likeUnlike];
            [NSURLConnection connectionWithRequest:request_like delegate:nil];
        }
        else
        {
            request_like = [WebService LikeOffer:idstr];
            [self likeUnlike];
            [NSURLConnection connectionWithRequest:request_like delegate:nil];
        }
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you want to login？" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
       login.view.alpha = 1.0;
    }
    else
    {
     login.view.alpha = 0.0;
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
