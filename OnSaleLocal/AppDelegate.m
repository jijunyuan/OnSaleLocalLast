//
//  AppDelegate.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-11.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SetViewController.h"
#import "LocationManager.h"
#import "UMSocial.h"
#import "MeRootViewController.h"
#import "SafewayViewController.h"
#import "TrendDetailViewController.h"
#import "OnsaleLocalConstants.h"
#import "ASIFormDataRequest.h"

//376543752464584
@interface AppDelegate()<NSURLConnectionDelegate,UIAlertViewDelegate>
{
    NSMutableURLRequest * request_fb;
    NSMutableURLRequest * request_login;
    NSDictionary * dicNotification;
    BOOL isCurrNotification;
}
@end

@implementation AppDelegate
@synthesize viewController1;
@synthesize nav_all;
@synthesize session = _session;
@synthesize nav_Center,nav_Left;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([WebService ISIOS7])
    {
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
        self.window.clipsToBounds =YES;
        self.window.bounds =  CGRectMake(0,0,self.window.frame.size.width,self.window.frame.size.height-20);
        self.window.frame = CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height);
    }
    
    if ([WebService isConnectionAvailable])
    {
        self.viewController1 = [[JASidePanelController alloc] init];
        self.viewController1.shouldDelegateAutorotateToVisiblePanel = NO;
        [UMSocialData setAppKey:UM_APP_KEY];
        
        NSString * currStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:IS_CURR_LOCATION]];
        if ([currStr isEqualToString:@"0"])
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:IS_CURR_LOCATION];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:IS_CURR_LOCATION];
        }
        NSLog(@"IS_CURR_LOCATION = %@",[[NSUserDefaults standardUserDefaults] valueForKey:IS_CURR_LOCATION]);
        NSLog(@"launchOptions = %@",launchOptions);
        if ([launchOptions allKeys].count > 0)
        {
            dicNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
            if (dicNotification != nil)
            {
                if ([[dicNotification objectForKey:@"aps"] objectForKey:@"alert"]!=NULL)
                {
                    NSString * tStr = [NSString stringWithFormat:@"%@",[dicNotification valueForKey:@"t"]];
                    if ([tStr isEqualToString:@"0"])
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
                        me.userid = [dicNotification valueForKey:@"d"];
                        [self.nav_all pushViewController:me animated:YES];
                    }
                    if ([tStr isEqualToString:@"1"])
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
                        safe.isNotification =YES;
                        safe.merchantId = [dicNotification valueForKey:@"d"];
                        [self.nav_all pushViewController:safe animated:YES];
                    }
                    if ([tStr isEqualToString:@"2"]||[tStr isEqualToString:@"3"]||[tStr isEqualToString:@"4"]||[tStr isEqualToString:@"5"])
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
                        trend.isNotification = YES;
                        trend.isFromNotification = YES;
                        trend.userId_notification = [dicNotification valueForKey:@"d"];
                        [self.nav_all pushViewController:trend animated:YES];
                    }
                }
            }
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:LOGIN_STATUS])
        {
            NSLog(@"========status = %@",[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS]);
            
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
            {
                NSString * str = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_LOGIN]];
                if ([str isEqualToString:@"(null)"]||[str isEqualToString:@"<null>"])
                {
                    if (self.session.isOpen)
                    {
                        NSString* token = self.session.accessTokenData.accessToken;
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
                        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:LOGIN_STATUS];
                        NSString* url = [NSString stringWithFormat:@"%@/ws/user/facebook-login",DO_MAIN];
                        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                    }
                    
                }
                else
                {
                    request_login = [WebService LoginUserName:[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_LOGIN] password:[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_PASSWORD]];
                    [NSURLConnection connectionWithRequest:request_login delegate:self];
                }
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:LOGIN_STATUS];
                NSString * url = [NSString stringWithFormat:@"%@/ws/user/login",DO_MAIN];
                [[NSURLCache sharedURLCache] removeCachedResponseForRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
            }
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:LOGIN_STATUS];
        }
        [LocationManager instance];
        
        SetViewController * setController;
        if (iPhone5)
        {
            setController = [[SetViewController alloc] initWithNibName:@"SetViewController" bundle:nil];
        }
        else
        {
            setController = [[SetViewController alloc] initWithNibName:@"SetViewController4" bundle:nil];
        }
        self.viewController1.leftPanel = setController;
        
        ViewController * centerController;
        if (iPhone5)
        {
            centerController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
        }
        else
        {
            centerController = [[ViewController alloc] initWithNibName:@"ViewController4" bundle:nil];
        }
        UINavigationController * navCenter = [[UINavigationController alloc] initWithRootViewController:centerController];
        self.nav_Center = navCenter;
        navCenter.navigationBarHidden = YES;
        self.viewController1.centerPanel = navCenter;
        self.window.rootViewController = self.viewController1;
        
        //nitification
        //注册接收通知类型
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge| UIRemoteNotificationTypeSound| UIRemoteNotificationTypeAlert)];
        
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        
    }
    else
    {
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
       // [MyAlert ShowAlertMessage:@"No network connection." title:@"Alert"];
    }
    return YES;
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    NSString* strTemp = [[[[deviceToken description]
                           stringByReplacingOccurrencesOfString: @"<" withString: @""]
                          stringByReplacingOccurrencesOfString: @">" withString: @""]
                         stringByReplacingOccurrencesOfString: @" " withString: @""] ;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"deviceToken: %@======str = %@", deviceToken,strTemp);
        [[NSUserDefaults standardUserDefaults] setValue:strTemp forKey:DEVIVE_TOKEN];
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
        {
            application.applicationIconBadgeNumber = 1;
            [WebService RegisterNotification:strTemp];
        }
    });
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    application.applicationIconBadgeNumber -= 1;
    // NSLog(@”\napns -> didReceiveRemoteNotification,Receive Data:\n%@”, userInfo);
    [UIApplication sharedApplication].applicationIconBadgeNumber=application.applicationIconBadgeNumber-1;
    dicNotification = userInfo;
    isCurrNotification = YES;
    if ( application.applicationState == UIApplicationStateActive )
    {
        ;
    }
    else
    {
        if (dicNotification != nil)
        {
            if ([[dicNotification objectForKey:@"aps"] objectForKey:@"alert"]!=NULL)
            {
                NSString * tStr = [NSString stringWithFormat:@"%@",[dicNotification valueForKey:@"t"]];
                if ([tStr isEqualToString:@"0"])
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
                    me.userid = [dicNotification valueForKey:@"d"];
                    [self.nav_all pushViewController:me animated:YES];
                }
                if ([tStr isEqualToString:@"1"])
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
                    safe.isNotification = YES;
                    safe.merchantId = [dicNotification valueForKey:@"d"];
                    [self.nav_all pushViewController:safe animated:YES];
                }
                if ([tStr isEqualToString:@"2"]||[tStr isEqualToString:@"3"]||[tStr isEqualToString:@"4"]||[tStr isEqualToString:@"5"])
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
                    trend.isNotification =YES;
                    trend.isFromNotification = YES;
                    trend.userId_notification = [dicNotification valueForKey:@"d"];
                    [self.nav_all pushViewController:trend animated:YES];
                }
            }
            
        }
    }
}

//application:openURL:sourceApplication:annotation:
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if (isCurrNotification)
    {
        if (dicNotification != nil)
        {
            if ([[dicNotification objectForKey:@"aps"] objectForKey:@"alert"]!=NULL)
            {
                NSString * tStr = [NSString stringWithFormat:@"%@",[dicNotification valueForKey:@"t"]];
                if ([tStr isEqualToString:@"0"])
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
                    me.userid = [dicNotification valueForKey:@"d"];
                    [self.nav_all pushViewController:me animated:YES];
                }
                if ([tStr isEqualToString:@"1"])
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
                    safe.isNotification =YES;
                    safe.merchantId = [dicNotification valueForKey:@"d"];
                    [self.nav_all pushViewController:safe animated:YES];
                }
                if ([tStr isEqualToString:@"2"]||[tStr isEqualToString:@"3"]||[tStr isEqualToString:@"4"]||[tStr isEqualToString:@"5"])
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
                    trend.isNotification = YES;
                    trend.isFromNotification = YES;
                    trend.userId_notification = [dicNotification valueForKey:@"d"];
                    [self.nav_all pushViewController:trend animated:YES];
                }
            }
            
        }
        
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString * strTemp = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:DEVIVE_TOKEN]];
            if (strTemp.length>0)
            {
                [WebService RegisterNotification:strTemp];
            }
            
        });
        return [FBAppCall handleOpenURL:url
                      sourceApplication:sourceApplication
                            withSession:self.session];
    }

    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableURLRequest * request5 = [WebService MarkNotificationRead];
            NSData * data1 = [NSURLConnection sendSynchronousRequest:request5 returningResponse:nil error:nil];
            NSLog(@"data1 = %@",[[NSString alloc] initWithData:data1 encoding:4]);
        });
    }
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"get token fail: %@", error);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [user setValue:@"0" forKey:LOGIN_STATUS];
    // [MyAlert ShowAlertMessage:@"The server is temporarily unable to service your request due to maintenance downtime or capacity problems. Please try again later." title:@"Alert"];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    reciveData = [NSMutableData dataWithCapacity:0];
    response1 = (NSHTTPURLResponse *)response;
    
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    NSDictionary *fields = [HTTPResponse allHeaderFields];
    NSString *cookie = [fields valueForKey:@"Set-Cookie"]; // It is your cookie
    NSLog(@"fields = %@,cookie = %@",fields,cookie);
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [reciveData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([response1 statusCode] == 200)
    {
        if ([(NSMutableURLRequest *)[connection currentRequest] isEqual:request_fb])
        {
            NSDictionary * dic_fb = [reciveData objectFromJSONData];
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
            //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //                NSString * strTemp = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:DEVIVE_TOKEN]];
            //                if (strTemp.length>0)
            //                {
            //                    [WebService RegisterNotification:strTemp];
            //                }
            //
            //            });
        }
        else if ([(NSMutableURLRequest *)[connection currentRequest] isEqual:request_login])
        {
            NSDictionary * dic = [reciveData objectFromJSONData];
            NSLog(@"dic = %@",dic);
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
            //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //                NSString * strTemp = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:DEVIVE_TOKEN]];
            //                if (strTemp.length>0)
            //                {
            //                    [WebService RegisterNotification:strTemp];
            //                }
            //
            //            });
        }
        else
        {
            [user setValue:@"0" forKey:LOGIN_STATUS];
        }
    }
    else
    {
        [user setValue:@"0" forKey:LOGIN_STATUS];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber -= 1;
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //[FBSession.activeSession handleDidBecomeActive];
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //[FBSession.activeSession close];
    [self.session close];
}
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation
//{
//    // attempt to extract a token from the url
//
//}


@end
