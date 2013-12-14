//
//  ChangeLocationViewController.m
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-14.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "ChangeLocationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "TKHttpRequest.h"
#import <QuartzCore/QuartzCore.h>

@interface ChangeLocationViewController ()<CLLocationManagerDelegate,UIAccelerometerDelegate>
{
    CLLocationManager * manger;
    
}
@property (nonatomic,strong) IBOutlet UIButton * Btn_currLocation;
@property (nonatomic,strong) IBOutlet UIButton * Btn_setLocation;
@property (nonatomic,strong) IBOutlet UILabel * L_currLocation;
@property (nonatomic,strong) IBOutlet UITextField * TF_setLocation;
@property (nonatomic,strong) IBOutlet UIView * IV_currView;
@property (nonatomic,strong) IBOutlet UIView * IV_setView;
@property (nonatomic,strong) IBOutlet UILabel * L_t1;
@property (nonatomic,strong) IBOutlet UILabel * L_t2;
@property (nonatomic,strong) IBOutlet UIView * bgViewCurr;

-(IBAction)currBtnClick:(id)sender;
-(IBAction)setLocationClick:(id)sender;
-(void)sumbitLocation:(id)sender;
@end

@implementation ChangeLocationViewController
@synthesize Btn_currLocation;
@synthesize Btn_setLocation;
@synthesize L_currLocation;
@synthesize TF_setLocation;
@synthesize L_t1,L_t2;
@synthesize bgViewCurr;

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
    self.l_navTitle.text = @"Change Location";
    self.Btn_setLocation.layer.cornerRadius = 10;
    self.Btn_currLocation.layer.cornerRadius = 10;
    self.IV_currView.layer.cornerRadius = 15;
    self.IV_setView.layer.cornerRadius = 15;
    
    self.bgViewCurr.layer.borderWidth = 1;
    self.bgViewCurr.layer.borderColor = [UIColor colorWithRed:196.0/255.0 green:196.0/255.0 blue:196.0/255.0 alpha:1.0].CGColor;
    self.bgViewCurr.layer.cornerRadius = 5;
    
    self.L_t1.font = [UIFont fontWithName:AllFont size:AllFontSize];
    self.L_t2.font = [UIFont fontWithName:AllFont size:AllFontSize];
    self.TF_setLocation.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.L_currLocation.font = [UIFont fontWithName:AllFont size:AllContentSize];
    
    [self.rightBtn setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(sumbitLocation:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn.frame = CGRectMake(self.rightBtn.frame.origin.x+10, self.rightBtn.frame.origin.y, 30, 30);
    
    
    
    
    self.Btn_currLocation.backgroundColor = [UIColor colorWithRed:70.0/255.0 green:146.0/255.0 blue:19.0/255.0 alpha:1.0];
    self.Btn_setLocation.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"IS_CURR_LOCATION = %@",[[NSUserDefaults standardUserDefaults] valueForKey:IS_CURR_LOCATION]);
    CGRect frame = [self.TF_setLocation frame];
    frame.size.width = 15;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    self.TF_setLocation.leftViewMode = UITextFieldViewModeAlways;
    self.TF_setLocation.leftView = leftview;
    
    self.TF_setLocation.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"adress_set"];
    self.TF_setLocation.layer.borderColor = [UIColor colorWithRed:196.0/255.0 green:196.0/255.0 blue:196.0/255.0 alpha:1.0].CGColor;
    self.TF_setLocation.layer.borderWidth = 1;
    self.TF_setLocation.layer.cornerRadius = 5;
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:IS_CURR_LOCATION] isEqualToString:@"0"])
    {
        
        self.Btn_setLocation.backgroundColor = [UIColor colorWithRed:70.0/255.0 green:146.0/255.0 blue:19.0/255.0 alpha:1.0];
        self.Btn_currLocation.backgroundColor = [UIColor whiteColor];
    }
    
    
    //    //获取当前经纬度
    //    if ([CLLocationManager locationServicesEnabled])
    //    {
    manger = [[CLLocationManager alloc] init];
    manger.desiredAccuracy = kCLLocationAccuracyBest;
    [manger setDistanceFilter:kCLDistanceFilterNone];
    manger.delegate = self;
    [manger startUpdatingLocation];
    NSLog(@"be able to get current location");
    //    }
    //    else
    //    {
    //        NSLog(@"Unable to get current location");
    //    }
    
    float lat = manger.location.coordinate.latitude;
    float longit = manger.location.coordinate.longitude;
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [user setValue:[NSNumber numberWithFloat:lat] forKey:CURR_LAT];
    [user setValue:[NSNumber numberWithFloat:longit] forKey:CURR_LONG];
    
    //#warning mark - change value  write lat,long curr location
    // NSString * formatStr = [NSString stringWithFormat:@"/ws/v2/location-lookup?latitude=37.378536&longitude=-122.086586&format=json"];
    NSString * formatStr = [NSString stringWithFormat:@"/ws/v2/location-lookup?latitude=%f&longitude=%f&format=json",lat,longit];
    NSString * url = [DO_MAIN stringByAppendingString:formatStr];
    NSLog(@"url = %@",url);
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeOutSeconds:MAX_SECONDS_REQUEST];
    [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [request setNumberOfTimesToRetryOnTimeout:3]; //set times when request fail
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
        if ([request responseStatusCode] == 200)
        {
            NSDictionary * dic = [[reciveData1 objectFromJSONData] valueForKey:@"addr"];
            NSLog(@"dic = %@",dic);
            NSString * formatStr = [NSString stringWithFormat:@"%@,%@",[dic valueForKey:@"city"],[dic valueForKey:@"state"]];
            self.L_currLocation.text = formatStr;
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
            //[MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData1] title:@""];
        }
    }];
    [request startAsynchronous];
}
-(IBAction)currBtnClick:(id)sender
{
    if ([CLLocationManager locationServicesEnabled])
    {
        manger = [[CLLocationManager alloc] init];
        manger.desiredAccuracy = kCLLocationAccuracyBest;
        [manger setDistanceFilter:kCLDistanceFilterNone];
        manger.delegate = self;
        //[manger startUpdatingLocation];
        NSLog(@"be able to get current location");
    }
    else
    {
        NSLog(@"Unable to get current location");
    }
    
    float lat1 = manger.location.coordinate.latitude;
    float longit1 = manger.location.coordinate.longitude;
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [user setValue:[NSNumber numberWithFloat:lat1] forKey:CURR_LAT];
    [user setValue:[NSNumber numberWithFloat:longit1] forKey:CURR_LONG];
    
    [user setValue:@"" forKey:USING_LAT];
    [user setValue:@"" forKey:USING_LAT];
    
    [user setValue:@"1" forKey:IS_CURR_LOCATION];
    
    self.Btn_currLocation.backgroundColor = [UIColor colorWithRed:70.0/255.0 green:146.0/255.0 blue:19.0/255.0 alpha:1.0];
    self.Btn_setLocation.backgroundColor = [UIColor whiteColor];
    self.TF_setLocation.userInteractionEnabled = NO;
    [self.TF_setLocation resignFirstResponder];
}
-(IBAction)setLocationClick:(id)sender
{
    self.Btn_setLocation.backgroundColor = [UIColor colorWithRed:70.0/255.0 green:146.0/255.0 blue:19.0/255.0 alpha:1.0];
    self.Btn_currLocation.backgroundColor = [UIColor whiteColor];
    self.TF_setLocation.userInteractionEnabled = YES;
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [user setValue:@"0" forKey:IS_CURR_LOCATION];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    manger = manager;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.TF_setLocation resignFirstResponder];
}
-(void)sumbitLocation:(id)sender
{
    NSString * adressStr = self.TF_setLocation.text;
    NSLog(@"%f,%f",[self getPostion:adressStr].latitude,[self getPostion:adressStr].longitude);
    CLLocationCoordinate2D  location = [self getPostion:adressStr];
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [user setValue:[NSNumber numberWithFloat:location.latitude] forKey:USING_LAT];
    [user setValue:[NSNumber numberWithFloat:location.longitude] forKey:USING_LONG];
    
    [user setValue:@"" forKey:CURR_LAT];
    [user setValue:@"" forKey:CURR_LONG];
    
    [user setValue:@"0" forKey:IS_CURR_LOCATION];
    [user setValue:adressStr forKey:@"adress_set"];
    [self.TF_setLocation resignFirstResponder];
    [MyAlert ShowAlertMessage:@"Success!" title:@"Alert"];
}
- (CLLocationCoordinate2D)getPostion:(NSString *)address
{
    NSString *googleURL = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?address=%@&sensor=true",[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    CLLocationCoordinate2D position;
    position.latitude = 0.0;
    position.longitude = 0.0;
    
    NSError *error;
    NSString *retstr = [NSString stringWithContentsOfURL:[NSURL URLWithString:googleURL] encoding:NSUTF8StringEncoding error:&error];
    if (retstr)
    {
        NSDictionary *dict = [retstr objectFromJSONString];
        if (dict)
        {
            NSArray *results = [dict objectForKey:@"results"];
            if (results && results.count > 0)
            {
                NSDictionary *geometry = [[results objectAtIndex:0] objectForKey:@"geometry"];
                NSDictionary *location = [geometry objectForKey:@"location"];
                position.latitude = [[location objectForKey:@"lat"] doubleValue];
                position.longitude = [[location objectForKey:@"lng"] doubleValue];
            }
        }
    }
    else
    {
        NSLog(@"error: %@", error);
    }
    return position;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
