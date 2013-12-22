//
//  FollowsViewController.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-26.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "FollowsViewController.h"
#import "FollowsCell.h"
#import "TKHttpRequest.h"
#import "EGORefreshTableHeaderView.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SafewayViewController.h"
#import "MeRootViewController.h"
#import "LoginViewController.h"
#import "UIView+StringTag.h"


@interface FollowsViewController ()<EGORefreshTableHeaderDelegate,UIAlertViewDelegate>
{
    EGORefreshTableHeaderView *_refreshTableView;
    BOOL _reloading;
    
    NSMutableURLRequest* request_fb;
    NSMutableData * reciveData_fb;
    NSHTTPURLResponse * httpResponse;
    
    UIButton * tempButton;
    
    LoginViewController * login;
}
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;


@property (nonatomic,strong) IBOutlet UIView * allSignView;
@property (nonatomic,strong) IBOutlet UIImageView * IV_email;
@property (nonatomic,strong) IBOutlet UIImageView * IV_facebook;
@property (nonatomic,strong) IBOutlet UILabel * L_skip;

-(void)emailClick:(UITapGestureRecognizer *)aTap;
-(void)faceBookClick:(UITapGestureRecognizer *)aTap;
-(void)skipClick:(UITapGestureRecognizer *)aTap;
@end

@implementation FollowsViewController
@synthesize dataArr;
@synthesize storeId;
@synthesize myTableView;
@synthesize IV_email,IV_facebook,L_skip,allSignView;
@synthesize safeWay,currFollowings,isFollowing;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.l_navTitle.font = [UIFont fontWithName:AllFontBold size:All_h2_size];
    self.l_navTitle.text = [@"Followers" uppercaseString];
    self.myTableView.tableFooterView = [[UIView alloc] init];
    
    if ([WebService ISIOS7])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (_refreshTableView == nil)
    {
        //初始化下拉刷新控件
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.myTableView.bounds.size.height, self.view.frame.size.width, self.myTableView.bounds.size.height)];
        refreshView.delegate = self;
        //将下拉刷新控件作为子控件添加到UITableView中
        [self.myTableView addSubview:refreshView];
        _refreshTableView = refreshView;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getData];
    });
}
-(void)getData
{
    NSString * formatStr = [NSString stringWithFormat:@"/ws/v2/store/followers?storeId=%@&format=json",self.storeId];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [MyActivceView startAnimatedInView2:self.view];
        });
    }];
    [request setDataReceivedBlock:^(NSData *data) {
        [reciveData appendData:data];
    }];
    [request setCompletionBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        self.myTableView.alpha = 1.0;
        if ([request responseStatusCode] == 200)
        {
//            if (self.dataArr.count>0)
//            {
//                self.dataArr = Nil;
//                self.dataArr = [NSMutableArray arrayWithCapacity:0];
//            }
            self.dataArr = [NSMutableArray arrayWithArray:[[reciveData objectFromJSONData] valueForKey:@"items"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView reloadData];
            });
        }
        else
        {
            ;
        }
    }];
 
    [request setFailedBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        if ([request responseStatusCode] != 200)
        {
            ;
        }
    }];
    [request startAsynchronous];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    reciveData_fb = [NSMutableData dataWithCapacity:0];
    httpResponse = (NSHTTPURLResponse *)response;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [reciveData_fb appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([httpResponse statusCode] == 200)
    {
        if ([(NSMutableURLRequest *)[connection currentRequest] isEqual:request_fb])
        {
            NSDictionary * dic_fb = [reciveData_fb objectFromJSONData];
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
      //  [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData_fb] title:@""];
    }
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([(NSMutableURLRequest *)[connection currentRequest] isEqual:request_fb])
    {
        [UIView animateWithDuration:0.3 animations:^{
           login.view.alpha = 0.0;
        }];
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:LOGIN_STATUS];
    }
  //  [MyAlert ShowAlertMessage:@"Not to force the network" title:@""];
}

-(void)getdata1
{
    NSString * formatStr = [NSString stringWithFormat:@"/ws/v2/store/followers?storeId=%@&format=json",self.storeId];
    NSString * url = [DO_MAIN stringByAppendingString:formatStr];
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeOutSeconds:MAX_SECONDS_REQUEST];
    [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [ request setNumberOfTimesToRetryOnTimeout:3]; //set times when request fail
    [request setDownloadCache:[TKHttpRequest ShareMyCache]];
    [request setSecondsToCache:60*60*2];
    [request setUseCookiePersistence:YES];
    [request buildRequestHeaders];
    [request startSynchronous];
    self.dataArr = [[[request responseData] objectFromJSONData] valueForKey:@"items"];
    [self didFinishReciveData1];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * markStr = @"markCell";
    FollowsCell * cell = [tableView dequeueReusableCellWithIdentifier:markStr];
    if (cell == nil)
    {
        cell = [[FollowsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:markStr];
    }
    cell.stringTag = [[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"id"];
    cell.L_name.text = [NSString stringWithFormat:@"%@,%@",[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"firstName"],[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"lastName"]];
    NSString * codeZip = [NSString stringWithFormat:@"%@",[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"zipcode"]];
    if ([codeZip isEqualToString:@"(null)"])
    {
        codeZip = @"";
    }
    cell.L_homedown.text = codeZip;
    NSArray * allkeys = [[self.dataArr objectAtIndex:indexPath.row] allKeys];
    __block BOOL isContact = NO;
    [allkeys enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:@"img"])
        {
            isContact = YES;
            *stop = YES;
        }
    }];
    if (isContact)
    {
        [cell.IV_photo setImageWithURL:[NSURL URLWithString:[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"avatar_80x80.png"]];
        cell.IV_photo.userInteractionEnabled = YES;
        cell.IV_photo.clipsToBounds = YES;
        cell.IV_photo.tag = indexPath.row;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
        [cell.IV_photo addGestureRecognizer:tap];
    }
    else
    {
        cell.IV_photo.image = [UIImage imageNamed:@"avatar_80x80.png"];
        cell.IV_photo.userInteractionEnabled = YES;
        cell.IV_photo.clipsToBounds = YES;
        cell.IV_photo.tag = indexPath.row;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
        [cell.IV_photo addGestureRecognizer:tap];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSLog(@"myfoolower = %@",[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"myFollowing"]);
    if (![[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"myFollowing"] intValue] == 0)
    {
        [cell.Btn_follow setImage:[UIImage imageNamed:@"followed.png"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.Btn_follow setImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
    }
    NSString * currIdLogin = [NSString stringWithFormat:@"%@",[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"id"]];
    NSString * currID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_ID]];
    if ([currIdLogin isEqualToString:currID])
    {
        cell.Btn_follow.alpha = 0.0;
    }
    
    [cell.Btn_follow addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.Btn_follow.tag = indexPath.row;
    return cell;
}
-(void)photoClick:(UITapGestureRecognizer *)aTap
{
    UIImageView * imageView = (UIImageView *)[aTap view];
    NSDictionary * dic = [self.dataArr objectAtIndex:imageView.tag];
    NSString * userid = [dic valueForKey:@"id"];
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
- (void)reloadTableViewDataSource
{
    _reloading = YES;
    [NSThread detachNewThreadSelector:@selector(doInBackground) toTarget:self withObject:nil];
}
////完成加载时调用的方法
- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
   // [self.myTableView reloadData];
}
-(void)doInBackground
{
    if ([WebService isConnectionAvailable])
    {
        [self getData];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 4444)
    {
        if (buttonIndex == 1)
        {
            login.view.alpha = 1.0;
        }
    }
    else
    {
        if (buttonIndex == 1)
        {
            NSURLRequest * request2 = [WebService UnLikeFollow:[[self.dataArr objectAtIndex:tempButton.tag] valueForKey:@"id"]];
            NSURLResponse * response2 = [[NSURLResponse alloc] init];
            NSError * error2 = [[NSError alloc] init];
            [NSURLConnection sendSynchronousRequest:request2 returningResponse:&response2 error:&error2];
            NSHTTPURLResponse * httpResponse1 = (NSHTTPURLResponse *)response2;
            NSLog(@"status code = %d",httpResponse1.statusCode);
            if (httpResponse1.statusCode == 200)
            {
                [self getdata1];
                [tempButton setImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
                [self.myTableView reloadData];
                
                //meroot change number
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"refreshRoot" object:nil]];
                
                if (!self.isFollowing)
                {
                    self.currFollowings --;
                }
            }
            
        }
    }
}
-(void)buttonClick:(UIButton *)aButton
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
    {
        
        if ([aButton.imageView.image isEqual:[UIImage imageNamed:@"followed.png"]])
        {
            NSString *userId = [[self.dataArr objectAtIndex:aButton.tag] valueForKey:@"id"];
            [self followUnfollowUser:userId :NO :nil];
        }
        else
        {
            NSString *userId = [[self.dataArr objectAtIndex:aButton.tag] valueForKey:@"id"];
            [self followUnfollowUser:userId :YES :nil];
        }
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you want to login？" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Yes", nil];
        alert.tag = 4444;
        [alert show];
    }
   }
-(void)didFinishReciveData1
{
    NSLog(@"%s",__FUNCTION__);
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
        [self changeUserFollowState:userId followed:[followUser boolValue]];
    }
    
    NSNumber *followStore = [userInfo objectForKey:@"followStore"];
    if(followStore) {
        NSString * storeId = [userInfo objectForKey:@"storeId"];
    }
}

- (void)changeUserFollowState:(NSString *)userId followed:(BOOL)followed
{
    for(int i=0; i<[self.dataArr count]; i++) {
        NSDictionary *dic = [self.dataArr objectAtIndex:i];
        if([userId isEqualToString:[dic objectForKey:@"id"]]) {
            NSMutableDictionary *newdic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [newdic setObject:[NSNumber numberWithBool:followed] forKey:@"myFollowings"];
            [self changeNumer:newdic diff:(followed ? 1 : -1) forKey:@"followers"];
            [self.dataArr replaceObjectAtIndex:i withObject:newdic];
        }
        if([self isLoginUser:[dic objectForKey:@"id"]]) {
            NSMutableDictionary *newdic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [self changeNumer:newdic diff:(followed ? 1 : -1) forKey:@"followings"];
            [self.dataArr replaceObjectAtIndex:i withObject:newdic];
        }
    }
    
    FollowsCell *cell = [self searchTableView:self.myTableView forClass:[FollowsCell class] withStringTag:userId];
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
