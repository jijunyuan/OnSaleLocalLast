//
//  StoreMapViewController.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-26.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "StoreMapViewController.h"
#import <MapKit/MapKit.h>
#import "MKAnnotation.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UIButton+ClickEvent.h"

@interface StoreMapViewController ()
{
    NSMutableURLRequest* request_fb;
    NSMutableData * reciveData;
    NSHTTPURLResponse * httpResponse;
}
@property (nonatomic,strong) IBOutlet MKMapView * mapView;
-(void)rightButtonClick;

@property (nonatomic,strong) IBOutlet UIView * allSignView;
@property (nonatomic,strong) IBOutlet UIImageView * IV_email;
@property (nonatomic,strong) IBOutlet UIImageView * IV_facebook;
@property (nonatomic,strong) IBOutlet UILabel * L_skip;
-(void)emailClick:(UITapGestureRecognizer *)aTap;
-(void)faceBookClick:(UITapGestureRecognizer *)aTap;
-(void)skipClick:(UITapGestureRecognizer *)aTap;
@end

@implementation StoreMapViewController
@synthesize mapView;
@synthesize longt,lat,name;
@synthesize merchantId,dic;
@synthesize IV_email,IV_facebook,L_skip,allSignView;
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
    [self.allSignView removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.l_navTitle.font = [UIFont fontWithName:AllFontBold size:All_h2_size];
    self.l_navTitle.text = self.name;
    
    [self.rightBtn setTitle:@"+" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(rightButtonClick) forControlEvents:UIButtonClickEvent];

    if ([[[self.dic valueForKey:@"storeDetails"] valueForKey:@"following"] intValue] == 0)
    {
        [self.rightBtn setImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.rightBtn setImage:[UIImage imageNamed:@"followed.png"] forState:UIControlStateNormal];
    }
    
    CLLocationCoordinate2D location1;
    location1.latitude = lat;
    location1.longitude = longt;
    MKCoordinateRegion region;
    region.center = location1;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.007;
    span.longitudeDelta = 0.007;
    region.center = location1;
    region.span = span;
    [self.mapView setRegion:region animated:YES];
    MKAnnotation * annotation1 = [[MKAnnotation alloc] initWithCoords:location1];
    self.mapView.userInteractionEnabled = NO;
    [self.mapView addAnnotation:annotation1];
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
            NSLog(@"httpcode = %d",httpResponse1.statusCode);
            if (httpResponse1.statusCode == 200)
            {
                [self.rightBtn setImage:[UIImage imageNamed:@"followed.png"] forState:UIControlStateNormal];
            }
        }
        else
        {
//            NSURLRequest * request = [WebService UnLikeStore:self.merchantId];
//            NSURLResponse * response = [[NSURLResponse alloc] init];
//            NSError * error = [[NSError alloc] init];
//            [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//            NSHTTPURLResponse * httpResponse1 = (NSHTTPURLResponse *)response;
//            NSLog(@"httpcode = %d",httpResponse1.statusCode);
//            if (httpResponse1.statusCode == 200)
//            {
//                [self.rightBtn setImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
//            }
        }
        NSMutableDictionary * dic2 = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic2 setValue:self.rightBtn.imageView.image forKey:@"image"];
        NSNotification * notification = [NSNotification notificationWithName:@"change" object:nil userInfo:dic2];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    else
    {
       [self.view addSubview:self.allSignView];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
