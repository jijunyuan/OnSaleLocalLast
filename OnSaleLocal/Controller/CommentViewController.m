//
//  CommentViewController.m
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-27.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()<NSURLConnectionDelegate,UIAlertViewDelegate>
{
    NSMutableData * reciveData;
    NSHTTPURLResponse * httpResponse;
}
@property (nonatomic,strong) IBOutlet UITextView * TV_text;
-(void)doneClick;
@end

@implementation CommentViewController
@synthesize offerId;
@synthesize TV_text;

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
    self.l_navTitle.font = [UIFont fontWithName:AllFontBold size:All_h2_size];
    self.l_navTitle.text = @"Comment";
    [self.TV_text resignFirstResponder];
    self.rightBtn.userInteractionEnabled = YES;
    [self.rightBtn setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    self.rightBtn.frame = CGRectMake(self.rightBtn.frame.origin.x, self.rightBtn.frame.origin.y, 30, 30);
    [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)doneClick
{
    if (self.TV_text.text.length>0)
    {
        NSLog(@"==%@==%@",self.TV_text.text,[self.TV_text.text stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]);
         NSString * strResult = [self.TV_text.text stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
        NSString * strResult1 = [strResult stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        NSString * strResult2 = [strResult1 stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
       
        self.rightBtn.userInteractionEnabled = NO;
        NSMutableURLRequest * request = [WebService CommentOfferOfID:self.offerId Content:strResult2];
        [NSURLConnection connectionWithRequest:request delegate:self];

    }
    else
    {
        [MyAlert ShowAlertMessage:@"Please input content" title:@""];
    }
    
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    NSNotification * notification = [NSNotification notificationWithName:@"commentAddOne" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//    [self.navigationController popViewControllerAnimated:YES];
//}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [MyActivceView startAnimatedInView2:self.view];
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
        [self.TV_text resignFirstResponder];
        NSNotification * notification = [NSNotification notificationWithName:@"commentAddOne" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else
    {
        self.rightBtn.userInteractionEnabled = YES;
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.rightBtn.userInteractionEnabled = YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.TV_text resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
