//
//  SetViewController.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-12.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "SetViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "ViewController.h"
#import "CategoriesViewController.h"
#import "ShareViewController.h"
#import "MeRootViewController.h"
#import "NotificationViewController.h"
#import "AccountSettingViewController.h"
#import "AboutViewController.h"
#import "ChangeLocationViewController.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "SearchViewController.h"
#import "UploadPictureViewController.h"
#import "LoginSelectedViewController.h"
#import "TKHttpRequest.h"


@interface SetViewController ()<UISearchBarDelegate,UIActionSheetDelegate>
{
    UIActionSheet * sheet;
    UIView * bgView1;
    UIView * topView;
    NSMutableArray * tempArr;
    __block int unread;
    NSMutableURLRequest* request_fb;
    
    NSMutableData * reciveData;
    NSHTTPURLResponse * httpResponse;
    NSMutableURLRequest * request_signout;
}

@property (nonatomic,strong) IBOutlet UIImageView * topImageView;
@property (nonatomic,strong) IBOutlet UITableView * TV_tableview;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) IBOutlet UIButton * Btn_login;
@property (nonatomic,strong) IBOutlet UIButton * Btn_register;
@property (nonatomic,strong) IBOutlet UIImageView * IV_noLogin_name;

@property (nonatomic,strong) IBOutlet UILabel * L_name;
@property (nonatomic,strong) IBOutlet UILabel * L_distance;
@property (nonatomic,strong) IBOutlet UIButton * Btn_signout;
@property (nonatomic,strong) NSMutableArray * image_arr;
-(IBAction)signInClick:(id)sender;
-(IBAction)registerClick:(id)sender;
-(void)searchTapclick:(UITapGestureRecognizer *)aTap;
-(IBAction)signoutClick:(id)sender;
- (void)updateView;
//(void)refreshView1;
@end

@implementation SetViewController
@synthesize dataArr;
@synthesize Btn_login;
@synthesize Btn_register;
@synthesize IV_login_name;
@synthesize IV_noLogin_name;
@synthesize L_distance;
@synthesize L_name;
@synthesize image_arr;
@synthesize Btn_signout;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
//-(void)refreshView1
//{
//    [self viewWillAppear:YES];
//}
-(void)viewWillAppear:(BOOL)animated
{
    //obver
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView1) name:@"refreshViewWill" object:nil];
    
    NSLog(@"%s",__FUNCTION__);
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.searchBar.text = @"";
    self.searchBar.backgroundColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
    //not login
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"0"])
    {
        self.dataArr = [NSMutableArray arrayWithObjects:@"Trend",@"Categories",@"Change Location",@"About", nil];
        self.IV_login_name.hidden = YES;
        self.L_distance.hidden = YES;
        self.L_name.hidden = YES;
        self.IV_noLogin_name.hidden = NO;
        self.Btn_signout.hidden = YES;
        self.Btn_login.hidden = NO;
        self.Btn_register.hidden = NO;
        self.image_arr = [NSMutableArray arrayWithObjects:@"home.png",@"categories.png",@"share1.png",@"change_location.png",@"about.png", nil];
    }
    else
    {
        self.dataArr = [NSMutableArray arrayWithObjects:@"Trend",@"Categories",@"Upload Deals",@"Me",@"Account Setting",@"Notification",@"Change Location",@"About", nil];
        self.Btn_login.hidden = YES;
        self.Btn_register.hidden = YES;
        self.Btn_signout.hidden = NO;
        if (iPhone5)
        {
            self.TV_tableview.frame = CGRectMake(0, 142, 218, 400);
        }
        else
        {
            self.TV_tableview.frame = CGRectMake(0, 133, 218, 310);
        }
        self.IV_noLogin_name.hidden = YES;
        self.IV_login_name.hidden = NO;
        self.L_distance.hidden = NO;
        self.L_name.hidden = NO;
        NSString * imageStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_IMAGE]];
        if ([imageStr isEqualToString:@"(null)"])
        {
            self.IV_login_name.image = [UIImage imageNamed:@"avatar_100x100_white.png"];
        }
        else
        {
            NSLog(@"imagestr = %@",imageStr);
           // [self.IV_login_name setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"avatar_100x100_white.png"]];
            __block NSData * tempData = nil;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageStr]];
                tempData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.IV_login_name.image = [UIImage imageWithData:tempData];
                });
            });
        }
        
        NSUserDefaults * user1 = [NSUserDefaults standardUserDefaults];
        NSString * nameStr = [NSString stringWithFormat:@"%@ %@",[user1 valueForKey:LOGIN_LAST_NAME],[user1 valueForKey:LOGIN_FIRST_NAME]];
        NSLog(@"nameStr = %@",nameStr);
        self.L_name.text = nameStr;
        //self.L_distance.text = @"0 Followers";
        self.image_arr = [NSMutableArray arrayWithObjects:@"home.png",@"categories.png",@"share1.png",@"me.png",@"settings.png",@"notification.png",@"change_location.png",@"about.png", nil];
    }
    unread = 0;
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getData];
        });
    }

    [self.TV_tableview reloadData];
    NSLog(@"self.dataArr = %@",self.dataArr);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.IV_login_name.layer.cornerRadius = 40;
    self.Btn_login.titleLabel.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.Btn_register.titleLabel.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.Btn_signout.titleLabel.font = [UIFont fontWithName:AllFont size:AllContentSize];
    
    //去searchBar背景
    //self.searchBar.sea = YES;
   
    if ([WebService ISIOS7])
    {
       // self.searchBar.tintColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
        NSLog(@"ddddddd5555d5d5d5d5d5d");
        self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        //self.searchBar.barTintColor = [UIColor whiteColor];
        self.searchBar.tintColor = [UIColor whiteColor];
    }
    else
    {
        for (UIView *subview in self.searchBar.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
                [subview removeFromSuperview];
                break;
            }
        }
    }
      // self.IV_login_name.backgroundColor = [UIColor whiteColor];
    
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

    
    UIView *view1 =[ [UIView alloc]init];
    view1.backgroundColor = [UIColor clearColor];
    [self.TV_tableview setTableFooterView:view1];
    
   }
-(IBAction)signoutClick:(id)sender
{
    [MyActivceView startAnimatedInView1:self.view];
    request_signout = [WebService SignOut];
    [NSURLConnection connectionWithRequest:request_signout delegate:self];
}
-(IBAction)signInClick:(id)sender
{
    LoginViewController * login;
    if (iPhone5)
    {
        login =[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    }
    else
    {
        login =[[LoginViewController alloc] initWithNibName:@"LoginViewController4" bundle:nil];
    }
    login.isEmail = YES;
    login.isFromSetting = YES;
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
    [controller showCenterPanelAnimated:YES];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [delegate.nav_Center pushViewController:login animated:YES];
  //  [self.navigationController pushViewController:login animated:YES];
}
-(IBAction)registerClick:(id)sender
{
  
    LoginViewController * login;
    if (iPhone5)
    {
        login =[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    }
    else
    {
        login =[[LoginViewController alloc] initWithNibName:@"LoginViewController4" bundle:nil];
    }
    //login.isEmail = YES;
    login.isFromSetting = YES;
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
   JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
    [controller showCenterPanelAnimated:YES];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [delegate.nav_Center pushViewController:login animated:YES];
}

#pragma mark - facebook sign up
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

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    reciveData = [NSMutableData dataWithCapacity:0];
    httpResponse = (NSHTTPURLResponse *)response;
    [MyActivceView startAnimatedInView:self.view];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [reciveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
     [MyActivceView stopAnimatedInView:self.view];
    if ([httpResponse statusCode] == 200)
    {
        if ([(NSMutableURLRequest *)[connection currentRequest] isEqual:request_signout])
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:LOGIN_STATUS];
            [self viewWillAppear:YES];

            AppDelegate * delegate = [UIApplication sharedApplication].delegate;
            JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
            UINavigationController* nav = (UINavigationController *)controller.centerPanel;
            NSArray * arr = [nav viewControllers];
            ViewController * viewController = (ViewController *)[arr objectAtIndex:0];
            [viewController viewDidLoad];
            
            //clear cookie
            NSString * url = [NSString stringWithFormat:@"%@/ws/user/login",DO_MAIN];
            [[NSURLCache sharedURLCache] removeCachedResponseForRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
            
            NSString* url1 = [NSString stringWithFormat:@"%@/ws/user/facebook-login",DO_MAIN];
            [[NSURLCache sharedURLCache] removeCachedResponseForRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url1]]];
        }
        else
        {
            NSDictionary * dic = [reciveData objectFromJSONData];
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            [user setValue:[dic valueForKey:@"birthYear"] forKey:LOGIN_BIRTHYEAR];
            [user setValue:[dic valueForKey:@"created"] forKey:LOGIN_CREATED];
            [user setValue:[dic valueForKey:@"firstName"] forKey:LOGIN_FIRST_NAME];
            [user setValue:[dic valueForKey:@"gender"] forKey:LOGIN_GENDER];
            [user setValue:[dic valueForKey:@"id"] forKey:LOGIN_ID];
            [user setValue:[dic valueForKey:@"lastName"] forKey:LOGIN_LAST_NAME];
            [user setValue:[dic valueForKey:@"login"] forKey:LOGIN_LOGIN];
            [user setValue:[dic valueForKey:@"noti"] forKey:LOGIN_NOTI];
            [user setValue:[dic valueForKey:@"password"] forKey:LOGIN_PASSWORD];
            [user setValue:[dic valueForKey:@"updated"] forKey:LOGIN_UPDATED];
            [user setValue:[dic valueForKey:@"zipcode"] forKey:LOGIN_ZIPCODE];
            [user setValue:[dic valueForKey:@"img"] forKey:LOGIN_IMAGE];
            [user setValue:[dic valueForKey:@"notifications"] forKey:LOGIN_NOTIFICATION];
            [user setValue:@"1" forKey:LOGIN_STATUS];
            [self viewWillAppear:YES];
        }
    }
    else
    {
        if ([(NSMutableURLRequest *)[connection currentRequest] isEqual:request_fb])
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:LOGIN_STATUS];
        }
       // [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData] title:@""];
    }
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [MyActivceView stopAnimatedInView:self.view];
    if ([(NSMutableURLRequest *)[connection currentRequest] isEqual:request_fb])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:LOGIN_STATUS];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString * mark = @"mark";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UILabel * title;
        if (iPhone5)
        {
            title = [[UILabel alloc] initWithFrame:CGRectMake(40, 7, 170, 30)];
        }
        else
        {
            title = [[UILabel alloc] initWithFrame:CGRectMake(40, 7, 170, 20)];
        }
        title.userInteractionEnabled = YES;
        title.font = [UIFont fontWithName:AllFont size:AllContentSize];
        title.textColor = [UIColor whiteColor];
        title.backgroundColor = [UIColor clearColor];
        title.text = [self.dataArr objectAtIndex:indexPath.row];
        [cell addSubview:title];
    }
    
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(10, 1, 20, 20)];
    cell.accessoryView = view2;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView * imageView1;
    if (iPhone5)
    {
        imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 20, 20)]; 
    }
    else
    {
       imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 20, 20)];
    }
   
    imageView1.backgroundColor = [UIColor whiteColor];
    imageView1.image = [UIImage imageNamed:[self.image_arr objectAtIndex:indexPath.row]];
    [cell addSubview:imageView1];
    if (self.dataArr.count == 8)
    {
        if (indexPath.row == 5)
        {
            UIImageView * bigBarge = [[UIImageView alloc] initWithFrame:CGRectMake(135, 1, 25, 25)];
            bigBarge.image = [UIImage imageNamed:@"notice.png"];
            [cell addSubview:bigBarge];
            
            UILabel * lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
            lable1.textColor = [UIColor whiteColor];
            lable1.textAlignment = NSTextAlignmentCenter;
            lable1.font = [UIFont fontWithName:AllFont size:AllContentSize];
            lable1.text = [NSString stringWithFormat:@"%d",unread];
            lable1.backgroundColor = [UIColor clearColor];
            [bigBarge addSubview:lable1];
            
            if (unread == 0)
            {
                bigBarge.alpha = 0.0;
                lable1.alpha = 0.0;
            }
            else
            {
             lable1.text = [NSString stringWithFormat:@"%d",unread];
            }
        }
    }
    cell.backgroundColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
    return cell;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    JASidePanelController * controller2 = (JASidePanelController *)delegate.viewController1;
    [controller2 setCenterPanelHidden:YES animated:YES duration:0.3];
    
    //加阴影
    bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, [UIScreen mainScreen].bounds.size.height)];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchTapclick:)];
    [bgView1 addGestureRecognizer:tap];
    bgView1.backgroundColor = [UIColor blackColor];
    bgView1.alpha = 0.92;
    [self.view addSubview:bgView1];
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    topView.backgroundColor = [UIColor colorWithRed:72 green:79 blue:92 alpha:1.0];
    
    self.searchBar.backgroundColor = [UIColor grayColor];
    self.searchBar.frame = CGRectMake(0, 0, 320, 44);
    self.searchBar.showsCancelButton = YES;
    [self.view insertSubview:topView belowSubview:self.searchBar];
    
    return YES;
}
-(void)searchTapclick:(UITapGestureRecognizer *)aTap
{
    self.searchBar.backgroundColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
    for (UIView *subview in self.searchBar.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;
        }
    }
    
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    JASidePanelController * controller2 = (JASidePanelController *)delegate.viewController1;
    [controller2 setCenterPanelHidden:NO animated:YES duration:0.3];
    self.searchBar.frame = CGRectMake(10, 4, 204, 44);
    self.searchBar.showsCancelButton = NO;
    [bgView1 removeFromSuperview];
    [topView removeFromSuperview];
    [self.searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
   
    searchBar.text = @"";
    if ([WebService ISIOS7])
    {
        self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    }
    else
    {
        
        for (UIView *subview in self.searchBar.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
                [subview removeFromSuperview];
                break;
            }
        }
    }
    self.searchBar.backgroundColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    JASidePanelController * controller2 = (JASidePanelController *)delegate.viewController1;
    [controller2 setCenterPanelHidden:NO animated:YES duration:0.3];
    self.searchBar.frame = CGRectMake(10, 4, 204, 44);
    self.searchBar.showsCancelButton = NO;
    self.searchBar.showsSearchResultsButton = NO;
    [bgView1 removeFromSuperview];
    [topView removeFromSuperview];
    [self.searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length>0)
    {
       // self.searchBar.showsCancelButton = NO;
        self.searchBar.showsSearchResultsButton = YES;
    }
    else
    {
        self.searchBar.showsSearchResultsButton = NO;
       // self.searchBar.showsCancelButton = YES;
    }
}
#pragma - mark search button event
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length>0)
    {
//        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
//        JASidePanelController * controller2 = (JASidePanelController *)delegate.viewController1;
//        [controller2 setCenterPanelHidden:NO animated:YES duration:0.3];
        self.searchBar.frame = CGRectMake(10, 4, 204, 44);
        self.searchBar.showsCancelButton = NO;
        [bgView1 removeFromSuperview];
        [topView removeFromSuperview];
        self.searchBar.showsSearchResultsButton = NO;
        [self.searchBar resignFirstResponder];
        
        SearchViewController * search;
        if (iPhone5)
        {
            search = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
        }
        else
        {
            search = [[SearchViewController alloc] initWithNibName:@"SearchViewController4" bundle:nil];
        }
        search.key = searchBar.text;
        
        
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
        JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
        [controller showCenterPanelAnimated:YES];
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [delegate.nav_Center pushViewController:search animated:YES];
        
      //  [self.navigationController pushViewController:search animated:YES];
    }
    else
    {
       // [MyAlert ShowAlertMessage:@"Please Fill Keyword." title:@""];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (iPhone5)
    {
        return 44;
    }
    return 35;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * title = [self.dataArr objectAtIndex:indexPath.row];
    if ([title isEqualToString:@"Trend"])
    {
        ViewController * trendController;
        if (iPhone5)
        {
            trendController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
        }
        else
        {
           trendController = [[ViewController alloc] initWithNibName:@"ViewController4" bundle:nil];
        }
        trendController.isFromeSetting = YES;
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
        JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
        [controller showCenterPanelAnimated:YES];
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [delegate.nav_Center pushViewController:trendController animated:YES];
    }
    if ([title isEqualToString:@"Categories"])
    {
        CategoriesViewController * categorise;
        if (iPhone5)
        {
            categorise = [[CategoriesViewController alloc] initWithNibName:@"CategoriesViewController" bundle:nil];
        }
        else
        {
            categorise = [[CategoriesViewController alloc] initWithNibName:@"CategoriesViewController4" bundle:nil];
        }
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
        JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
        [controller showCenterPanelAnimated:YES];
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [delegate.nav_Center pushViewController:categorise animated:YES];
    }
    if ([title isEqualToString:@"Share"])
    {
        ShareViewController * share;
        if (iPhone5)
        {
            share = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
        }
        else
        {
            share = [[ShareViewController alloc] initWithNibName:@"ShareViewController4" bundle:nil];
        }
        
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
        JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
        [controller showCenterPanelAnimated:YES];
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [delegate.nav_Center pushViewController:share animated:YES];
    }
    if ([title isEqualToString:@"Change Location"])
    {
        ChangeLocationViewController * changeLocation;
        if (iPhone5)
        {
            changeLocation = [[ChangeLocationViewController alloc] initWithNibName:@"ChangeLocationViewController" bundle:nil];
        }
        else
        {
            changeLocation = [[ChangeLocationViewController alloc] initWithNibName:@"ChangeLocationViewController4" bundle:nil];
        }
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
        JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
        [controller showCenterPanelAnimated:YES];
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [delegate.nav_Center pushViewController:changeLocation animated:YES];
    }
    if ([title isEqualToString:@"About"])
    {
        AboutViewController * about;
        if (iPhone5)
        {
            about = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
        }
        else
        {
            about = [[AboutViewController alloc] initWithNibName:@"AboutViewController4" bundle:nil];
        }
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
        JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
        [controller showCenterPanelAnimated:YES];
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [delegate.nav_Center pushViewController:about animated:YES];
    }
    if ([title isEqualToString:@"Account Setting"])
    {
        AccountSettingViewController * about;
        if (iPhone5)
        {
            about = [[AccountSettingViewController alloc] initWithNibName:@"AccountSettingViewController" bundle:nil];
        }
        else
        {
            about = [[AccountSettingViewController alloc] initWithNibName:@"AccountSettingViewController4" bundle:nil];
        }
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
        JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
        [controller showCenterPanelAnimated:YES];
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFromRight;
        about.setController = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [delegate.nav_Center pushViewController:about animated:YES];
    }
    if ([title isEqualToString:@"Notification"])
    {
        NotificationViewController * notification;
        if (iPhone5)
        {
            notification = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController" bundle:nil];
        }
        else
        {
            notification = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController4" bundle:nil];
        }
        notification.dataArr = tempArr;
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
        JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
        [controller showCenterPanelAnimated:YES];
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [delegate.nav_Center pushViewController:notification animated:YES];
    }
    if ([title isEqualToString:@"Me"])
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
        
        me.isFromSetting = YES;
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
        JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
        [controller showCenterPanelAnimated:YES];
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [delegate.nav_Center pushViewController:me animated:YES];
    }
    if ([title isEqualToString:@"Upload Deals"])
    {
        UploadPictureViewController * upload;
        if (iPhone5)
        {
            upload = [[UploadPictureViewController alloc] initWithNibName:@"UploadPictureViewController" bundle:nil];
        }
        else
        {
            upload = [[UploadPictureViewController alloc] initWithNibName:@"UploadPictureViewController4" bundle:nil];
        }
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
        JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
        [controller showCenterPanelAnimated:YES];
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [delegate.nav_Center pushViewController:upload animated:YES];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.searchBar resignFirstResponder];
}
-(void)getData
{
    NSString *formatStr = [NSString stringWithFormat:@"/ws/user/me?format=json"];
    NSString * url = [DO_MAIN stringByAppendingString:formatStr];
    __weak ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeOutSeconds:MAX_SECONDS_REQUEST];
    [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [ request setNumberOfTimesToRetryOnTimeout:3]; //set times when request fail
    [request setDownloadCache:[TKHttpRequest ShareMyCache]];
    [request setSecondsToCache:60*60*2];
    [request setUseCookiePersistence:YES];
    [request buildRequestHeaders];
    [request startAsynchronous];
    NSMutableData * reciveData2 = [NSMutableData dataWithCapacity:0];
    [request setDataReceivedBlock:^(NSData *data) {
        [reciveData2 appendData:data];
    }];
    [request setCompletionBlock:^{
        if ([request responseStatusCode] == 200)
        {
            NSDictionary * dic2 = [reciveData2 objectFromJSONData];
            NSLog(@"dic2 = %@",dic2);
            @try {
                NSString * formatStr = [NSString stringWithFormat:@"%@",[dic2 valueForKey:@"notifications"]];
                if (![formatStr isEqualToString:@"0"] || ![formatStr isEqualToString:@"(null)"])
                {
                    unread = [formatStr intValue];
                }
            }
            @catch (NSException *exception) {
                 unread = [[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_NOTIFICATION] intValue];
            }
            [self.TV_tableview reloadData];
        }
     
    }];
    
    [request setFailedBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        if ([request responseStatusCode] != 200)
        {
           // [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData] title:@""];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
