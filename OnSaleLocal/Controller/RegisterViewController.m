//
//  RegisterViewController.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-15.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "RegisterViewController.h"
#import "JASidePanelController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface RegisterViewController ()<UITextFieldDelegate,NSURLConnectionDelegate,UIAlertViewDelegate>
{
    NSMutableData * reciveData;
    NSHTTPURLResponse * httpResponse;
    BOOL isMale;
}
@property (nonatomic,strong) IBOutlet UIImageView * IV_photo;
@property (nonatomic,strong) IBOutlet UITextField * TF_firstname;
@property (nonatomic,strong) IBOutlet UITextField * TF_lastname;
@property (nonatomic,strong) IBOutlet UITextField * TF_email;
@property (nonatomic,strong) IBOutlet UITextField * TF_password;
@property (nonatomic,strong) IBOutlet UITextField * TF_zipcode;
@property (nonatomic,strong) IBOutlet UIButton * Btn_male;
@property (nonatomic,strong) IBOutlet UIButton *  Btn_female;
@property (nonatomic,strong) IBOutlet UIView * bgView;
-(IBAction)cancleClick:(id)sender;
-(IBAction)resigsterClick:(id)sender;
-(IBAction)maleClick:(id)sender;
-(IBAction)femaleClick:(id)sender;
@end

@implementation RegisterViewController
@synthesize IV_photo;
@synthesize TF_email;
@synthesize TF_firstname;
@synthesize TF_lastname;
@synthesize TF_password;
@synthesize TF_zipcode;
@synthesize Btn_female;
@synthesize Btn_male;
@synthesize bgView;

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
    isMale = YES;
    self.Btn_male.layer.borderColor = [UIColor colorWithRed:178.0/255.0 green:178.0/255.0 blue:178.0/255.0 alpha:1.0].CGColor;
    self.Btn_male.layer.borderWidth = 1;
    self.Btn_male.layer.cornerRadius = 15;
    
    self.Btn_female.layer.borderColor = [UIColor colorWithRed:178.0/255.0 green:178.0/255.0 blue:178.0/255.0 alpha:1.0].CGColor;
    self.Btn_female.layer.borderWidth = 1;
    self.Btn_female.layer.cornerRadius = 15;
    
    self.TF_password.secureTextEntry = YES;
    self.Btn_male.backgroundColor = [UIColor grayColor];
    
}
-(IBAction)cancleClick:(id)sender
{
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    [controller showLeftPanelAnimated:YES];
}

-(IBAction)resigsterClick:(id)sender
{
    if (self.TF_email.text.length>0 &&self.TF_firstname.text.length>0&&self.TF_lastname.text.length>0&&self.TF_password.text.length>0&&self.TF_zipcode.text.length>0)
    {
        if ([self validateEmail:self.TF_email.text] && [self isValidZip:self.TF_zipcode.text])
        {
            NSString * MaleStr;
            if (isMale)
            {
                MaleStr = @"Man";
            }
            else
            {
             MaleStr = @"Woman";
            }
             NSMutableURLRequest * request = [WebService RegisterFirstName:self.TF_firstname.text LastName:self.TF_lastname.text Email:self.TF_email.text password:self.TF_password.text andZipcode:self.TF_zipcode.text male:MaleStr];
             [NSURLConnection connectionWithRequest:request delegate:self];
        }
        else
        {
            if ([self validateEmail:self.TF_email.text]==YES && [self isValidZip:self.TF_zipcode.text] == NO)
            {
                [MyAlert ShowAlertMessage:@"Please enter a five digit zip code." title:@""];
            }
            else if([self validateEmail:self.TF_email.text]==NO && [self isValidZip:self.TF_zipcode.text] == YES)
            {
                [MyAlert ShowAlertMessage:@"Please enter a valid email address." title:@""];
            }
            else
            {
                [MyAlert ShowAlertMessage:@"Please enter a valid email address and five digit zip code." title:nil];
            }  
        } 
     }
    else
    {
        [MyAlert ShowAlertMessage:@"Information is incomplete" title:@""];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [MyActivceView startAnimatedInView:self.view];
    reciveData = [NSMutableData dataWithCapacity:0];
    httpResponse = (NSHTTPURLResponse *)response;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [reciveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [MyActivceView stopAnimatedInView:self.view];
    NSLog(@"dic = %@",[[NSString alloc] initWithData:reciveData encoding:4]);
    if ([httpResponse statusCode] == 200)
    {
        NSDictionary * dic = [reciveData objectFromJSONData];
        if ([[dic valueForKey:@"status"] isEqualToString:@"Active"])
        {
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
            
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Success!" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil, nil];
//            [alert show];
            
            AppDelegate * delegate = [UIApplication sharedApplication].delegate;
            JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
            CATransition* transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionMoveIn;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            [controller showLeftPanelAnimated:YES];

        }
        else
        {
           // [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData] title:@""];
        }
    }
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
//    JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionMoveIn;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//    
//    [self.navigationController popViewControllerAnimated:YES];
//    [controller showLeftPanelAnimated:YES];
//}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [MyActivceView stopAnimatedInView:self.view];
    //[MyAlert ShowAlertMessage:@"Not to force the network" title:@""];
}
-(IBAction)maleClick:(id)sender
{
    [self.TF_zipcode resignFirstResponder];
    [self.TF_password resignFirstResponder];
    [self.TF_lastname resignFirstResponder];
    [self.TF_email resignFirstResponder];
    [self.TF_firstname resignFirstResponder];
    isMale =YES;
    UIButton * button =(UIButton *)sender;
    button.backgroundColor = [UIColor grayColor];
    self.Btn_female.backgroundColor = [UIColor whiteColor];
}
-(IBAction)femaleClick:(id)sender
{
    [self.TF_zipcode resignFirstResponder];
    [self.TF_password resignFirstResponder];
    [self.TF_lastname resignFirstResponder];
    [self.TF_email resignFirstResponder];
    [self.TF_firstname resignFirstResponder];
    isMale = NO;
    
    UIButton * button =(UIButton *)sender;
    button.backgroundColor = [UIColor grayColor];
    self.Btn_male.backgroundColor = [UIColor whiteColor];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.TF_zipcode resignFirstResponder];
    [self.TF_password resignFirstResponder];
    [self.TF_lastname resignFirstResponder];
    [self.TF_email resignFirstResponder];
    [self.TF_firstname resignFirstResponder];
    if (!iPhone5)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.frame = CGRectMake(24, 52, 272, 252);
        }];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!iPhone5)
    {
        if ([textField isEqual:self.TF_zipcode])
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.bgView.frame = CGRectMake(24, 0, 272, 252);
            }];
        }
    }
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


@end
