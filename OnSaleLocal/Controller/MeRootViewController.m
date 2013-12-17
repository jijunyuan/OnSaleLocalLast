//
//  MeRootViewController.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-29.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "MeRootViewController.h"
#import "TKHttpRequest.h"
#import "StoreOfferView.h"
#import "EGORefreshTableHeaderView.h"
#import "StoreFollowersViewController.h"
#import "FollowsViewController.h"
#import "MeViewController.h"
#import "UMSocial.h"
#import "LikeTrendListViewController.h"
#import "TrendDetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface MeRootViewController ()<EGORefreshTableHeaderDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>
{
    NSString * userid;
    EGORefreshTableHeaderView *_refreshTableView;
    BOOL _reloading;
    
    int currTag;
    UIImageView * currImageView;
    
    NSMutableDictionary * dict_lab;
    NSMutableDictionary * dict_id;
    
    NSMutableData * reciveData1;
    NSHTTPURLResponse * httpResponse;
    NSMutableURLRequest * request_like;
    NSMutableDictionary * dicLabnum;
    
     LoginViewController * login;
    
    float currY;
    float oldY;
    int currPage;
    
    int isClick1;
    
    int currfollowing1;
    NSString * tempStoreFollow;
    
    
    NSMutableURLRequest * request_follow;
    
    CLLocationManager * manger;
    
    
    NSMutableURLRequest* request_fb;
    // NSMutableData * reciveData;
    //  NSHTTPURLResponse * httpResponse;
}
@property (nonatomic,strong) IBOutlet UILabel * L_name;
@property (nonatomic,strong) IBOutlet UILabel * L_follows;
@property (nonatomic,strong) IBOutlet UILabel * L_followings;
@property (nonatomic,strong) IBOutlet UILabel * L_shared;
@property (nonatomic,strong) IBOutlet UILabel * L_likes;
@property (nonatomic,strong) IBOutlet UILabel * L_storeFollowed;
@property (nonatomic,strong) IBOutlet UIImageView * IV_photo;
@property (nonatomic,strong) IBOutlet UIScrollView * myScroll;
@property (nonatomic,strong) NSMutableDictionary * dic_recodeClick;
@property (nonatomic,strong) NSMutableDictionary * dataArr;
@property (nonatomic,strong) NSMutableDictionary * userInfo;

@property(nonatomic,strong) IBOutlet UIView * middleView1;
@property (nonatomic,strong) IBOutlet UIView * middleView2;

@property (nonatomic,strong) IBOutlet UILabel * l_tl1,*l_yl2,*l_tl3;
@property (nonatomic,strong) IBOutlet UILabel * l_tl11,*l_yl22,*l_tl33;

-(void)getData;
-(void)getData1;
-(void)getdata2;
-(void)changeUI;
-(IBAction)StoreFollowedClick:(UITapGestureRecognizer *)aTap;
-(IBAction)FollowClick:(UITapGestureRecognizer *)aTap;
-(IBAction)StoreFollowingClick:(UITapGestureRecognizer *)aTap;
-(IBAction)likesClick:(UITapGestureRecognizer *)aTap;
-(void)shakeClick:(UITapGestureRecognizer *)aTap;
-(void)detailStore:(UITapGestureRecognizer *)aTap;

-(void)changeFollowings:(NSNotification *)aNotification;
-(void)changeFollows:(NSNotification *)aNotification;
-(void)rightButtonClick:(UIButton *)aButton;


@property (nonatomic,strong) IBOutlet UIView * allSignView;
@property (nonatomic,strong) IBOutlet UIImageView * IV_email;
@property (nonatomic,strong) IBOutlet UIImageView * IV_facebook;
@property (nonatomic,strong) IBOutlet UILabel * L_skip;
-(void)emailClick:(UITapGestureRecognizer *)aTap;
-(void)faceBookClick:(UITapGestureRecognizer *)aTap;
-(void)skipClick:(UITapGestureRecognizer *)aTap;


@end

@implementation MeRootViewController
@synthesize L_name,L_shared,L_storeFollowed,L_likes,L_follows,L_followings,IV_photo,myScroll;
@synthesize dataArr;
@synthesize userid;
@synthesize dic_recodeClick;
@synthesize isLoading;
@synthesize storefollowsNum;
@synthesize isFromSetting;
@synthesize allSignView,IV_email,IV_facebook,L_skip;
@synthesize isNotification;
@synthesize middleView1,middleView2;
@synthesize l_tl1,l_tl3,l_yl2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void)changeFollowings:(NSNotification *)aNotification
{
    NSDictionary * dicStr1 = [aNotification userInfo];
    NSLog(@"dicstr1 = %@",dicStr1);
    NSString * str1 = [dicStr1 valueForKey:@"count"];
    self.L_followings.text = str1;
}
-(void)changeFollows:(NSNotification *)aNotification
{
    NSDictionary * dicStr1 = [aNotification userInfo];
    NSLog(@"dicstr1 = %@",dicStr1);
    NSString * str1 = [dicStr1 valueForKey:@"count"];
    self.L_follows.text = str1;
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
    [self.navigationController pushViewController:login animated:YES];
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
   // [self.allSignView removeFromSuperview];
}

-(void)changeUI
{
    NSArray * arr = [self.dataArr valueForKey:@"items"];
    float scroll_heigh = 160;
    for (int i = 0; i<arr.count; i++)
    {
        NSDictionary * dic1 = [arr objectAtIndex:i];
        float weitht = 0.0;
        float height = 0.0;
        float height1 = [[dic1 valueForKey:@"height"] floatValue];
        float width1 = [[dic1 valueForKey:@"width"] floatValue];
        float tempHeigh = [UIScreen mainScreen].bounds.size.height/2.0;
        if (height1>tempHeigh)
        {
            if (height1 != 0)
            {
                weitht = tempHeigh/height1*width1;
            }
            else
            {
                weitht = 0;
            }
            height = tempHeigh;
        }
        else
        {
            if (width1 != 0)
            {
                height = 294.0/width1*height1;
            }
            else
            {
                height =0;
            }
            weitht = 294.0;
        }
        // NSLog(@"width = %g,heigh = %g",height,weitht);
        StoreOfferView * offerView = [[StoreOfferView alloc] initWithFrame:CGRectMake(13, scroll_heigh+10, 294, (height+176.0)) andImageHeigh:height andWeigh:weitht];
        // NSLog(@"=====heigh = %f=======================high = %f",(height+156.0),(height+156)*i);
        [offerView.IV_imageview setImageWithURL:[NSURL URLWithString:[dic1 valueForKey:@"largeImg"]] placeholderImage:nil];
        offerView.L_title.text = [dic1 valueForKey:@"title"];
        offerView.L_storename.text = [dic1 valueForKey:@"merchant"];
        
        NSDateFormatter  * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:([[NSString stringWithFormat:@"%@",[dic1 valueForKey:@"end"]] floatValue]/1000)];
        
        offerView.L_distance.text = [NSString stringWithFormat:@"%.1f m",[[dic1 valueForKey:@"distance"] floatValue]];
        
        NSString * dateStr = [formatter stringFromDate:date];
        offerView.TF_time.text = [NSString stringWithFormat:@"Ends %@",dateStr];
        
        if ([[dic1 valueForKey:@"liked"] intValue] == 0)
        {
            offerView.IV_collect.image = [UIImage imageNamed:@"like.png"];
        }
        else
        {
            offerView.IV_collect.image = [UIImage imageNamed:@"liked.png"];
        }
        
        offerView.L_collectNumber.text = [NSString stringWithFormat:@"%@",[dic1 valueForKey:@"likes"]];
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeClick:)];
        offerView.IV_collect.userInteractionEnabled = YES;
        [offerView.IV_collect addGestureRecognizer:tap1];
        offerView.IV_collect.tag = 100+i;
        [dict_id setValue:[dic1 valueForKey:@"id"] forKey:[NSString stringWithFormat:@"%d",offerView.IV_collect.tag]];
        [dict_lab setValue:offerView.L_collectNumber forKey:[NSString stringWithFormat:@"%d",offerView.IV_collect.tag]];
        
        offerView.IV_share.userInteractionEnabled = YES;
        UITapGestureRecognizer * shareTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shakeClick:)];
        offerView.IV_share.tag = i;
        [offerView.IV_share addGestureRecognizer:shareTap];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callIphone:)];
        offerView.IV_call.tag = 10+i;
        offerView.IV_call.userInteractionEnabled = YES;
        [offerView.IV_call addGestureRecognizer:tap];
        
        UITapGestureRecognizer * tapDetail = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailStore:)];
        [offerView.IV_imageview addGestureRecognizer:tapDetail];
        offerView.IV_imageview.tag = i;
        offerView.IV_imageview.userInteractionEnabled = YES;
        
        scroll_heigh += (height+156.0);
        [self.myScroll addSubview:offerView];
    }
    self.myScroll.contentSize = CGSizeMake(320, scroll_heigh+20);
    
    if (_refreshTableView == nil)
    {
        //初始化下拉刷新控件
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.myScroll.bounds.size.height, self.view.frame.size.width, self.myScroll.bounds.size.height)];
        refreshView.delegate = self;
        //将下拉刷新控件作为子控件添加到UITableView中
        [self.myScroll addSubview:refreshView];
        _refreshTableView = refreshView;
    }
}
-(void)refrasehView
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_ID] isEqualToString:self.userid])
    {
        self.rightBtn.alpha = 0.0;
    }
    
    
    if (self.followingLabNum.length>0)
    {
        self.L_followings.text = self.followingLabNum;
        self.L_storeFollowed.text = tempStoreFollow;
    }
    if (self.followNumLabNum.length>0)
    {
        self.L_follows.text = self.followNumLabNum;
        self.L_storeFollowed.text = tempStoreFollow;
    }
    if (self.followingLabNum.length>0)
    {
        self.L_storeFollowed.text = self.storefollowsNum;
    }
    
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
    {
//        // [self.view addSubview:self.allSignView];
//        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipClick:)];
//        UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceBookClick:)];
//        UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emailClick:)];
//        self.IV_facebook.userInteractionEnabled = YES;
//        self.IV_email.userInteractionEnabled = YES;
//        self.L_skip.userInteractionEnabled = YES;
//        [self.IV_email addGestureRecognizer:tap3];
//        [self.IV_facebook addGestureRecognizer:tap2];
//        [self.L_skip addGestureRecognizer:tap1];
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
       // [self.allSignView removeFromSuperview];
         login.view.alpha = 0.0;
    }
    [self getData];
}
-(void)viewWillAppear:(BOOL)animated
{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidLoad) name:@"refreshRoot" object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFollows:) name:@"changeFollow" object:nil];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_ID] isEqualToString:self.userid])
    {
        self.rightBtn.alpha = 0.0;
    }
    
    if (self.followingLabNum.length>0)
    {
        self.L_followings.text = self.followingLabNum;
        self.L_storeFollowed.text = tempStoreFollow;

    }
    if (self.followNumLabNum.length>0)
    {
        self.L_follows.text = self.followNumLabNum;
        self.L_storeFollowed.text = tempStoreFollow;
    }
    if (self.followingLabNum.length>0)
    {
        self.L_storeFollowed.text = self.storefollowsNum;
    }
    
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
    {
//        // [self.view addSubview:self.allSignView];
//        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipClick:)];
//        UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceBookClick:)];
//        UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emailClick:)];
//        self.IV_facebook.userInteractionEnabled = YES;
//        self.IV_email.userInteractionEnabled = YES;
//        self.L_skip.userInteractionEnabled = YES;
//        [self.IV_email addGestureRecognizer:tap3];
//        [self.IV_facebook addGestureRecognizer:tap2];
//        [self.L_skip addGestureRecognizer:tap1];
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
       // [self.allSignView removeFromSuperview];
         login.view.alpha = 0.0;
    }
    
    //    if (self.isLoading)
    //    {
   // [self getData];
    // }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeFollowing" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeFollow" object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.l_tl1.font = [UIFont fontWithName:AllFont size:AllContentSmallSize];
    self.l_yl2.font = [UIFont fontWithName:AllFont size:AllContentSmallSize];
    self.l_tl3.font = [UIFont fontWithName:AllFont size:AllContentSmallSize];
    
    if ([WebService ISIOS7])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.middleView1.frame = CGRectMake(0, 0, 320, 110);
    self.middleView2.frame = CGRectMake(0, 110, 320, 50);
    [self.myScroll addSubview:self.middleView1];
    [self.myScroll addSubview:self.middleView2];
    
    self.L_followings.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.L_follows.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.L_name.font = [UIFont fontWithName:AllFont size:All_h2_size];
    self.L_shared.font = [UIFont fontWithName:AllFont size:All_h2_size];
    self.L_likes.font = [UIFont fontWithName:AllFont size:All_h2_size];
    self.L_storeFollowed.font = [UIFont fontWithName:AllFont size:All_h2_size];
    self.l_navTitle.font = [UIFont fontWithName:AllFontBold size:All_h2_size];
    
    self.IV_photo.layer.cornerRadius = 40;
    self.dic_recodeClick = [NSMutableDictionary dictionaryWithCapacity:0];
    dict_lab = [NSMutableDictionary dictionaryWithCapacity:0];
    dicLabnum = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (self.userid.length>0 && self.isFromSetting == NO)
    {
        self.leftButton.imageView.image = nil;
        //self.leftButton.frame = CGRectMake(self.leftButton.frame.origin.x, self.leftButton.frame.origin.y+5, 30, 30);
        self.leftButton.frame = CGRectMake(0, self.leftButton.frame.origin.y+5, 30, 30);
        [self.leftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    }
    dict_id = [NSMutableDictionary dictionaryWithCapacity:0];
    
    currPage = 0;
    
    [self getData];

    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        [self getData];
    //    });
}
-(void)backClick:(UIButton *)aButton
{
    //    NSLog(@"self.userid = %@",self.userid);
    //    if ([[NSUserDefaults standardUserDefaults] valueForKey:<#(NSString *)#>])
    //    {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }
    if (!isFromSetting)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [super backClick:aButton];
    }
}
-(void)getdata2
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

    NSString * formatStr = [NSString stringWithFormat:@"/ws/user/offers?userId=%@&latitude=%f&longitude=%f&format=json",userid,lat,longit];
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
    self.dataArr = [[request responseData] objectFromJSONData];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    manger = manager;
}
-(void)getData
{
    NSString * formatStr;
    if (self.userid.length>0)
    {
        formatStr = [NSString stringWithFormat:@"/ws/user/details?&userId=%@&format=json",self.userid];
    }
    else
    {
        formatStr = [NSString stringWithFormat:@"/ws/user/me?format=json"];
    }
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
        [MyActivceView startAnimatedInView:self.view];
    }];
    [request setDataReceivedBlock:^(NSData *data) {
        [reciveData appendData:data];
    }];
    [request setCompletionBlock:^{
        if ([request responseStatusCode] == 200)
        {
            NSDictionary * dic = [reciveData objectFromJSONData];
            self.userInfo = [NSMutableDictionary dictionaryWithDictionary:dic];
            NSString * name = [[dic valueForKey:@"firstName"] stringByAppendingFormat:@" %@",[dic valueForKey:@"lastName"]];
            self.l_navTitle.font = [UIFont fontWithName:AllFontBold size:All_h2_size];
            self.l_navTitle.text = [dic valueForKey:@"firstName"];
            
            if (![[dic valueForKey:@"id"] isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_ID]])
            {
                NSString * resultStr1 = [NSString stringWithFormat:@"%@",[dic valueForKey:@"myFollowing"]];
            
                if ([resultStr1 isEqualToString:@"0"])
                {
                    [self.rightBtn setImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
                }
                else
                {
                    [self.rightBtn setImage:[UIImage imageNamed:@"followed.png"] forState:UIControlStateNormal];
                }
                self.rightBtn.frame = CGRectMake(self.rightBtn.frame.origin.x+10, self.rightBtn.frame.origin.y+1, 30, 30);
                [self.rightBtn addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            
            self.L_name.text = name;
            self.L_follows.text = [[NSString stringWithFormat:@"%d",[[dic valueForKey:@"followers"] intValue]] stringByAppendingFormat:@" followers"];
            self.L_followings.text = [[NSString stringWithFormat:@"     %d",[[dic valueForKey:@"followings"] intValue]] stringByAppendingFormat:@" following"];
            
            // currfollowing1 = [[dic valueForKey:@"followings"] intValue];
            
            
            self.L_likes.textAlignment = NSTextAlignmentCenter;
            self.L_shared.textAlignment = NSTextAlignmentCenter;
            self.L_storeFollowed.textAlignment = NSTextAlignmentCenter;
            self.L_likes.text = [[NSString stringWithFormat:@"%d",[[dic valueForKey:@"likes"] intValue]] stringByAppendingFormat:@""];
            self.L_shared.text = [[NSString stringWithFormat:@"%d",[[dic valueForKey:@"offers"] intValue]] stringByAppendingFormat:@""];
            self.L_storeFollowed.text = [[NSString stringWithFormat:@"%d",[[dic valueForKey:@"stores"] intValue]] stringByAppendingFormat:@""];
            tempStoreFollow = self.L_storeFollowed.text;
            
            userid = [dic valueForKey:@"id"];
            
            NSArray * allkeys = [dic allKeys];
            __block BOOL isHave = NO;
            NSLog(@"allkeys = %@",allkeys);
            [allkeys enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
                if ([obj isEqualToString:@"img"])
                {
                    isHave = YES;
                    *stop = YES;
                }
            }];
            
            if (isHave)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"imageurl = %@",[dic valueForKey:@"img"]);
                    NSURL * url = [NSURL URLWithString:[dic valueForKey:@"img"]];
                    NSData * data2 = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:nil error:nil];
                    self.IV_photo.image = [UIImage imageWithData:data2];
                });
            }
            else
            {
                self.IV_photo.image = [UIImage imageNamed:@"avatar_80x80.png"];
            }
        }
        else
        {
            //[MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData] title:@""];
        }
        [self getData1];
    }];
    
    [request setFailedBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        if ([request responseStatusCode] != 200)
        {
           // [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData] title:@""];
        }
    }];
    [request startAsynchronous];
}
-(void)rightButtonClick:(UIButton *)aButton
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
    {
        if ([aButton.currentImage isEqual:[UIImage imageNamed:@"follow.png"]])
        {
            [self followUnfollowUser:userid :YES :nil];
        }
        else
        {
            [self followUnfollowUser:userid :NO :nil];
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
        [self.view addSubview:self.allSignView];
    }
}
-(void)getData1
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
    
    NSString * formatStr = [NSString stringWithFormat:@"/ws/user/offers?userId=%@&offset=%d&latitude=%f&longitude=%f&format=json",userid,currPage,lat,longit];
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
    }];
    [request setDataReceivedBlock:^(NSData *data) {
        [reciveData appendData:data];
    }];
    [request setCompletionBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        if ([request responseStatusCode] == 200)
        {
            self.dataArr = [reciveData objectFromJSONData];
            NSLog(@"self.dataArr = %@",self.dataArr);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self changeUI];
            });
        }
        else
        {
          //  [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData] title:@""];
        }
    }];
    
    [request setFailedBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        if ([request responseStatusCode] != 200)
        {
           // [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData] title:@""];
        }
    }];
    [request startAsynchronous];
    
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
    [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myScroll];
    [self changeUI];
}
-(void)doInBackground
{
    if ([WebService isConnectionAvailable])
    {
        [self getdata2];
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
    self.myScroll.bounces = YES;
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
    
    // NSLog(@"=cyrry = %f=oldy=%f===%d",currY,oldY,currY>oldY);
    if (currY>oldY)
    {
        if (currY == 0.0)
        {
            scrollView.bounces = YES;
        }
        else
        {
            scrollView.bounces = NO;
        }
        
        if (([[NSNumber numberWithFloat:currentOffset] intValue] == [[NSNumber numberWithFloat:maximumOffset] intValue]))
        {
            // NSLog(@"\n*********************************\n");
            if (self.dataArr.count>=(currPage+20))
            {
                //NSLog(@"\n***xxxxxxxxxxxxxxxxx*******\n");
                currPage += 20;
                // NSLog(@"currpage = %d",currPage);
                [self getData1];
            }
        }
    }
    else
    {
        scrollView.bounces = YES;
    }
    oldY = currY;
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshTableView egoRefreshScrollViewDidEndDragging:scrollView];
    
}
-(void)callIphone:(UITapGestureRecognizer *)aTap
{
    UIImageView * currImage = (UIImageView *)[aTap view];
    int idnex = currImage.tag - 10;
    NSDictionary * dic11 = [[self.dataArr valueForKey:@"items"] objectAtIndex:idnex];
    // NSLog(@"==================dic1 = %@",dic11);
    NSLog(@"iphone = %@",[NSString stringWithFormat:@"tel://%@",[dic11 valueForKey:@"phone"]]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[dic11 valueForKey:@"phone"]]]];
}
-(void)likeClick:(UITapGestureRecognizer *)aTap
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
    {
        UIImageView * imageView = (UIImageView *)[aTap view];
        currTag = imageView.tag;
        currImageView = imageView;
        int itemIndex = currTag - 100;
        NSString * idstr = [dict_id valueForKey:[NSString stringWithFormat:@"%d",imageView.tag]];
        if ([imageView.image isEqual:[UIImage imageNamed:@"liked.png"]])
        {
            request_like = [WebService UnLikeOffer:idstr];
            [self likeUnlike:[[self.dataArr valueForKey:@"items"] objectAtIndex:itemIndex] :NO :nil];
            [NSURLConnection connectionWithRequest:request_like delegate:nil];
            //        NSString * str = self.L_likes.text;
            //        NSArray * arr = [str componentsSeparatedByString:@" "];
            //        NSLog(@"arr = %@",arr);
            //        self.L_likes.text = [NSString stringWithFormat:@"%d likes",[[arr objectAtIndex:0] intValue]-1];
        }
        else
        {
            request_like = [WebService LikeOffer:idstr];
            [self likeUnlike:[[self.dataArr valueForKey:@"items"] objectAtIndex:itemIndex] :YES :nil];
            [NSURLConnection connectionWithRequest:request_like delegate:nil];
            //        NSString * str = self.L_likes.text;
            //        NSArray * arr = [str componentsSeparatedByString:@" "];
            //        NSLog(@"arr = %@",arr);
            //        self.L_likes.text = [NSString stringWithFormat:@"%d likes",[[arr objectAtIndex:0] intValue]+1];
        }
        
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you want to login？" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Yes", nil];
        [alert show];
        
    }
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

-(void)dataChangedNotificationCallback:(NSNotification *)noti
{
    [super dataChangedNotificationCallback:noti];
    NSDictionary *userInfo = noti.userInfo;
    
    NSNumber *liked = [userInfo objectForKey:@"liked"];
    if(liked) {
        NSString * likedOfferId = [[userInfo objectForKey:@"offer"] objectForKey:@"id"];
        [self changeOfferLikeState:likedOfferId liked:[liked boolValue]];
    }
    
    NSNumber *followUser = [userInfo objectForKey:@"followUser"];
    if(followUser) {
        NSString * userId = [userInfo objectForKey:@"userId"];
        [self changeUserFollowState:userId followed:[followUser boolValue]];
    }
    
    NSNumber *followStore = [userInfo objectForKey:@"followStore"];
    if(followStore) {
        NSString * storeId = [userInfo objectForKey:@"storeId"];
        [self changeStoreFollowState:storeId followed:[followStore boolValue]];
    }
}

- (void)changeStoreFollowState:(NSString *)userId followed:(BOOL)followed
{
    
}

- (void)changeUserFollowState:(NSString *)userId followed:(BOOL)followed
{
    if (![[self.userInfo valueForKey:@"id"] isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_ID]])
    {
        // not me page
        if([userId isEqualToString:[self.userInfo valueForKey:@"id"]]) {
            // follow/unfollowed current user
            if (!followed) {
                [self.rightBtn setImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
            }
            else {
                [self.rightBtn setImage:[UIImage imageNamed:@"followed.png"] forState:UIControlStateNormal];
            }
            int newFollowers = [[self.userInfo objectForKey:@"followers"] intValue] + (followed ? 1 : -1);
            [self.userInfo setObject:[NSNumber numberWithInt:newFollowers] forKey:@"followers"];
            self.L_follows.text = [[NSString stringWithFormat:@"%d",[[self.userInfo valueForKey:@"followers"] intValue]] stringByAppendingFormat:@" follower"];
        }
    }
    else {
        int newFollowings = [[self.userInfo objectForKey:@"followings"] intValue] + (followed ? 1 : -1);
        [self.userInfo setObject:[NSNumber numberWithInt:newFollowings] forKey:@"followings"];
        self.L_followings.text = [[NSString stringWithFormat:@"%d",[[self.userInfo valueForKey:@"followings"] intValue]] stringByAppendingFormat:@" followings"];
    }
}

- (void)changeOfferLikeState:(NSString *)likedOfferId liked:(BOOL)like
{
    NSMutableDictionary *newData = [NSMutableDictionary dictionaryWithDictionary:self.dataArr];
    NSMutableArray *newItems = [NSMutableArray arrayWithArray:[newData objectForKey:@"items"]];
    [newData setObject:newItems forKey:@"items"];
    
    NSMutableDictionary *dict = nil;
    for(int i=0; i<[newItems count]; i++) {
        if([[[newItems objectAtIndex:i] objectForKey:@"id"] isEqualToString:likedOfferId]) {
            dict = [NSMutableDictionary dictionaryWithDictionary:[newItems objectAtIndex:i]];
            [newItems replaceObjectAtIndex:i withObject:dict];
            NSNumber *likes = [NSNumber numberWithInt:([[dict objectForKey:@"likes"] intValue] + (like ? 1 : -1))];
            [dict setValue:likes forKey:@"likes"];
            [dict setValue:[NSNumber numberWithBool:like] forKey:@"liked"];
            break;
        }
    }
    
    self.dataArr = newData;

    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_ID] isEqualToString:self.userid]) {
        int newUserLikes = [self.L_likes.text intValue] + (like ? 1 : -1);
        self.L_likes.text = [NSString stringWithFormat:@"%d", newUserLikes];
    }
    
    for (id subview in [self.myScroll subviews]) {
        if([subview isKindOfClass:[StoreOfferView class]]) {
            StoreOfferView *offerView = subview;
            NSString *itemOfferId = [[newItems objectAtIndex:(offerView.IV_collect.tag-100)] objectForKey:@"id"];
            if([likedOfferId isEqualToString:itemOfferId]) {
                if ([[dict valueForKey:@"liked"] intValue] == 0)
                {
                    offerView.IV_collect.image = [UIImage imageNamed:@"like.png"];
                }
                else
                {
                    offerView.IV_collect.image = [UIImage imageNamed:@"liked.png"];
                }
                offerView.L_collectNumber.text = [[dict objectForKey:@"likes"] stringValue];
            }
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"dic = %@",[[NSString alloc] initWithData:reciveData1 encoding:4]);
    if ([httpResponse statusCode] == 200)
    {
        if ([(NSMutableURLRequest *)[connection currentRequest] isEqual:request_follow])
        {
            if ([self.rightBtn.currentImage isEqual:[UIImage imageNamed:@"follow.png"]])
            {
                [self.rightBtn setImage:[UIImage imageNamed:@"followed.png"] forState:UIControlStateNormal];
            }
            else
            {
                [self.rightBtn setImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
            }
        }
        if ([(NSMutableURLRequest *)[connection currentRequest] isEqual:request_fb])
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
                self.allSignView.alpha = 0.0;
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
        
      //  [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData1] title:@""];
    }
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([(NSMutableURLRequest *)[connection currentRequest] isEqual:request_fb])
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.allSignView.alpha = 0.0;
        }];
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:LOGIN_STATUS];
    }
    
  //  [MyAlert ShowAlertMessage:@"Not to force the network" title:@""];
}
-(IBAction)StoreFollowedClick:(UITapGestureRecognizer *)aTap
{
    StoreFollowersViewController * store;
    if (iPhone5)
    {
        store = [[StoreFollowersViewController alloc] initWithNibName:@"StoreFollowersViewController" bundle:nil];
    }
    else
    {
        store = [[StoreFollowersViewController alloc] initWithNibName:@"StoreFollowersViewController4" bundle:nil];
    }
    store.meRootController = self;
    store.userid = userid;
    store.isLikes = NO;
    [self.navigationController pushViewController:store animated:YES];
}
-(IBAction)FollowClick:(UITapGestureRecognizer *)aTap
{
    MeViewController * me;
    if (iPhone5)
    {
        me = [[MeViewController alloc] initWithNibName:@"FollowsViewController" bundle:nil];
    }
    else
    {
        me = [[MeViewController alloc] initWithNibName:@"FollowsViewController4" bundle:nil];
    }
    me.meRootController = self;
    me.userId = userid;
    
    me.currFollowings =currfollowing1;
    me.isFollowing = NO;
    [self.navigationController pushViewController:me animated:YES];
}
-(IBAction)StoreFollowingClick:(UITapGestureRecognizer *)aTap
{
    MeViewController * me;
    if (iPhone5)
    {
        me = [[MeViewController alloc] initWithNibName:@"FollowsViewController" bundle:nil];
    }
    else
    {
        me = [[MeViewController alloc] initWithNibName:@"FollowsViewController4" bundle:nil];
    }
    me.meRootController = self;
    me.userId = userid;
    me.isFollowing = YES;
    [self.navigationController pushViewController:me animated:YES];
}
-(IBAction)likesClick:(UITapGestureRecognizer *)aTap
{
    
    LikeTrendListViewController * liketrend;
    if (iPhone5)
    {
        liketrend = [[LikeTrendListViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    }
    else
    {
        liketrend = [[LikeTrendListViewController alloc] initWithNibName:@"ViewController4" bundle:nil];
    }
    liketrend.isFromMeLikes = YES;
    liketrend.userid = userid;
    [self.navigationController pushViewController:liketrend animated:YES];
}
-(void)shakeClick:(UITapGestureRecognizer *)aTap
{
    UIImageView * imageview = (UIImageView *)[aTap view];
    NSDictionary * dic = [[self.dataArr valueForKey:@"items"] objectAtIndex:imageview.tag];
    NSString * linkStr = [NSString stringWithFormat:@"%@/offer/details/index.jsp.oo?offerId=%@",DO_MAIN,[dic valueForKey:@"id"]];
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
-(void)detailStore:(UITapGestureRecognizer *)aTap
{
    
    UIImageView * imageView = (UIImageView *)[aTap view];
    NSArray * arr = [self.dataArr valueForKey:@"items"];
    NSDictionary * dicTrend = [arr objectAtIndex:imageView.tag];
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
    
  //  trend1.isFromNotification = YES;
//    if (self.userid.length>0)
//    {
//        trend1.userId_notification = self.userid;
//    }
//    else
//    {
//        trend1.userId_notification = [[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_ID];
//    }
    trend1.userId_notification = [dicTrend valueForKey:@"id"];
    NSLog(@"trend1.userId_notification = %@",trend1.userId_notification);
    trend1.isNotification = YES;
    trend1.isFromNotification = YES;
    
    trend1.isClick = isClick1;
    trend1.dic_recode = dicLabnum;
   // trend1.dic = dicTrend;
    trend1.isFromTrendStore = YES;
    trend1.dic_recode = self.dic_recodeClick;
    trend1.dic_lab_number = dicLabnum;
    trend1.likenumber = [[dicLabnum valueForKey:[dicTrend valueForKey:@"id"]] intValue];
    trend1.meRootController = self;
    [self.navigationController pushViewController:trend1 animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
