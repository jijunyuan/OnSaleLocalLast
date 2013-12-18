//
//  PictureDetailViewController.m
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-28.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "PictureDetailViewController.h"
#import "PictureDoneViewController.h"
#import "TKHttpRequest.h"

@interface PictureDetailViewController ()<NSURLConnectionDelegate>
{
    NSHTTPURLResponse * httpResponse;
    NSMutableData * reciveData;
    UITextField * tempTextfield;
}
@property (nonatomic,strong) IBOutlet UITextField * TF_title;
@property (nonatomic,strong) IBOutlet UITextField * TF_startdate;
@property (nonatomic,strong) IBOutlet UITextField * TF_enddate;
@property (nonatomic,strong) IBOutlet UITextField * TF_store;
@property (nonatomic,strong) IBOutlet UITextField * TF_Address;
@property (nonatomic,strong) IBOutlet UITextField * TF_city;
@property (nonatomic,strong) IBOutlet UITextField * TF_zipcode;
@property (nonatomic,strong) IBOutlet UITextField * TF_state;
@property (nonatomic,strong) IBOutlet UITextView * TV_des;
@property (nonatomic,strong) IBOutlet UITextField * TF_discound;
@property (nonatomic,strong) IBOutlet UITextField * TF_url;


@property (nonatomic,strong) IBOutlet UIView * mainView;
@property (nonatomic,strong) IBOutlet UIScrollView * myScrollView;
@property (nonatomic,strong) IBOutlet UIDatePicker * datePicker;
@property (nonatomic,strong) IBOutlet UIView * bgview;
@property (nonatomic,strong) IBOutlet UILabel * l_t1, *l_t2,*l_t3,*l_t4,*l_t5,*l_t6,*l_t7,*l_t8,*l_t9,*l_t10;
-(void)sendClick:(UIButton *)aButton;
-(IBAction)datePickValueChange:(UIDatePicker *)aPicker;
-(void)getData;
- (BOOL)isPureInt:(NSString *)string;
- (BOOL)isPureFloat:(NSString *)string;
-(void)sendData;
@end

@implementation PictureDetailViewController
@synthesize TF_Address,TF_city,TF_enddate,TF_startdate,TF_store,TF_title,TF_zipcode,TV_des,TF_state;
@synthesize mainView;
@synthesize myScrollView;
@synthesize imageData,classId;
@synthesize datePicker;
@synthesize lat,longt;
@synthesize bgView;
@synthesize TF_discound;
@synthesize l_t1,l_t2,l_t3,l_t4,l_t5,l_t6,l_t7,l_t8,l_t9,l_t10;
@synthesize TF_url;

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
    if ([WebService ISIOS7])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.TF_Address.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.TF_city.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.TF_discound.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.TF_enddate.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.TF_startdate.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.TF_state.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.TF_store.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.TF_title.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.TF_zipcode.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.TF_url.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.TV_des.font = [UIFont fontWithName:AllFont size:AllContentSize];
    
    self.l_t1.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.l_t2.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.l_t3.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.l_t4.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.l_t5.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.l_t6.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.l_t7.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.l_t8.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.l_t9.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.l_t10.font = [UIFont fontWithName:AllFont size:AllContentSize];

    
    
    self.l_navTitle.font = [UIFont fontWithName:AllFontBold size:All_h2_size];
    self.l_navTitle.text = @"Description";
    [self.rightBtn setImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(sendClick:) forControlEvents:UIButtonClickEvent];
    
    //self.TF_startdate.inputView = [[UIView alloc] init];
    self.TF_enddate.inputView = [[UIView alloc] init];
    self.datePicker.alpha = 0.0;
    
    UIWindow * window1 = [[UIApplication sharedApplication].windows objectAtIndex:0];
    self.datePicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-216, 320, 216);
    [window1 addSubview:self.datePicker];
     
    if (!iPhone5)
    {
        self.myScrollView.contentSize = CGSizeMake(290, 650);
        [self.myScrollView addSubview:self.mainView];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getData];
    });
    
}
-(void)getData
{
    
//#warning mark - change value
//    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
//    float lat = 0.0;
//    float longt = 0.0;
//    if ([[[NSUserDefaults standardUserDefaults] valueForKey:IS_CURR_LOCATION] isEqualToString:@"0"])
//    {
//        lat = [[user valueForKey:USING_LAT] floatValue];
//        longt = [[user valueForKey:USING_LONG] floatValue];
//    }
//    else
//    {
//        lat = [[user valueForKey:CURR_LAT] floatValue];
//        longt = [[user valueForKey:CURR_LONG] floatValue];
//    }

    NSString * formatStr = [NSString stringWithFormat:@"/ws/v2/location-lookup?latitude=%g&longitude=%g&format=json",self.lat,self.longt];
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
    NSMutableData * reciveData1 = [NSMutableData dataWithCapacity:0];
    [request setStartedBlock:^{
        [MyActivceView startAnimatedInView:self.view];
    }];
    [request setDataReceivedBlock:^(NSData *data) {
        [reciveData1 appendData:data];
    }];
    [request setCompletionBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        NSLog(@"===%@",[[NSString alloc] initWithData:reciveData1 encoding:4]);
        if ([request responseStatusCode] == 200)
        {
            NSDictionary * dic = [[reciveData1 objectFromJSONData] valueForKey:@"addr"];
            NSLog(@"dic = %@",dic);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.TF_city.text = [dic valueForKey:@"city"];
                self.TF_Address.text = [dic valueForKey:@"street"];
            });
        }
        else
        {
           // [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData1] title:@""];
        }
    }];
    
    [request setFailedBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        if ([request responseStatusCode] != 200)
        {
          //  [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData1] title:@""];
        }
    }];

    [request startAsynchronous];
}
-(void)sendClick:(UIButton *)aButton
{
    if (self.TF_Address.text.length>0 && self.TF_store.text.length>0 && self.TF_city.text.length>0 &&self.TF_enddate.text.length>0)
    {
        if (self.TF_discound.text.length>0)
        {
            if ([self isPureFloat:self.TF_discound.text])
            {
                [self addEvent];
            }
            else
            {
              [MyAlert ShowAlertMessage:@"Input discount format error." title:@"Alert"];
            }
        }
        else
        {
            [self addEvent];
        }
    }
    else
   {
     [MyAlert ShowAlertMessage:@"Information is incomplete." title:@"Alert"];
   }
   
}
-(void)addEvent
{
    if (self.TF_startdate.text.length>0)
    {
        if ([self isPureFloat:self.TF_startdate.text] || [self isPureInt:self.TF_startdate.text])
        {
            [self sendData];
        }
        else
        {
            [MyAlert ShowAlertMessage:@"Input price format error." title:@"Alert"];
        }
    }
    else
    {
        [self sendData];
    }

}
-(void)sendData
{
    [MyActivceView startAnimatedInView2:self.view];
    
    if (iPhone5)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 0, 320, 568);
            self.datePicker.alpha = 0.0;
        }];
    }
    [self.TF_zipcode resignFirstResponder];
    [self.TF_title resignFirstResponder];
    [self.TF_store resignFirstResponder];
    [self.TF_startdate resignFirstResponder];
    [self.TF_enddate resignFirstResponder];
    [self.TF_city resignFirstResponder];
    [self.TF_Address resignFirstResponder];
    [self.TV_des resignFirstResponder];
    [self.TF_discound resignFirstResponder];
    [self.TF_url resignFirstResponder];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    NSDate * date = [formatter dateFromString:self.TF_startdate.text];
    NSDate * date1 = [formatter dateFromString:self.TF_enddate.text];
    
    
    NSMutableURLRequest * request = [WebService SumbitOfferImage:self.imageData title:self.TF_title.text description:self.TV_des.text merchant:self.TF_store.text address:self.TF_Address.text city:self.TF_city.text state:self.TF_startdate.text country:self.TF_city.text phone:@"" start:[date timeIntervalSince1970] end:[date1 timeIntervalSince1970] tags:self.classId andDiscount:self.TF_discound.text andUrl:self.TF_url.text];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (iPhone5)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 0, 320, 568);
             self.datePicker.alpha = 0.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.myScrollView.contentOffset = CGPointMake(0, 0);
            self.datePicker.alpha = 0.0;
        }];
    }
    [self.TF_zipcode resignFirstResponder];
    [self.TF_title resignFirstResponder];
    [self.TF_store resignFirstResponder];
    [self.TF_startdate resignFirstResponder];
    [self.TF_enddate resignFirstResponder];
    [self.TF_city resignFirstResponder];
    [self.TF_Address resignFirstResponder];
    [self.TV_des resignFirstResponder];
     [self.TF_discound resignFirstResponder];
    [self.TF_url resignFirstResponder];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
     self.datePicker.alpha = 0.0;
    [self.TF_zipcode resignFirstResponder];
    [self.TF_title resignFirstResponder];
    [self.TF_store resignFirstResponder];
    [self.TF_startdate resignFirstResponder];
    [self.TF_enddate resignFirstResponder];
    [self.TF_city resignFirstResponder];
    [self.TF_Address resignFirstResponder];
    [self.TV_des resignFirstResponder];
     [self.TF_discound resignFirstResponder];
    [self.TF_url resignFirstResponder];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.datePicker.alpha = 1.0;
        self.myScrollView.contentOffset = CGPointMake(0, 60);
    }];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (iPhone5)
    {
        if (textField.tag == 99)
        {
            tempTextfield = textField;
            [UIView animateWithDuration:0.3 animations:^{
//self.datePicker.alpha = 1.0;
            }];
        }
        if (textField.tag == 100)
        {
            tempTextfield = textField;
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = CGRectMake(0, -95, 320, 568);
                self.datePicker.alpha = 1.0;
            }];
        }
        if (textField.tag == 101)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = CGRectMake(0, -135, 320, 568);
                self.datePicker.alpha = 0.0;
            }];
        }
        if (textField.tag == 102)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = CGRectMake(0, -175, 320, 568);
                self.datePicker.alpha = 0.0;
            }];
            
        }
        if (textField.tag == 103)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = CGRectMake(0, -215, 320, 568);
                self.datePicker.alpha = 0.0;
            }];
        }
        if (textField.tag == 104)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = CGRectMake(0, -215, 320, 568);
                self.datePicker.alpha = 0.0;
            }];
        }
        if (textField.tag == 106)
        {
            tempTextfield = textField;
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = CGRectMake(0, -215, 320, 568);
                self.datePicker.alpha = 1.0;
            }];
        }
    }
    else
    {
        if (textField.tag == 99)
        {
            tempTextfield = textField;
            [UIView animateWithDuration:0.3 animations:^{
                self.myScrollView.contentOffset = CGPointMake(0, 150);
               // self.datePicker.alpha = 1.0;
            }];
        }
        if (textField.tag == 100)
        {
            tempTextfield = textField;
            [UIView animateWithDuration:0.3 animations:^{
               // self.view.frame = CGRectMake(0, -55, 320, 568);
                self.myScrollView.contentOffset = CGPointMake(0, 190);
                self.datePicker.alpha = 1.0;
            }];
        }
        if (textField.tag == 101)
        {
            [UIView animateWithDuration:0.3 animations:^{
              //  self.view.frame = CGRectMake(0, -95, 320, 568);
                 self.myScrollView.contentOffset = CGPointMake(0, 230);
                self.datePicker.alpha = 0.0;
            }];
        }
        if (textField.tag == 102)
        {
            [UIView animateWithDuration:0.3 animations:^{
               // self.view.frame = CGRectMake(0, -135, 320, 568);
                self.myScrollView.contentOffset = CGPointMake(0, 270);
                self.datePicker.alpha = 0.0;
            }];
            
        }
        if (textField.tag == 103)
        {
            [UIView animateWithDuration:0.3 animations:^{
               // self.view.frame = CGRectMake(0, -175, 320, 568);
                self.myScrollView.contentOffset = CGPointMake(0, 320);
                self.datePicker.alpha = 0.0;
            }];
        }
        if (textField.tag == 104)
        {
            [UIView animateWithDuration:0.3 animations:^{
               // self.view.frame = CGRectMake(0, -215, 320, 568);
                self.myScrollView.contentOffset = CGPointMake(0, 310);
                self.datePicker.alpha = 0.0;
            }];
        }
        if (textField.tag == 106)
        {
            [UIView animateWithDuration:0.3 animations:^{
                // self.view.frame = CGRectMake(0, -215, 320, 568);
                self.myScrollView.contentOffset = CGPointMake(0, 320);
                self.datePicker.alpha = 0.0;
            }];
        }
        if (textField.tag == 107)
        {
            [UIView animateWithDuration:0.3 animations:^{
                // self.view.frame = CGRectMake(0, -215, 320, 568);
                self.myScrollView.contentOffset = CGPointMake(0, 320);
                self.datePicker.alpha = 0.0;
            }];
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (iPhone5)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 0, 320, 568);
            self.datePicker.alpha = 0.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.myScrollView.contentOffset = CGPointMake(0, 0);
            self.datePicker.alpha = 0.0;
        }];
    }
    [self.TF_zipcode resignFirstResponder];
    [self.TF_title resignFirstResponder];
    [self.TF_store resignFirstResponder];
    [self.TF_startdate resignFirstResponder];
    [self.TF_enddate resignFirstResponder];
    [self.TF_city resignFirstResponder];
    [self.TF_Address resignFirstResponder];
    [self.TV_des resignFirstResponder];
     [self.TF_discound resignFirstResponder];
    [self.TF_url resignFirstResponder];
    return YES;
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
   // [MyActivceView startAnimatedInView:self.bgView];
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
    NSLog(@"staode = %d=%@=dic = %@",httpResponse.statusCode,reciveData,[[NSString alloc] initWithData:reciveData encoding:4]);
    if ([httpResponse statusCode] == 200)
    {
        NSDictionary * dic1 = [reciveData objectFromJSONData];
        PictureDoneViewController * pictoreDone;
        if (iPhone5)
        {
            pictoreDone = [[PictureDoneViewController alloc] initWithNibName:@"PictureDoneViewController" bundle:nil];
        }
        else
        {
            pictoreDone = [[PictureDoneViewController alloc] initWithNibName:@"PictureDoneViewController4" bundle:nil];
        }
        pictoreDone.dic = dic1;
        pictoreDone.storeId = [dic1 valueForKey:@"merchantId"];
        pictoreDone.storeName = [dic1 valueForKey:@"merchant"];
        [self.navigationController pushViewController:pictoreDone animated:YES];
    }
    else
    {
        [MyAlert ShowAlertMessage:@"Sumbit Failed." title:@"Alert"];
    }
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [MyActivceView stopAnimatedInView:self.view];
   // [MyAlert ShowAlertMessage:@"Not to force the network" title:@""];
}
-(IBAction)datePickValueChange:(UIDatePicker *)aPicker
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    tempTextfield.text = [formatter stringFromDate:aPicker.date];
}
- (BOOL)isPureInt:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
