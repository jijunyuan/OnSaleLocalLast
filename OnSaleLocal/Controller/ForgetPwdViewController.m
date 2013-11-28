//
//  ForgetPwdViewController.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-17.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "ForgetPwdViewController.h"

@interface ForgetPwdViewController ()<UIAlertViewDelegate>
{
    NSHTTPURLResponse * httpResponse;
    NSMutableData * reciveData;
}
@property (nonatomic,strong) IBOutlet UITextField * TF_email;
@property (nonatomic,strong) IBOutlet UILabel * L_titlName;
-(IBAction)cancleClick:(id)sender;
-(IBAction)sendClick:(id)sender;
@end

@implementation ForgetPwdViewController
@synthesize TF_email;
@synthesize L_titlName;

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
    
    self.L_titlName.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.TF_email.font = [UIFont fontWithName:AllFont size:AllContentSize];
}
-(IBAction)cancleClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)sendClick:(id)sender
{
    if ([WebService isConnectionAvailable])
    {
        if (self.TF_email.text.length>0)
        {
            [self.TF_email resignFirstResponder];
            [MyActivceView startAnimatedInView2:self.view];
            NSMutableURLRequest * request = [WebService ResetPasswordEmail:self.TF_email.text];
            [NSURLConnection connectionWithRequest:request delegate:self];
        }
        else
        {
           // [MyAlert ShowAlertMessage:@"Please fill in the email." title:@""];
        }
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [MyActivceView stopAnimatedInView:self.view];
   // [MyAlert ShowAlertMessage:@"Not to force the network" title:@""];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    reciveData = [NSMutableData dataWithCapacity:0];
    [MyActivceView startAnimatedInView:self.view];
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
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Success" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:nil, nil];
//        [alert show];
         [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
       // [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData] title:@""];
    }
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//  [self.navigationController popViewControllerAnimated:YES];
//}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.TF_email resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
