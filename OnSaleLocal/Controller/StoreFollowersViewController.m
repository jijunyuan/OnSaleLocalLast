//
//  StoreFollowersViewController.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-29.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "StoreFollowersViewController.h"
#import "StoreFollowCell.h"
#import "TKHttpRequest.h"
#import "EGORefreshTableHeaderView.h"
#import "SafewayViewController.h"
#import "MeRootViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UIView+StringTag.h"


@interface StoreFollowersViewController ()<EGORefreshTableHeaderDelegate,UIAlertViewDelegate>
{
    EGORefreshTableHeaderView *_refreshTableView;
    BOOL _reloading;
    int tempTag;
    
    NSMutableURLRequest* request_fb;
    NSMutableData * reciveData1;
    NSHTTPURLResponse * httpResponse;
}
@property (nonatomic,strong) IBOutlet UITableView * TV_tableivew;
@property (nonatomic,strong) NSMutableArray * dataArr;

-(void)getData;
-(void)getData1;
-(void)unfollowed:(UIButton *)aButton;


@property (nonatomic,strong) IBOutlet UIView * allSignView;
@property (nonatomic,strong) IBOutlet UIImageView * IV_email;
@property (nonatomic,strong) IBOutlet UIImageView * IV_facebook;
@property (nonatomic,strong) IBOutlet UILabel * L_skip;
-(void)emailClick:(UITapGestureRecognizer *)aTap;
-(void)faceBookClick:(UITapGestureRecognizer *)aTap;
-(void)skipClick:(UITapGestureRecognizer *)aTap;

@end

@implementation StoreFollowersViewController
@synthesize dataArr;
@synthesize TV_tableivew;
@synthesize isLikes;
@synthesize meRootController;
@synthesize allSignView,IV_email,IV_facebook,L_skip;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)getData
{
    NSString * formatStr;
    if (isLikes)
    {
        formatStr = [NSString stringWithFormat:@"/ws/user/user-fav-offers?userId=%@&format=json",self.userid];
    }
    else
    {
        formatStr = [NSString stringWithFormat:@"/ws/user/user-fav-stores?userId=%@&format=json",self.userid];
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
        self.TV_tableivew.alpha = 0.0;
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
        [MyActivceView startAnimatedInView2:self.view];
    }];
    [request setDataReceivedBlock:^(NSData *data) {
        [reciveData appendData:data];
    }];
    __block BOOL isHaveKey = NO;
    [request setCompletionBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        NSLog(@"result = %@",[[NSString alloc] initWithData:reciveData encoding:4]);
        self.TV_tableivew.alpha = 1.0;
        if ([request responseStatusCode] == 200)
        {
            if (!isLikes)
            {
                self.dataArr = [NSMutableArray arrayWithArray:[[reciveData objectFromJSONData] valueForKey:@"items"]];
                NSLog(@"dataArr = %@",self.dataArr);
            }
            else
            {
                NSMutableArray * arr = [[reciveData objectFromJSONData] valueForKey:@"items"];
                [arr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
                    for (NSString * key in [obj allKeys])
                    {
                        if ([key isEqualToString:@"offer"])
                        {
                            isHaveKey = YES;
                        }
                    }
                    if (isHaveKey)
                    {
                        NSString * offer = [NSString stringWithFormat:@"%@",[obj valueForKey:@"offer"]];
                        if ((![offer isEqualToString:@"(null)"])&&(![offer isEqualToString:@"<null>"]))
                        {
                            [self.dataArr addObject:[obj valueForKey:@"offer"]];
                        }
                    }
                }];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
               [self.TV_tableivew reloadData];
            });
            
        }
        else
        {
           // [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData] title:@""];
        }
    }];
    
    [request setFailedBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        if ([request responseStatusCode] != 200)
        {
          //  [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData] title:@""];
        }
    }];
    [request startAsynchronous];
}
-(void)getData1
{
    NSString * formatStr;
    if (isLikes)
    {
        formatStr = [NSString stringWithFormat:@"/ws/user/user-fav-offers?userId=%@&format=json",self.userid];
    }
    else
    {
        formatStr = [NSString stringWithFormat:@"/ws/user/user-fav-stores?userId=%@&format=json",self.userid];
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
    [request startSynchronous];
    self.dataArr = nil;
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    if (!isLikes)
    {
        self.dataArr = [NSMutableArray arrayWithArray:[[[request responseData] objectFromJSONData] valueForKey:@"items"]];
    }
    else
    {
        __block BOOL isHaveKey = NO;
        NSMutableArray * arr = [[[request responseData] objectFromJSONData] valueForKey:@"items"];
        [arr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            for (NSString * key in [obj allKeys])
            {
                if ([key isEqualToString:@"offer"])
                {
                    isHaveKey = YES;
                }
            }
            if (isHaveKey)
            {
                [self.dataArr addObject:[obj valueForKey:@"offer"]];
            }
        }];
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
    {
        // [self.view addSubview:self.allSignView];
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
        [self.allSignView removeFromSuperview];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([WebService ISIOS7])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (isLikes)
    {
        self.l_navTitle.font = [UIFont fontWithName:AllFontBold size:All_h2_size];
    self.l_navTitle.text = [@"Likes" uppercaseString];
    }
    else
    {
        self.l_navTitle.font = [UIFont fontWithName:AllFontBold size:All_h2_size];
    self.l_navTitle.text = [@"Store Followed" uppercaseString];
    }
    
    self.TV_tableivew.tableFooterView = [[UIView alloc] init];
    
    if (_refreshTableView == nil)
    {
        //初始化下拉刷新控件
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.TV_tableivew.bounds.size.height, self.view.frame.size.width, self.TV_tableivew.bounds.size.height)];
        refreshView.delegate = self;
        //将下拉刷新控件作为子控件添加到UITableView中
        [self.TV_tableivew addSubview:refreshView];
        _refreshTableView = refreshView;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getData];
    });
}


-(void)emailClick:(UITapGestureRecognizer *)aTap
{
    LoginViewController * login;
    if (iPhone5)
    {
        login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    }
    else
    {
        login = [[LoginViewController alloc] initWithNibName:@"LoginViewController4" bundle:nil];
    }
    login.isBack = YES;
    [self.navigationController pushViewController:login animated:YES];
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
-(void)skipClick:(UITapGestureRecognizer *)aTap
{
    [self.allSignView removeFromSuperview];
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([httpResponse statusCode] == 200)
    {
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
        //[MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData1] title:@""];
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
   // [MyAlert ShowAlertMessage:@"Not to force the network" title:@""];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreFollowCell * cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil)
    {
        cell = [[StoreFollowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    NSDictionary * dic1 = [self.dataArr objectAtIndex:indexPath.row];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    
    CLLocationCoordinate2D location1;
    if (!isLikes)
    {
        location1.latitude = [[[dic1 valueForKey:@"store"] valueForKey:@"latitude"] floatValue];
        location1.longitude = [[[dic1 valueForKey:@"store"] valueForKey:@"longitude"] floatValue];
    }
    else
    {
        location1.latitude = [[dic1 valueForKey:@"latitude"] floatValue];
        location1.longitude = [[dic1 valueForKey:@"longitude"] floatValue];
    }
    MKCoordinateRegion region;
    region.center = location1;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.007;
    span.longitudeDelta = 0.007;
    region.center = location1;
    region.span = span;
    [cell.mapview setRegion:region animated:YES];
    cell.mapview.userInteractionEnabled = NO;
    
    NSString * tempStr1 = [NSString stringWithFormat:@"%@",[dic1 valueForKey:@"myFollowingStore"]];
    if ([tempStr1 isEqualToString:@"1"])
    {
     [cell.Btn_follow setImage:[UIImage imageNamed:@"followed.png"] forState:UIControlStateNormal];   
    }
    else
    {
      [cell.Btn_follow setImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
    }
    
    cell.IV_image.image = [UIImage imageNamed:@"call.png"];
    if (isLikes)
    {
        cell.L_phone.text = [dic1 valueForKey:@"phone"];
        cell.L_name.text = [dic1 valueForKey:@"merchant"];
        cell.L_homedown.text = [NSString stringWithFormat:@"%@,%@,%@",[dic1 valueForKey:@"address"],[dic1  valueForKey:@"city"],[dic1 valueForKey:@"state"]];
        cell.Btn_follow.stringTag = [dic1 valueForKey:@"id"];
        cell.stringTag = [dic1 valueForKey:@"id"];
    }
    else
    {
        cell.L_phone.text = [[dic1 valueForKey:@"store"] valueForKey:@"phone"];
        cell.L_name.text = [[dic1 valueForKey:@"store"] valueForKey:@"name"];
        cell.L_homedown.text = [NSString stringWithFormat:@"%@,%@,%@",[[dic1 valueForKey:@"store"] valueForKey:@"address"],[[dic1 valueForKey:@"store"] valueForKey:@"city"],[[dic1 valueForKey:@"store"] valueForKey:@"state"]];
        [cell.Btn_follow addTarget:self action:@selector(unfollowed:) forControlEvents:UIControlEventTouchUpInside];
        cell.Btn_follow.tag = indexPath.row;
        cell.Btn_follow.stringTag = [[dic1 valueForKey:@"store"] valueForKey:@"id"];
        cell.stringTag = [[dic1 valueForKey:@"store"] valueForKey:@"id"];
    }
    return cell;
}
-(void)unfollowed:(UIButton *)aButton
{
    tempTag = aButton.tag;
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
    {
        if ([aButton.imageView.image isEqual:[UIImage imageNamed:@"followed.png"]])
        {
            [self followUnfollowStore:aButton.stringTag :NO :nil];
        }
        else
        {
            [self followUnfollowStore:aButton.stringTag :YES :nil];
        }

    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you want to login？" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Yes", nil];
        alert.tag = 8888;
        [alert show];
       
    }
      
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (alertView.tag == 8888)
        {
            [self.view addSubview:self.allSignView];
        }
        if (alertView.tag == 9999)
        {
            NSDictionary * dic4 = [self.dataArr objectAtIndex:tempTag];
            NSURLRequest * request = [WebService UnLikeStore:[dic4 valueForKey:@"id"]];
            NSURLResponse * response = [[NSURLResponse alloc] init];
            NSError * error = [[NSError alloc] init];
            [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            NSHTTPURLResponse * httpResponse1 = (NSHTTPURLResponse *)response;
            NSLog(@"httpcode = %d",httpResponse1.statusCode);
            if (httpResponse1.statusCode == 200)
            {
                [self getData];
            }
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
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
    [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:self.TV_tableivew];
    [self.TV_tableivew reloadData];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic1 = [self.dataArr objectAtIndex:indexPath.row];
    SafewayViewController * safe;
    if (iPhone5)
    {
        safe = [[SafewayViewController alloc] initWithNibName:@"SafewayViewController" bundle:nil];
    }
    else
    {
        safe = [[SafewayViewController alloc] initWithNibName:@"SafewayViewController4" bundle:nil];
    }
    safe.merchanName = [[dic1 valueForKey:@"store"] valueForKey:@"name"];
    safe.merchantId = [[dic1 valueForKey:@"store"] valueForKey:@"id"];
  //  safe.trend = self;
    [self.navigationController pushViewController:safe animated:YES];
}
-(void)backClick:(UIButton *)aButton
{
    self.meRootController.storefollowsNum = [NSString stringWithFormat:@"%d store followed",self.dataArr.count];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dataChangedNotificationCallback:(NSNotification *)noti
{
    [super dataChangedNotificationCallback:noti];
    NSDictionary *userInfo = noti.userInfo;
    NSNumber *liked = [userInfo objectForKey:@"liked"];
    if(liked) {
        NSString * likedOfferId = [userInfo objectForKey:@"offerId"];
    }
    
    NSNumber *followUser = [userInfo objectForKey:@"followUser"];
    if(followUser) {
        NSString * userId = [userInfo objectForKey:@"userId"];
    }
    
    NSNumber *followStore = [userInfo objectForKey:@"followStore"];
    if(followStore) {
        NSString * storeId = [userInfo objectForKey:@"storeId"];
        [self changeStoreFollowState:storeId followed:[followStore boolValue]];
    }
}

- (void)changeStoreFollowState:(NSString *)storeId followed:(BOOL)followed
{
    for(int i=0; i<[self.dataArr count]; i++) {
        if([[[self.dataArr objectAtIndex:i] objectForKey:@"id"] isEqualToString:storeId]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.dataArr objectAtIndex:i]];
            [self setBool:dic value:followed forKey:@"myFollowingStore"];
            [self.dataArr replaceObjectAtIndex:i withObject:dic];
            break;
        }
    }
    StoreFollowCell *cell = [self searchTableView:self.TV_tableivew forClass:[StoreFollowCell class] withStringTag:storeId];
    if(cell) {
        if(followed) {
            [cell.Btn_follow setImage:[UIImage imageNamed:@"followed.png"] forState:UIControlStateNormal];
        }
        else {
            [cell.Btn_follow setImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
        }
    }
}


@end
