//
//  LoginSelectedViewController.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-10-1.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "LoginSelectedViewController.h"
#import "LoginViewController.h"
#import "UMSocial.h"
#import "AppDelegate.h"
#import "CreatePasswordViewController.h"

@interface LoginSelectedViewController ()<NSURLConnectionDelegate>
{
    NSMutableData * reciveData;
    NSHTTPURLResponse * httpResponse;
}
-(IBAction)emailClick:(UITapGestureRecognizer *)aTap;
-(IBAction)faceBookClick:(UITapGestureRecognizer *)aTap;
@end

@implementation LoginSelectedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
}
-(void)emailClick:(UITapGestureRecognizer *)aTap
{
    NSLog(@"---%s",__FUNCTION__);
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
//        [appDelegate.session openWithBehavior:FBSessionLoginBehaviorForcingWebView completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//           // [self updateView];
//        }];

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
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:
                                  [cookieJar cookies]];
        [request setAllHTTPHeaderFields:headers];
        NSUUID* uuid = [[UIDevice currentDevice]identifierForVendor];
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        NSString* userID = [[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_LOGIN];
        NSString *header = [NSString stringWithFormat:@"ios;%@;%@;%@;%f;%f;%ld",[uuid UUIDString], version, userID,0.0, 0.0, (long)[[NSDate date]timeIntervalSince1970]];
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:_params options:kNilOptions error:&error];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody: jsonData];
        [request setValue:header forHTTPHeaderField:@"Reqid"];
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPShouldHandleCookies:YES];
        
        NSString *msgLength = [NSString stringWithFormat:@"%d", [jsonData length]];
        [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:LOGIN_STATUS];
    }
}
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error.localizedDescription);
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:LOGIN_STATUS];
}
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@", ((NSHTTPURLResponse*)response).allHeaderFields);
    reciveData = [NSMutableData dataWithCapacity:0];
    httpResponse = (NSHTTPURLResponse *)response;
}
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [reciveData appendData:data];
}
- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (httpResponse.statusCode == 200)
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
        createPWD.email = [user valueForKey:LOGIN_LOGIN];
        createPWD.zipcode = [user valueForKey:LOGIN_ZIPCODE];
        [self.navigationController pushViewController:createPWD animated:YES];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:LOGIN_STATUS];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
