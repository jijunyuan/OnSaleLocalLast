//
//  TrendDetailViewController.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-20.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "TrendDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TKHttpRequest.h"
#import "WebService.h"
#import "MyAlert.h"
#import "NSString+JsonString.h"
#import "JSONKit.h"
#import <MapKit/MapKit.h>
#import "MKAnnotation.h"
#import "EGORefreshTableHeaderView.h"
#import "SafewayViewController.h"
#import "CommentViewController.h"
#import "UMSocial.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "AccountSettingViewController.h"
#import "MeRootViewController.h"
#import "ViewController.h"
#import "BuyNowViewController.h"
#import "AppDelegate.h"
#import "MSLabel.h"

@interface TrendDetailViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,NSURLConnectionDelegate,UIAlertViewDelegate,UMSocialUIDelegate>
{
    float height;
    float weight;
    EGORefreshTableHeaderView *_refreshTableView;
    BOOL _reloading;
    UIImageView * shareImg;
    UIImageView * topImage;
    UIImageView * shareCheck;
    
    NSMutableData * reciveData;
    NSHTTPURLResponse * httpResponse;
    NSMutableURLRequest * request_like;
    
    UIImageView * currImageView;
    NSMutableURLRequest* request_fb;
    NSMutableURLRequest* request_follow;
    
    UILabel * l_comment_num;
    __block BOOL isSumbit;
    
    LoginViewController * login;
    NSMutableDictionary * lineDic;
}
@property (nonatomic,strong) IBOutlet UIScrollView * myScrollView;
@property (nonatomic,strong) IBOutlet UIView * middleView;
@property (nonatomic,strong) IBOutlet UIImageView * IV_collect;
@property (nonatomic,strong) IBOutlet UIImageView * IV_comment;
@property (nonatomic,strong) IBOutlet UIImageView * IV_call;
@property (nonatomic,strong) IBOutlet UIView * mapSmallView;
@property (nonatomic,strong) IBOutlet UILabel * L_street;
@property (nonatomic,strong) IBOutlet UILabel * L_down;
@property (nonatomic,strong) IBOutlet UILabel * L_contact;
@property (nonatomic,strong) IBOutlet UIImageView * IV_contact;
@property (nonatomic,strong) IBOutlet UILabel * L_num;
@property (nonatomic,strong) UITableView * TV_tableView;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) IBOutlet MKMapView * myMapView;
@property (nonatomic,strong) IBOutlet UILabel * L_storename;

@property (nonatomic,strong) IBOutlet UILabel * L_t1;
@property (nonatomic,strong) IBOutlet UILabel * L_t2;
@property (nonatomic,strong) IBOutlet UILabel * L_t3;

@property (nonatomic,strong) IBOutlet UILabel * L_likes;

-(void)addUI;
-(void)getData;
-(void)callIphone:(UITapGestureRecognizer *)aTap;
-(IBAction)commentClick:(UITapGestureRecognizer *)aTap;
-(IBAction)likesClick:(UITapGestureRecognizer *)aTap;
-(void)shareTap:(UITapGestureRecognizer *)aTap;
-(void)buttonClickForNuyNow;

////开始重新加载时调用的方法
- (void)reloadTableViewDataSource;
////完成加载时调用的方法
- (void)doneLoadingTableViewData;
//-(IBAction)slideMenu:(id)sender;
-(void)tapMapSafeWayClick:(UITapGestureRecognizer *)aTap;

@property (nonatomic,strong) IBOutlet UIView * allSignView;
@property (nonatomic,strong) IBOutlet UIImageView * IV_email;
@property (nonatomic,strong) IBOutlet UIImageView * IV_facebook;
@property (nonatomic,strong) IBOutlet UILabel * L_skip;
-(void)emailClick:(UITapGestureRecognizer *)aTap;
-(void)faceBookClick:(UITapGestureRecognizer *)aTap;
-(void)skipClick:(UITapGestureRecognizer *)aTap;
-(void)commentAddOne:(NSNotification *)aNotification;
-(void)likesAddOne;
-(void)likefollower:(UITapGestureRecognizer *)aTap;
@end

@implementation TrendDetailViewController
@synthesize myScrollView;
@synthesize middleView;
@synthesize IV_call;
@synthesize IV_collect;
@synthesize IV_comment;
@synthesize mapSmallView;
@synthesize L_street;
@synthesize L_down;
@synthesize L_contact;
@synthesize IV_contact;
@synthesize dic;
@synthesize L_num;
@synthesize TV_tableView;
@synthesize dataArr;
@synthesize myMapView;
@synthesize L_storename;
@synthesize IV_email,IV_facebook,L_skip,allSignView;
@synthesize likenumber,isClick;
@synthesize isSafeway;
@synthesize dic_recode;
@synthesize isFromTrendStore;
@synthesize viewController1;
@synthesize meRootController;
@synthesize dic_lab_number;
@synthesize isFromNotification,userId_notification;
@synthesize L_t1,L_t2,L_t3;
@synthesize isNotification;
@synthesize L_likes;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"TrendDetailViewController initWithNibName");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"TrendDetailViewController viewDidDisappear");
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"TrendDetailViewController viewWillAppear");
    if (self.isFromNotification)
    {
        self.dic = [NSMutableDictionary dictionaryWithCapacity:0];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ASIHTTPRequest * reqiest_detail = [WebService OfferDetail:self.userId_notification];
            [reqiest_detail startSynchronous];
            NSData * data_noti = [reqiest_detail responseData];
            NSString * strTemp = [[NSString alloc] initWithData:data_noti encoding:4];
            self.dic = [NSMutableDictionary dictionaryWithDictionary:[strTemp objectFromJSONString]];
            NSLog(@"strTemp = %@",strTemp);
            NSLog(@"self.dic = %@",self.dic);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addUI];
            });
        });
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        NSArray *permissions = [NSArray arrayWithObjects:@"email", @"publish_stream", @"user_about_me", @"publish_actions", nil];
        appDelegate.session = [[FBSession alloc] initWithPermissions:permissions];
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded)
        {
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                NSLog(@"TrendDetailViewController openWithCompletionHandler");
                //[self updateView];
            }];
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"commentAddOne" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentAddOne:) name:@"commentAddOne" object:nil];
    
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
    NSArray * arr = [l_comment_num.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];
    NSLog(@"TrendDetailViewController isSafeway %d", isSafeway);
    if (!isSafeway)
    {
        NSLog(@"TrendDetailViewController arr.count %d", arr.count);
        if (arr.count>0)
        {
            int num = [[arr objectAtIndex:1] intValue];
            NSLog(@"TrendDetailViewController num %d", num);
            if (num > 0)
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self getData];
                });
            }
        }
    }
    NSLog(@"TrendDetailViewController isFromTrendStore %d", isFromTrendStore);
    if (isFromTrendStore)
    {
        isFromTrendStore = NO;
        [self getData];
    }
}
-(void)likesAddOne
{
    NSLog(@"%s",__FUNCTION__);
    //if (![self.IV_collect.image isEqual:[UIImage imageNamed:@"liked.png"]])
    NSLog(@"self.isClick = %d",self.isClick);
    if (self.isClick == 2)
    {
        self.IV_collect.image = [UIImage imageNamed:@"liked.png"];
        // self.L_num.text = [NSString stringWithFormat:@"%d",self.likenumber];
        self.L_num.text = [NSString stringWithFormat:@"%@",[self.dic_lab_number valueForKey:[self.dic valueForKey:@"id"]]];
    }
    else
    {
        self.IV_collect.image = [UIImage imageNamed:@"like.png"];
        // self.L_num.text = [NSString stringWithFormat:@"%d",self.likenumber];
        NSLog(@"dic = %@",[self.dic_lab_number valueForKey:[self.dic valueForKey:@"id"]]);
        self.L_num.text = [NSString stringWithFormat:@"%@",[self.dic_lab_number valueForKey:[self.dic valueForKey:@"id"]]];
    }
}
-(void)commentAddOne:(NSNotification *)aNotification
{
    [self getData];
    
    NSArray * arr = [l_comment_num.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];
    NSLog(@"arr = %@",arr);
    int num = [[arr objectAtIndex:1] intValue];
    num++;
    l_comment_num.text = [NSString stringWithFormat:@"COMMENTS(%d)",num];
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
    //[self.allSignView removeFromSuperview];
    login.view.alpha = 0.0;
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
    
    lineDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    self.L_contact.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.L_down.font = [UIFont fontWithName:AllFont size:AllContentSize];;
    self.L_num.font = [UIFont fontWithName:AllFont size:AllContentSize];;
    self.L_storename.font = [UIFont fontWithName:AllFont size:AllContentSize];;
    self.L_street.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.L_t1.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.L_t2.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.L_t3.font = [UIFont fontWithName:AllFont size:AllContentSize];
    
    if ([WebService ISIOS7])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    [self.rightBtn addTarget:self action:@selector(ShareClick:) forControlEvents:UIControlEventTouchUpInside];
    if (_refreshTableView == nil)
    {
        //初始化下拉刷新控件
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.myScrollView.bounds.size.height, self.view.frame.size.width, self.myScrollView.bounds.size.height)];
        refreshView.delegate = self;
        //将下拉刷新控件作为子控件添加到UITableView中
        [self.myScrollView addSubview:refreshView];
        _refreshTableView = refreshView;
    }
    
    if (!isFromNotification)
    {
        [self addUI];
    }
    
    
    NSString * idStr = [self.dic valueForKey:@"id"];
    NSArray * arrKeys = [self.dic_recode allKeys];
    __block BOOL isHaveKey = NO;
    [arrKeys enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        if (obj != nil)
        {
            if ([idStr isEqualToString:obj])
            {
                isHaveKey = YES;
                *stop = YES;
            }
        }
    }];
    if (isHaveKey)
    {
        [self likesAddOne];
    }
    
}
-(void)ShareClick:(UIButton *)aButton
{
    
    NSString * linkStr = [NSString stringWithFormat:@"%@/offer/details/index.jsp.oo?offerId=%@",DO_MAIN,[self.dic valueForKey:@"id"]];
    NSString * contentStr = [NSString stringWithFormat:@"%@,%@,$%g,%@",[self.dic valueForKey:@"title"],[self.dic valueForKey:@"merchant"],[[self.dic valueForKey:@"price"] doubleValue],linkStr];
    
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
    //                                       delegate:self];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UM_APP_KEY
                                      shareText:[attribut string]
                                     shareImage:[UIImage imageWithData:data1]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToFacebook,UMShareToTwitter,nil]
                                       delegate:self];
}
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    if (platformName == UMShareToFacebook)
    {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToFacebook] content:socialData.commentText image:socialData.commentImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                // [MyAlert ShowAlertMessage:@"Success" title:@"Alert"];
            }
            else
            {
                // [MyAlert ShowAlertMessage:@"Share failed." title:@"Alert"];
            }
        }];
    }
    if (platformName == UMShareToTwitter)
    {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToTwitter] content:socialData.commentText image:socialData.commentImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                // [MyAlert ShowAlertMessage:@"Success" title:@"Alert"];
            }
            else
            {
                // [MyAlert ShowAlertMessage:@"Share failed." title:@"Alert"];
            }
        }];
    }
    //    if (platformName == UMShareToEmail)
    //    {
    //        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToEmail] content:socialData.commentText image:socialData.commentImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
    //            if (response.responseCode == UMSResponseCodeSuccess) {
    //                [MyAlert ShowAlertMessage:@"Success" title:@"Alert"];
    //            }
    //            else
    //            {
    //             [MyAlert ShowAlertMessage:@"Share failed." title:@"Alert"];
    //            }
    //        }];
    //    }
}
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    if (fromViewControllerType == UMSViewControllerShareList)
    {
        NSLog(@"odddddddddddddddd");
    }
}

-(void)getData
{
    NSString * isStr = [self.dic valueForKey:@"id"];
    __block ASIHTTPRequest * request = [WebService GeCommentsListByID:isStr];
    NSLog(@"start to get comments");
    [request setUseCookiePersistence:YES];
    [request buildRequestHeaders];
    NSMutableData * reciveData3 = [NSMutableData dataWithCapacity:0];
    [MyActivceView startAnimatedInView:self.view];
    [request setDataReceivedBlock:^(NSData *data) {
        [reciveData3 appendData:data];
    }];
    [request setCompletionBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        if (request.responseStatusCode == 200)
        {
            self.dataArr = [[reciveData3 objectFromJSONData] valueForKey:@"items"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.TV_tableView reloadData];
            });
        }
        else
        {
        }
        request = nil;
    }];
    [request setFailedBlock:^{
        NSLog(@"getComment failed");
        [MyActivceView stopAnimatedInView:self.view];
    }];
    [request startAsynchronous];
}
-(void)getData2
{
    NSString * isStr = [self.dic valueForKey:@"id"];
    __block ASIHTTPRequest * request = [WebService GeCommentsListByID:isStr];
    [request setUseCookiePersistence:YES];
    [request buildRequestHeaders];
    [request startSynchronous];
    self.dataArr = [[[request responseData] objectFromJSONData] valueForKey:@"items"];
    NSString * sumbitName = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"submitter"]];
    //  NSLog(@"sumbitName = %@",sumbitName);
    if (![sumbitName isEqualToString:@"<null>"])
    {
        NSString * imageStr1 = [[self.dic valueForKey:@"submitter"] valueForKey:@"img"];
        [shareImg setImageWithURL:[NSURL URLWithString:imageStr1] placeholderImage:nil];
    }
    
    NSString * larImageStr = [self.dic valueForKey:@"largeImg"];
    ASIHTTPRequest * request_topimage = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:larImageStr]];
    [request_topimage setTimeOutSeconds:MAX_SECONDS_REQUEST];
    NSMutableData * reciveData1 = [NSMutableData dataWithCapacity:0];
    [request_topimage setDataReceivedBlock:^(NSData *data) {
        [reciveData1 appendData:data];
    }];
    [request_topimage setCompletionBlock:^{
        topImage.image = [UIImage imageWithData:reciveData1];
    }];
    [request_topimage startAsynchronous];
}
-(void)addUI
{
    self.l_navTitle.font = [UIFont fontWithName:AllFontBold size:All_h2_size];
    self.l_navTitle.text = [self.dic valueForKey:@"title"];
    [self.rightBtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    float height1 = [[self.dic valueForKey:@"height"] floatValue];
    float width1 = [[self.dic valueForKey:@"width"] floatValue];
    float tempHeigh = [UIScreen mainScreen].bounds.size.height/2;
    if (height1>tempHeigh)
    {
        if (width1 != 0 && height1 != 0)
        {
            weight = tempHeigh/height1*width1;
        }
        else
        {
            weight = 300;
        }
        height = tempHeigh;
    }
    else
    {
        if (width1 != 0 && height1 != 0)
        {
            height = 300.0/width1*height1;
        }
        else
        {
            height = 10;
        }
        
        weight = 300;
    }
    
    self.myScrollView.contentSize = CGSizeMake(320, height+820);
    topImage = [[UIImageView alloc] initWithFrame:CGRectMake((320.0-weight)/2.0,5,weight,height)];
    topImage.clipsToBounds = YES;
    NSString * larImageStr = [self.dic valueForKey:@"largeImg"];
    [topImage setImageWithURL:[NSURL URLWithString:larImageStr] placeholderImage:nil];
    [self.myScrollView addSubview:topImage];
    
    MSLabel * desc = [[MSLabel alloc] initWithFrame:CGRectMake(15, height+20, 290, 52)];
    desc.text = [self.dic valueForKey:@"title"];
    desc.backgroundColor = [UIColor whiteColor];
    desc.numberOfLines = 0;
    desc.lineHeight = 22;
    desc.font = [UIFont fontWithName:AllFont size:All_h2_size];
    [self.myScrollView addSubview:desc];
    
    UITextField * textfieldTime = [[UITextField alloc] initWithFrame:CGRectMake(60, height+63, 200, 30)];
    textfieldTime.textAlignment = NSTextAlignmentCenter;
    textfieldTime.font = [UIFont fontWithName:AllFont size:AllContentSize];
    textfieldTime.userInteractionEnabled = NO;
    textfieldTime.layer.borderColor = [UIColor colorWithRed:196.0/255.0 green:196.0/255.0 blue:196.0/255.0 alpha:1.0].CGColor;
    textfieldTime.layer.borderWidth = 1;
    NSDateFormatter  * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:([[dic valueForKey:@"end"] floatValue]/1000)];
    NSString * dateStr = [formatter stringFromDate:date];
    textfieldTime.text = [NSString stringWithFormat:@"Ends %@",dateStr];
    textfieldTime.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textfieldTime.textColor = [UIColor colorWithRed:196.0/255.0 green:196.0/255.0 blue:196.0/255.0 alpha:1.0];
    [self.myScrollView addSubview:textfieldTime];
    
    
    //add buy now
    NSArray * dicKeys = [self.dic allKeys];
    __block BOOL isHaveUrl = NO;
    [dicKeys enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:@"url"])
        {
            isHaveUrl = YES;
            *stop = YES;
        }
        else
        {
            isHaveUrl = NO;
        }
    }];
    UIButton * buttonBuy = [UIButton buttonWithType:UIButtonTypeCustom];
    if (isHaveUrl)
    {
        
        buttonBuy.backgroundColor = [UIColor redColor];
        buttonBuy.layer.cornerRadius = 5;
        buttonBuy.frame = CGRectMake(210, 5, 90, 39);
        [buttonBuy setImage:[UIImage imageNamed:@"btn_shop.png"] forState:UIControlStateNormal];
        [buttonBuy addTarget:self action:@selector(buttonClickForNuyNow) forControlEvents:UIControlEventTouchUpInside];
        // [self.myScrollView addSubview:buttonBuy];
        
        height = height+30;
    }
    else
    {
        // UIButton * buttonBuy = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonBuy.backgroundColor = [UIColor redColor];
        buttonBuy.layer.cornerRadius = 5;
        buttonBuy.frame = CGRectMake(210, height+160, 90, 39);
        [buttonBuy setImage:[UIImage imageNamed:@"btn_call.png"] forState:UIControlStateNormal];
        [buttonBuy addTarget:self action:@selector(callIphone1) forControlEvents:UIControlEventTouchUpInside];
        //  [self.myScrollView addSubview:buttonBuy];
        
        height = height+30;
        
    }
    
    
    
    //    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, height+110, 320, 1)];
    //    line1.backgroundColor = [UIColor colorWithRed:195.0/255.0 green:195.0/255.0 blue:195.0/255.0 alpha:1.0];
    //    [self.myScrollView addSubview:line1];
    
    shareImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, height+70, 40, 40)];
    shareImg.layer.borderColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0].CGColor;
    shareImg.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    shareImg.layer.cornerRadius = 20;
    shareImg.clipsToBounds = YES;
    UITapGestureRecognizer * tapShare = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareTap:)];
    shareImg.userInteractionEnabled = YES;
    [self.myScrollView addSubview:shareImg];
    
    UILabel * sharetitleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, height+70, 150, 20)];
    sharetitleLab.font = [UIFont fontWithName:AllFont size:AllContentSmallSize];
    sharetitleLab.text = @"Share by";
    sharetitleLab.backgroundColor = [UIColor clearColor];
    [self.myScrollView addSubview:sharetitleLab];
    
    UILabel * shareNameLab = [[UILabel alloc] initWithFrame:CGRectMake(60, height+90, 150, 20)];
    shareNameLab.font = [UIFont fontWithName:AllFont size:AllContentSize];
    
    NSString * sumbitName = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"submitter"]];
    NSLog(@"sumbitName = %@",sumbitName);
    
    if ([sumbitName isEqualToString:@"<null>"]||[sumbitName isEqualToString:@"(null)"])
    {
        shareNameLab.text = @"Onsale Local";
        shareImg.image = [UIImage imageNamed:@"avatar_80x80.png"];
    }
    else
    {
        [shareImg addGestureRecognizer:tapShare];
        shareNameLab.text = [[self.dic valueForKey:@"submitter"] valueForKey:@"firstName"];
        NSString * imageStr1 = [[self.dic valueForKey:@"submitter"] valueForKey:@"img"];
        [shareImg setImageWithURL:[NSURL URLWithString:imageStr1] placeholderImage:[UIImage imageNamed:@"avatar_80x80.png"]];
    }
    shareNameLab.textColor = [UIColor colorWithRed:112.0/255.0 green:146.0/255.0 blue:190/255.0 alpha:1.0];
    shareNameLab.backgroundColor = [UIColor clearColor];
    [self.myScrollView addSubview:shareNameLab];
    
    shareCheck = [[UIImageView alloc] initWithFrame:CGRectMake(280, height+128.5, 23, 23)];
    shareCheck.layer.borderWidth = 1;
    shareCheck.layer.borderColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0].CGColor;
    NSArray * arrKeys = [dic allKeys];
    isSumbit = NO;
    [arrKeys enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:@"submitter"])
        {
            isSumbit = YES;
            *stop = YES;
        }
    }];
    
    
    if (isSumbit)
    {
        NSString * currLogin = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_ID]];
        if ([currLogin isEqualToString:[[self.dic valueForKey:@"submitter"] valueForKey:@"id"]])
        {
            shareCheck.alpha = 0.0;
        }
        else
        {
            NSString * str = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"submitter"] valueForKey:@"myFollowing"]];
            if ([str isEqualToString:@"1"])
            {
                [shareCheck setImage:[UIImage imageNamed:@"followed.png"]];
            }
            else
            {
                [shareCheck setImage:[UIImage imageNamed:@"follow.png"]];
            }
            shareCheck.userInteractionEnabled = YES;
            UITapGestureRecognizer * tapCheck = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likefollower:)];
            [shareCheck addGestureRecognizer:tapCheck];
        }
        
    }
    else
    {
        shareCheck.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapCheck = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likefollower:)];
        [shareCheck addGestureRecognizer:tapCheck];
        [shareCheck setImage:[UIImage imageNamed:@"follow.png"]];
    }
    
    if ([sumbitName isEqualToString:@"<null>"]||[sumbitName isEqualToString:@"(null)"])
    {
        shareCheck.alpha = 0.0;
    }
    else
    {
        shareCheck.alpha = 1.0;
    }
    
    shareCheck.layer.cornerRadius = 11.5;
    [self.myScrollView addSubview:shareCheck];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, height+120, 320, 1)];
    line2.backgroundColor = [UIColor colorWithRed:195.0/255.0 green:195.0/255.0 blue:195.0/255.0 alpha:1.0];
    [self.myScrollView addSubview:line2];
    
    self.middleView.frame = CGRectMake(0, height+130, 320, 49);
    [self.myScrollView addSubview:self.middleView];
    
    [self.middleView addSubview:buttonBuy];
    
    height= height-60;
    
    self.L_num.text = [NSString stringWithFormat:@"%@",[[self.dic valueForKey:@"likes"] stringValue]];
    self.L_likes.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.L_num.font = [UIFont fontWithName:AllFont size:AllContentSize];
    
    UIView * storeView = [[UIView alloc] initWithFrame:CGRectMake(0, height+250, 320, 40)];
    storeView.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 25)];
    lab.text = @"STORE";
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor colorWithRed:178.0/255.0 green:0 blue:0 alpha:1.0];
    lab.font = [UIFont fontWithName:AllFont size:AllContentSize];
    [storeView addSubview:lab];
    [self.myScrollView addSubview:storeView];
    
    UIView * bgViewmap = [[UIView alloc] initWithFrame:CGRectMake(0, height+290, 320, 560)];
    bgViewmap.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
    [self.myScrollView addSubview:bgViewmap];
    
    self.mapSmallView.frame = CGRectMake(5, 0, 310, 120);
    self.L_storename.text = [self.dic valueForKey:@"merchant"];
    self.L_storename.font = [UIFont fontWithName:AllFont size:AllFontSize];
    //dddd
    UITapGestureRecognizer * atap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMapSafeWayClick:)];
    [self.mapSmallView addGestureRecognizer:atap];
    [bgViewmap addSubview:self.mapSmallView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callIphone:)];
    self.IV_call.userInteractionEnabled = YES;
    [self.IV_call addGestureRecognizer:tap];
    
    NSString * iphoneStr = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"phone"]];
    if ([iphoneStr isEqualToString:@"(null)"]||[iphoneStr isEqualToString:@"<null>"])
    {
        iphoneStr = @"";
    }
    NSString * merStr = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"merchant"]];
    if ([[self.dic valueForKey:@"merchant"] isEqualToString:@"(null)"])
    {
        merStr = @"";
    }
    NSString * adressStr = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"address"]];
    if ([adressStr isEqualToString:@"(null)"])
    {
        adressStr = @"";
    }
    self.L_contact.text = [NSString stringWithFormat:@"%@",iphoneStr];
    self.L_contact.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.L_down.text = [NSString stringWithFormat:@"%@",merStr];
    self.L_down.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.L_street.text = [NSString stringWithFormat:@"%@",adressStr];
    self.L_street.font = [UIFont fontWithName:AllFont size:AllContentSize];
    //    self.IV_contact.layer.borderWidth = 1;
    //    self.IV_contact.layer.borderColor = [UIColor grayColor].CGColor;
    
    NSString * strRes = [NSString stringWithFormat:@"%@",[dic valueForKey:@"liked"]];
    if ([strRes intValue] == 0)
    {
        self.IV_collect.image = [UIImage imageNamed:@"like.png"];
        self.L_likes.text = @"Like";
    }
    else
    {
        self.IV_collect.image = [UIImage imageNamed:@"liked.png"];
        self.L_likes.text = @"Liked";
    }
    
    
    CLLocationCoordinate2D location1;
    location1.latitude = [[self.dic valueForKey:@"latitude"] floatValue];
    location1.longitude = [[self.dic valueForKey:@"longitude"] floatValue];
    MKCoordinateRegion region;
    region.center = location1;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.007;
    span.longitudeDelta = 0.007;
    region.center = location1;
    region.span = span;
    [self.myMapView setRegion:region animated:YES];
    MKAnnotation * annotation1 = [[MKAnnotation alloc] initWithCoords:location1];
    self.myMapView.userInteractionEnabled = NO;
    [self.myMapView addAnnotation:annotation1];
    
    
    l_comment_num = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, 200, 30)];
    l_comment_num.text = [NSString stringWithFormat:@"COMMENTS(%@)",[[self.dic valueForKey:@"comments"] stringValue]];
    l_comment_num.textColor = [UIColor colorWithRed:178.0/255.0 green:0 blue:0 alpha:1.0];
    l_comment_num.font = [UIFont fontWithName:AllFont size:AllContentSize];
    l_comment_num.backgroundColor = [UIColor clearColor];
    [bgViewmap addSubview:l_comment_num];
    
    UIButton * buttonCommbit = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonCommbit addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
    buttonCommbit.frame = CGRectMake(5, 160, 310, 34);
    buttonCommbit.layer.borderWidth = 1;
    buttonCommbit.layer.borderColor = [UIColor colorWithRed:196.0/233.0 green:196.0/233.0 blue:196.0/233.0 alpha:1.0].CGColor;
    buttonCommbit.backgroundColor = [UIColor whiteColor];
    buttonCommbit.layer.cornerRadius = 4;
    [bgViewmap addSubview:buttonCommbit];
    
    
    UITableView * tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, 340, 360)];
    tableView1.backgroundColor = [UIColor colorWithRed:230.0/256.0 green:230.0/256.0  blue:230.0/256.0  alpha:1.0];
    self.TV_tableView = tableView1;
    tableView1.dataSource = self;
    tableView1.delegate = self;
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [bgViewmap addSubview:tableView1];
    
}
#pragma mark - buy now
-(void)buttonClickForNuyNow
{
    BuyNowViewController * buyNow;
    if (iPhone5)
    {
        buyNow = [[BuyNowViewController alloc] initWithNibName:@"BuyNowViewController" bundle:nil];
    }
    else
    {
        buyNow = [[BuyNowViewController alloc] initWithNibName:@"BuyNowViewController4" bundle:nil];
    }
    NSString * tempUrl = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"url"]];
    buyNow.buyUrl = tempUrl;
    [self.navigationController pushViewController:buyNow animated:YES];
}
//#warning mark - change to account info
-(void)shareTap:(UITapGestureRecognizer *)aTap
{
    MeRootViewController * me;
    if (iPhone5)
    {
        me = [[MeRootViewController alloc] initWithNibName:@"MeRootViewController" bundle:nil];
    }
    else
    {
        me = [[MeRootViewController alloc] initWithNibName:@"MeRootViewController4" bundle:nil];
    }
    me.userid = [[dic valueForKey:@"submitter"] valueForKey:@"id"];
    [self.navigationController pushViewController:me animated:YES];
}
-(void)tapMapSafeWayClick:(UITapGestureRecognizer *)aTap
{
    SafewayViewController * safe;
    if (iPhone5)
    {
        safe = [[SafewayViewController alloc] initWithNibName:@"SafewayViewController" bundle:nil];
    }
    else
    {
        safe = [[SafewayViewController alloc] initWithNibName:@"SafewayViewController4" bundle:nil];
    }
    safe.merchanName = [self.dic valueForKey:@"merchant"];
    safe.merchantId = [self.dic valueForKey:@"merchantId"];
    safe.trend = self;
    [self.navigationController pushViewController:safe animated:YES];
}
-(void)callIphone:(UITapGestureRecognizer *)aTap
{
    NSLog(@"iphone = %@",[NSString stringWithFormat:@"tel://%@",[self.dic valueForKey:@"phone"]]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[self.dic valueForKey:@"phone"]]]];
}
-(void)callIphone1
{
    NSLog(@"iphone = %@",[NSString stringWithFormat:@"tel://%@",[self.dic valueForKey:@"phone"]]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[self.dic valueForKey:@"phone"]]]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString * str = @"mark";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:230.0/256.0 green:230.0/256.0  blue:230.0/256.0  alpha:1.0];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 40, 40)];
    NSArray * allkeys = [[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"user"] allKeys];
    __block BOOL isHave = NO;
    [allkeys enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:@"img"])
        {
            isHave = YES;
            *stop = YES;
        }
    }];
    if (isHave)
    {
        
        NSURL * path_url = [NSURL URLWithString:[[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"user"] valueForKey:@"img"]];
        ASIHTTPRequest * request_image = [ASIHTTPRequest requestWithURL:path_url];
        NSMutableData * reciveImageData = [NSMutableData dataWithCapacity:0];
        [request_image setDataReceivedBlock:^(NSData *data) {
            [reciveImageData appendData:data];
        }];
        [request_image setCompletionBlock:^{
            imageView.image = [UIImage imageWithData:reciveImageData];
        }];
        [request_image startAsynchronous];
    }
    else
    {
        imageView.image = [UIImage imageNamed:@"avatar_80x80.png"];
    }
    
    imageView.backgroundColor = [UIColor grayColor];
    imageView.layer.cornerRadius = 20;
    imageView.clipsToBounds = YES;
    [cell addSubview:imageView];
    
    NSString * str2 = [NSString stringWithFormat:@"%@",[[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"user"] valueForKey:@"firstName"]];
    
    NSString * str1 = [NSString stringWithFormat:@"say %@",[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"content"]];
    NSString * result1 = [str2 stringByAppendingFormat:@" %@",str1];
    
    int countELine = (int)([str2 length]/(200.0/AllContentSize))+1;
    int AllLineHigh = countELine*20+10;
    if (AllLineHigh<50)
    {
        AllLineHigh = 50;
    }
    [lineDic setValue:[NSNumber numberWithInt:AllLineHigh] forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    CGSize labelsize = [result1 sizeWithFont:[UIFont fontWithName:AllFont size:AllContentSize] constrainedToSize:CGSizeMake(200, 2000) lineBreakMode:UILineBreakModeWordWrap];
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 230, labelsize.height)];
    lab.text = result1;
    lab.backgroundColor = [UIColor clearColor];
    lab.numberOfLines = 0;
    lab.font = [UIFont fontWithName:AllFont size:AllContentSize];
    [cell addSubview:lab];
    
    // add time
    NSDateFormatter  * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy   HH:mm"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:([[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"created"] floatValue]/1000)];
    NSString * dateStr = [formatter stringFromDate:date];
    UILabel * lab1 = [[UILabel alloc] initWithFrame:CGRectMake(65, labelsize.height+5, 230, 20)];
    lab1.text = dateStr;
    lab1.backgroundColor = [UIColor clearColor];
    lab1.numberOfLines = 0;
    lab1.font = [UIFont fontWithName:AllFont size:AllContentSmallSize];
    [cell addSubview:lab1];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"self,data = %@",self.dataArr);
    NSString * userid = [[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"user"] valueForKey:@"id"];
    if (userid.length>0 && ![userid isEqualToString:@"(null)"])
    {
        MeRootViewController * me;
        if (iPhone5)
        {
            me = [[MeRootViewController alloc] initWithNibName:@"MeRootViewController" bundle:nil];
        }
        else
        {
            me = [[MeRootViewController alloc] initWithNibName:@"MeRootViewController4" bundle:nil];
        }
        me.userid = userid;
        [self.navigationController pushViewController:me animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * str2 = [NSString stringWithFormat:@"%@",[[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"user"] valueForKey:@"firstName"]];
    NSString * str1 = [NSString stringWithFormat:@"say %@",[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"content"]];
    NSString * result1 = [str2 stringByAppendingFormat:@" %@",str1];
    
    
    CGSize labelsize = [result1 sizeWithFont:[UIFont fontWithName:AllFont size:AllContentSize] constrainedToSize:CGSizeMake(200, 2000) lineBreakMode:UILineBreakModeWordWrap];
    // int countELine = (int)([result1 length]/(200.0/AllContentSize))+1;
    int AllLineHigh = labelsize.height+10+20;
    if (AllLineHigh<50)
    {
        AllLineHigh = 50;
    }
    //    else
    //    {
    //        AllLineHigh = labelsize.height+10;
    //    }
    [lineDic setValue:[NSNumber numberWithInt:AllLineHigh] forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    
    
    NSLog(@"height = %f",[[lineDic valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]] floatValue]);
    return [[lineDic valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]] floatValue];
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
    [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myScrollView];
    [self.TV_tableView reloadData];
}
-(void)doInBackground
{
    if ([WebService isConnectionAvailable])
    {
        [self getData2];
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
-(IBAction)commentClick:(UITapGestureRecognizer *)aTap
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
    {
        CommentViewController * comment;
        if (iPhone5)
        {
            comment = [[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:nil];
        }
        else
        {
            comment = [[CommentViewController alloc] initWithNibName:@"CommentViewController4" bundle:nil];
        }
        comment.offerId = [self.dic valueForKey:@"id"];
        [self.navigationController pushViewController:comment animated:YES];
    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you want to login？" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alert.tag = 1080;
        [alert show];
    }
}

-(void)commentClick
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
    {
        CommentViewController * comment;
        if (iPhone5)
        {
            comment = [[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:nil];
        }
        else
        {
            comment = [[CommentViewController alloc] initWithNibName:@"CommentViewController4" bundle:nil];
        }
        comment.offerId = [self.dic valueForKey:@"id"];
        [self.navigationController pushViewController:comment animated:YES];
    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you want to login？" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alert.tag = 1080;
        [alert show];
    }
}


-(IBAction)likesClick:(UITapGestureRecognizer *)aTap
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
    {
        //        NSNotification * notification = [NSNotification notificationWithName:@"likeData" object:nil];
        //        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        UIImageView * imageView = (UIImageView *)[aTap view];
        currImageView = imageView;
        if ([imageView.image isEqual:[UIImage imageNamed:@"liked.png"]])
        {
            request_like = [WebService UnLikeOffer:[self.dic valueForKey:@"id"]];
            [self likeUnlike :self.dic :NO];
            [NSURLConnection connectionWithRequest:request_like delegate:nil];
        }
        else
        {
            request_like = [WebService LikeOffer:[self.dic valueForKey:@"id"]];
            [self likeUnlike :self.dic :YES];
            [NSURLConnection connectionWithRequest:request_like delegate:nil];
        }
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you want to login？" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Yes", nil];
        alert.tag = 1080;
        [alert show];
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


-(void)dataChangedNotificationCallback:(NSNotification *)noti
{
    [super dataChangedNotificationCallback:noti];
    NSDictionary *userInfo = noti.userInfo;
    NSNumber *liked = [userInfo objectForKey:@"liked"];
    if(liked) {
        NSString * likedOfferId = [[userInfo objectForKey:@"offer"] objectForKey:@"id"];
        [self changeOfferLikeState:likedOfferId liked:[liked boolValue]];
    }
}

- (void)changeOfferLikeState:(NSString *)likedOfferId liked:(BOOL)like
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dic];
    NSNumber *likes = [NSNumber numberWithInt:([[dict objectForKey:@"likes"] intValue] + (like ? 1 : -1))];
    [dict setValue:likes forKey:@"likes"];
    [dict setValue:[NSNumber numberWithBool:like] forKey:@"liked"];
    self.dic = dict;
    self.L_num.text = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"likes"]];
    if(like) {
        [self.IV_collect setImage:[UIImage imageNamed:@"liked.png"]];
        self.L_likes.text = @"Liked";
    }
    else {
        [self.IV_collect setImage:[UIImage imageNamed:@"like.png"]];
        self.L_likes.text = @"Like";
    }
}

//- (void) likeUnlike
//{
//    self.viewController1.isLoading = YES;
//    BOOL liked = NO;
//    if ([currImageView.image isEqual:[UIImage imageNamed:@"liked.png"]])
//    {
//        if (self.safewayController != nil)
//        {
//            self.safewayController.isLoading = YES;
//        }
//        if (self.meRootController != nil)
//        {
//            self.meRootController.isLoading = YES;
//        }
//        self.L_num.text = [NSString stringWithFormat:@"%d",[self.L_num.text intValue]-1];
//        [currImageView setImage:[UIImage imageNamed:@"like.png"]];
//        self.L_likes.text = @"Like";
//    }
//    else
//    {
//        if (self.safewayController != nil)
//        {
//            self.safewayController.isLoading = YES;
//        }
//        if (self.meRootController != nil)
//        {
//            self.meRootController.isLoading = YES;
//        }
//        
//        self.L_num.text = [NSString stringWithFormat:@"%d",[self.L_num.text intValue]+1];
//        [currImageView setImage:[UIImage imageNamed:@"liked.png"]];
//        self.L_likes.text = @"Liked";
//        liked = YES;
//    }
//    
//    NSNumber *num = [NSNumber numberWithBool:liked];
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:self.dic forKey:@"offer"];
//    [userInfo setValue:num forKey:@"liked"];
//    [[NSNotificationCenter defaultCenter] postNotificationName: @"dataChangedNotification" object:nil userInfo:userInfo];
//}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [MyActivceView stopAnimatedInView:self.view];
    NSLog(@"dic = %@",[[NSString alloc] initWithData:reciveData encoding:4]);
    if ([httpResponse statusCode] == 200)
    {
        if ([(NSMutableURLRequest *)[connection currentRequest] isEqual:request_fb])
        {
            NSDictionary * dic_fb = [reciveData objectFromJSONData];
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
        else if([(NSMutableURLRequest *)[connection currentRequest] isEqual:request_follow])
        {
            self.viewController1.isLoading = YES;
            if ([shareCheck.image isEqual:[UIImage imageNamed:@"followed.png"]])
            {
                [shareCheck setImage:[UIImage imageNamed:@"follow.png"]];
            }
            else
            {
                [shareCheck setImage:[UIImage imageNamed:@"followed.png"]];
            }
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1080)
    {
        if (buttonIndex == 1)
        {
            UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipClick:)];
            UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceBookClick:)];
            UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emailClick:)];
            self.IV_facebook.userInteractionEnabled = YES;
            self.IV_email.userInteractionEnabled = YES;
            self.L_skip.userInteractionEnabled = YES;
            [self.IV_email addGestureRecognizer:tap3];
            [self.IV_facebook addGestureRecognizer:tap2];
            [self.L_skip addGestureRecognizer:tap1];
            
            login.view.alpha = 1.0;
            // [self.view addSubview:self.allSignView];
        }
    }
    else if(alertView.tag == 1081)
    {
        if (buttonIndex == 1)
        {
            UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipClick:)];
            UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceBookClick:)];
            UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emailClick:)];
            self.IV_facebook.userInteractionEnabled = YES;
            self.IV_email.userInteractionEnabled = YES;
            self.L_skip.userInteractionEnabled = YES;
            [self.IV_email addGestureRecognizer:tap3];
            [self.IV_facebook addGestureRecognizer:tap2];
            [self.L_skip addGestureRecognizer:tap1];
            
            login.view.alpha = 1.0;
        }
    }
    else
    {
        if (buttonIndex == 1)
        {
            LoginViewController * login2;
            if (iPhone5)
            {
                login2 = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            }
            else
            {
                login2 = [[LoginViewController alloc] initWithNibName:@"LoginViewController4" bundle:nil];
            }
            login.isBack = YES;
            [self.navigationController pushViewController:login2 animated:YES];
        }
    }
}
-(void)likefollower:(UITapGestureRecognizer *)aTap
{
    if (isSumbit)
    {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
        {
            [MyActivceView startAnimatedInView2:self.view];
            NSString * userid = [[self.dic valueForKey:@"submitter"] valueForKey:@"id"];
            if ([shareCheck.image isEqual:[UIImage imageNamed:@"followed.png"]])
            {
                request_follow = [WebService UnLikeFollow:userid];
                [NSURLConnection connectionWithRequest:request_follow delegate:self];
            }
            else
            {
                request_follow = [WebService LikeFollow:userid];
                [NSURLConnection connectionWithRequest:request_follow delegate:self];
            }
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you want to login？" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Yes", nil];
            alert.tag = 1081;
            [alert show];
        }
    }
    else
    {
        ;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
