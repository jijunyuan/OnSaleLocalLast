//
//  LoginViewController.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-16.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "JASidePanelController.h"
#import "ForgetPwdViewController.h"
#import "AppDelegate.h"
#import "CreatePasswordViewController.h"
#import "SetViewController.h"
#import "ViewController.h"

@interface LoginViewController ()<NSURLConnectionDelegate,UIAlertViewDelegate>
{
    NSMutableData * reciveData;
    NSHTTPURLResponse * response1;
    NSMutableURLRequest* request_fb;
}
@property (nonatomic,strong) IBOutlet UITextField * TF_email;
@property (nonatomic,strong) IBOutlet UITextField * TF_pwssword;
@property (nonatomic,strong) IBOutlet UIView * bgView;
@property (nonatomic,strong) IBOutlet UIButton * Btn_cancle;
@property (nonatomic,strong) IBOutlet UIButton * Btn_login;
@property (nonatomic,strong) IBOutlet UILabel * L_forget;
@property (nonatomic,strong) IBOutlet UILabel * L_signin;
@property (nonatomic,strong) IBOutlet UILabel * L_forgetPWd;
@property (nonatomic,strong) IBOutlet UIButton * btn_right1;

//-(IBAction)cancleClick:(id)sender;
-(IBAction)signInClick:(id)sender;
-(void)tapForgetPwdClick:(UITapGestureRecognizer *)aTap;
-(IBAction)facebookLoginIn:(UITapGestureRecognizer *)sender;
@end

@implementation LoginViewController
@synthesize TF_email;
@synthesize TF_pwssword;
@synthesize bgView;
@synthesize Btn_cancle;
@synthesize Btn_login;
@synthesize L_forget;
@synthesize isEmail;
@synthesize isFromSetting;
@synthesize isQukyLogin;
@synthesize L_forgetPWd,L_signin;
@synthesize btn_right1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)facebookLoginIn:(UITapGestureRecognizer *)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //    if (appDelegate.session.isOpen)
    //    {
    //        //[appDelegate.session closeAndClearTokenInformation];
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
    //   }
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bgView.layer.cornerRadius = 5;
    self.Btn_login.layer.cornerRadius =5;
    self.Btn_cancle.layer.cornerRadius = 5;
    self.TF_pwssword.secureTextEntry = YES;
    self.L_forget.userInteractionEnabled = YES;
    
    self.L_forget.font = [UIFont fontWithName:AllFont size:AllContentSize];;
    self.L_signin.font = [UIFont fontWithName:AllFont size:AllContentSize];;
    self.TF_email.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.TF_pwssword.font = [UIFont fontWithName:AllFont size:AllContentSize];
    
    self.btn_right1.titleLabel.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.l_navTitle.text= @"Sign In";
    
    if (self.isFromSetting)
    {
        [self.backBtn setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    }
    
    UITapGestureRecognizer * aTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapForgetPwdClick:)];
    [self.L_forget addGestureRecognizer:aTap];
    NSLog(@"%@===isEmail = %d",[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_LOGIN],isEmail);
    if (isEmail)
    {
        self.TF_email.placeholder = @"Email";
        self.TF_pwssword.placeholder = @"Password";
        
        self.TF_email.text = [[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_LOGIN];
        self.TF_pwssword.text = [[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_PASSWORD];
    }
    else
    {
        self.TF_email.placeholder = @"Name";
        self.TF_pwssword.placeholder = @"Password";
        self.TF_email.text = [[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_LOGIN];
        self.TF_pwssword.text = [[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_PASSWORD];
    }
    
}
-(void)tapForgetPwdClick:(UITapGestureRecognizer *)aTap
{
    ForgetPwdViewController * forget;
    if (iPhone5)
    {
        forget = [[ForgetPwdViewController alloc] initWithNibName:@"ForgetPwdViewController" bundle:nil];
    }
    else
    {
        forget = [[ForgetPwdViewController alloc] initWithNibName:@"ForgetPwdViewController4" bundle:nil];
    }
    [self.navigationController pushViewController:forget animated:YES];
}
-(void)backClick:(UIButton *)aButton
{
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    if (self.isQukyLogin)
    {
        [self.TF_email resignFirstResponder];
        [self.TF_pwssword resignFirstResponder];
        self.view.alpha = 0.0;
    }
    else
    {
        if (self.isBack)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
            [controller showLeftPanelAnimated:YES];
        }
    }
}
-(IBAction)signInClick:(id)sender
{
    // if (isEmail)
    // {
    if (self.TF_pwssword.text.length>0 &&self.TF_email.text >0)
    {
        
        [self.TF_email resignFirstResponder];
        [self.TF_pwssword resignFirstResponder];
        
        //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [MyActivceView startAnimatedInView1:self.view];
        NSMutableURLRequest * request = [WebService LoginUserName:self.TF_email.text password:self.TF_pwssword.text];
        [NSURLConnection connectionWithRequest:request delegate:self];
        // });
        
    }
    else
    {
       // [MyAlert ShowAlertMessage:@"Information is not completed." title:@""];
    }
    
    //  }
    //    else
    //    {
    //       // [((AppDelegate*)[[UIApplication sharedApplication] delegate]) openSessionWithAllowLoginUI:YES];
    //        // get the app delegate so that we can access the session property
    //          }
}
//- (void)updateView {
//    // get the app delegate, so that we can reference the session property
//    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
//    if (appDelegate.session.isOpen) {
//        // valid account UI is shown whenever the session is open
//        [self.buttonLoginLogout setTitle:@"Log out" forState:UIControlStateNormal];
//        [self.textNoteOrLink setText:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",
//                                      appDelegate.session.accessTokenData.accessToken]];
//    } else {
//        // login-needed account UI is shown whenever the session is closed
//        [self.buttonLoginLogout setTitle:@"Log in" forState:UIControlStateNormal];
//        [self.textNoteOrLink setText:@"Login to create a link to fetch account data"];
//    }
//}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MyActivceView stopAnimatedInView:self.view];
    });
   // [MyAlert ShowAlertMessage:@"Not to force the network" title:@""];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MyActivceView startAnimatedInView1:self.view];
    });
    
    reciveData = [NSMutableData dataWithCapacity:0];
    response1 = (NSHTTPURLResponse *)response;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [reciveData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MyActivceView stopAnimatedInView:self.view];
    });
    if ([response1 statusCode] == 200)
    {
        if ([(NSMutableURLRequest *)[connection currentRequest] isEqual:request_fb])
        {
            //[[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:LOGIN_STATUS];
            NSDictionary * dic = [reciveData objectFromJSONData];
            NSLog(@"dic = %@",dic);
            
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
                createPWD.email = [user valueForKey:LOGIN_LOGIN];
                createPWD.zipcode = [user valueForKey:LOGIN_ZIPCODE];
                createPWD.isFromSetting = YES;
                if (isQukyLogin)
                {
                    
                    self.view.alpha = 0.0;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccessRef" object:self];
                }
                [self.navigationController pushViewController:createPWD animated:YES];
            }
            else
            {
                AppDelegate * delegate = [UIApplication sharedApplication].delegate;
                JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
                if (isFromSetting)
                {
                    [controller showLeftPanelAnimated:YES];
                    
                    
                    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
                    JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
                    UINavigationController* nav = (UINavigationController *)controller.centerPanel;
                    NSArray * arr = [nav viewControllers];
                    ViewController * viewController = (ViewController *)[arr objectAtIndex:0];
                    [viewController viewDidLoad];

                }
                SetViewController* setViewController = (SetViewController *)controller.leftPanel;
                [setViewController viewWillAppear:YES];
                
                if (isQukyLogin)
                {
                    [self.TF_email resignFirstResponder];
                    [self.TF_pwssword resignFirstResponder];
                    self.view.alpha = 0.0;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccessRef" object:self];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
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
            
            NSDictionary * dic = [reciveData objectFromJSONData];
            NSLog(@"dic = %@",dic);
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            [user setValue:[dic valueForKey:@"birthYear"] forKey:LOGIN_BIRTHYEAR];
            [user setValue:[dic valueForKey:@"created"] forKey:LOGIN_CREATED];
            [user setValue:[dic valueForKey:@"firstName"] forKey:LOGIN_FIRST_NAME];
            NSLog(@"===%@",[dic valueForKey:@"gender"]);
            NSString *genderStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"gender"]];
            [user setValue:genderStr forKey:LOGIN_GENDER];
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
            
            if (isQukyLogin)
            {
                AppDelegate * delegate = [UIApplication sharedApplication].delegate;
                JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
                SetViewController* setViewController = (SetViewController *)controller.leftPanel;
                [setViewController viewWillAppear:YES];
                self.view.alpha = 0.0;
                [self.TF_email resignFirstResponder];
                [self.TF_pwssword resignFirstResponder];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccessRef" object:self];
            }
            else
            {
                if (self.isBack)
                {
                    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
                    JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
                    SetViewController* setViewController = (SetViewController *)controller.leftPanel;
                    [setViewController viewWillAppear:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"likeData" object:nil];
                }
                else
                {
                    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
                    JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
                    if (isFromSetting)
                    {
                        [controller showLeftPanelAnimated:YES];
                        
                        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
                        JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
                        UINavigationController* nav = (UINavigationController *)controller.centerPanel;
                        NSArray * arr = [nav viewControllers];
                        ViewController * viewController = (ViewController *)[arr objectAtIndex:0];
                        [viewController viewDidAppear:YES];
                    }
                    SetViewController* setViewController = (SetViewController *)controller.leftPanel;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [setViewController viewWillAppear:YES];
                    });
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MyActivceView stopAnimatedInView:self.view];
        });
       // [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData] title:@""];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.TF_pwssword resignFirstResponder];
    [self.TF_email resignFirstResponder];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:LOGIN_STATUS];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
