//
//  CreatePasswordViewController.m
//  OnSaleLocal
//
//  Created by tiankong360 on 13-10-7.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "CreatePasswordViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "SetViewController.h"
#import "ViewController.h"
#import "UIButton+ClickEvent.h"

@interface CreatePasswordViewController ()<NSURLConnectionDelegate,UIAlertViewDelegate>
{
    NSMutableData * reciveData;
    NSHTTPURLResponse * response1;
}
-(void)rightClick:(UIButton *)aButton;
- (BOOL)validateEmail:(NSString *)emailStr;
- (BOOL) isValidZip:(NSString *)aZip;
@property (nonatomic,strong) IBOutlet UITextField * TF_email;
@property (nonatomic,strong) IBOutlet UITextField * TF_password;
@property (nonatomic,strong) IBOutlet UITextField * TF_zipcode;
@property (nonatomic,strong) IBOutlet UILabel * l_t1,*l_t2;
@end

@implementation CreatePasswordViewController
@synthesize TF_email,TF_password,TF_zipcode;
@synthesize email,zipcode;
@synthesize isFromSetting;
@synthesize l_t1,l_t2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.l_t1.font = [UIFont fontWithName:AllFont size:AllFontSize];
    self.l_t2.font = [UIFont fontWithName:AllFont size:AllFontSize];
    
    self.TF_password.secureTextEntry = YES;
    self.l_navTitle.font = [UIFont fontWithName:AllFontBold size:All_h2_size];
    self.l_navTitle.text = [@"Create Password" uppercaseString];
    self.l_navTitle.textColor = [UIColor whiteColor];
    self.bgView.backgroundColor = [UIColor colorWithRed:46.0/255.0 green:46.0/255.0 blue:46.0/255.0 alpha:1.0];
    self.TF_email.text = self.email;
    self.TF_zipcode.text = self.zipcode;
    
    self.rightBtn.frame = CGRectMake(self.rightBtn.frame.origin.x-30, self.rightBtn.frame.origin.y, self.rightBtn.frame.size.width+30, self.rightBtn.frame.size.height);
    [self.rightBtn setTitle:@"Done" forState:UIControlStateNormal];
    self.rightBtn.layer.borderWidth = 1;
    self.rightBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.rightBtn.layer.cornerRadius = 5;
    [self.rightBtn addTarget:self action:@selector(rightClick:) forControlEvents:UIButtonClickEvent];
}
-(void)rightClick:(UITapGestureRecognizer *)gr
{
    if (self.TF_email.text.length>0 && self.TF_password.text.length>0 && self.TF_zipcode.text.length>0)
    {
    
            if ([self validateEmail:self.TF_email.text] == NO && [self isValidZip:self.TF_zipcode.text]==YES)
            {
                [MyAlert ShowAlertMessage:@"E-mail format is incorrect." title:@"Alert"];
            }
            else if ([self validateEmail:self.TF_email.text] == YES && [self isValidZip:self.TF_zipcode.text]==NO)
            {
                [MyAlert ShowAlertMessage:@"Zipcode format is incorrect." title:@"Alert"];
            }
            else
            {
                if ([WebService isConnectionAvailable])
                {
                    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                    NSString * genderStr = [NSString stringWithFormat:@"%@",[user valueForKey:LOGIN_GENDER]];
                    if ([genderStr isEqualToString:@"(null)"]||[genderStr isEqualToString:@"<null>"])
                    {
                        genderStr = @"NoToSay";
                    }
                    NSMutableURLRequest * request = [WebService UpdateUserInfoFirstName:[user valueForKey:LOGIN_FIRST_NAME] lastName:[user valueForKey:LOGIN_LAST_NAME] email:self.TF_email.text password:self.TF_password.text zipcode:self.TF_zipcode.text gender:genderStr birthday:2012];
                    NSLog(@"gender = %@",genderStr);
                    [NSURLConnection connectionWithRequest:request delegate:self];
                }
            }
    }
    else
    {
        [MyAlert ShowAlertMessage:@"Information is incomplete." title:@"Alert"];
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [MyActivceView stopAnimatedInView:self.view];
    //[MyAlert ShowAlertMessage:@"Not to force the network" title:@""];
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [MyActivceView startAnimatedInView2:self.view];
    reciveData = [NSMutableData dataWithCapacity:0];
    response1 = (NSHTTPURLResponse *)response;
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [reciveData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [MyActivceView stopAnimatedInView:self.view];
    if ([response1 statusCode] == 200)
    {
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        [user setValue:self.TF_email.text forKey:LOGIN_LOGIN];
        [user setValue:self.TF_password.text forKey:LOGIN_PASSWORD];
        [user setValue:self.TF_zipcode.text forKey:LOGIN_ZIPCODE];
        [self.TF_password resignFirstResponder];
        [self.TF_zipcode resignFirstResponder];
        [self.TF_email resignFirstResponder];
        
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Success" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:nil, nil];
//        [alert show];
        
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
        JASidePanelController * controller1 = (JASidePanelController *)delegate.viewController1;
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        AppDelegate * delegate1 = [UIApplication sharedApplication].delegate;
        JASidePanelController * controller2 = (JASidePanelController *)delegate1.viewController1;
        if (isFromSetting)
        {
            
            [controller2 showLeftPanelAnimated:YES];
            
            AppDelegate * delegate = [UIApplication sharedApplication].delegate;
            JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
            UINavigationController* nav = (UINavigationController *)controller.centerPanel;
            NSArray * arr = [nav viewControllers];
            ViewController * viewController = (ViewController *)[arr objectAtIndex:0];
            [viewController viewDidLoad];
            
        }
        SetViewController* setViewController = (SetViewController *)controller2.leftPanel;
        [setViewController viewWillAppear:YES];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        [controller1 showLeftPanelAnimated:YES];
        
    }
    else
    {
        NSLog(@"data = %@",[[NSString alloc] initWithData:reciveData encoding:4]);
       // [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData] title:@""];
    }
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0)
//    {
//        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
//        JASidePanelController * controller1 = (JASidePanelController *)delegate.viewController1;
//        CATransition* transition = [CATransition animation];
//        transition.duration = 0.5;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionMoveIn;
//        [self.navigationController.view.layer addAnimation:transition forKey:nil];
//        
//        AppDelegate * delegate1 = [UIApplication sharedApplication].delegate;
//        JASidePanelController * controller2 = (JASidePanelController *)delegate1.viewController1;
//        if (isFromSetting)
//        {
//          
//            [controller2 showLeftPanelAnimated:YES];
//            
//            AppDelegate * delegate = [UIApplication sharedApplication].delegate;
//            JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
//            UINavigationController* nav = (UINavigationController *)controller.centerPanel;
//            NSArray * arr = [nav viewControllers];
//            ViewController * viewController = (ViewController *)[arr objectAtIndex:0];
//            [viewController viewDidLoad];
// 
//        }
//        SetViewController* setViewController = (SetViewController *)controller2.leftPanel;
//        [setViewController viewWillAppear:YES];
//        
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        [controller1 showLeftPanelAnimated:YES];
//
//    }
//}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 52)
    {
        if (!iPhone5)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = CGRectMake(0, -30, 320, self.view.frame.size.height);
            }];
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    }];
    [self.TF_zipcode resignFirstResponder];
    [self.TF_password resignFirstResponder];
    [self.TF_email resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    }];
    [self.TF_zipcode resignFirstResponder];
    [self.TF_password resignFirstResponder];
    [self.TF_email resignFirstResponder];
}
- (BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}
- (BOOL) isValidZip:(NSString *)aZip
{
    NSString * zipRegex = @"^[1-9]\\d{4}$";
    NSPredicate * zip = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",zipRegex];
    return [zip evaluateWithObject:aZip];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
