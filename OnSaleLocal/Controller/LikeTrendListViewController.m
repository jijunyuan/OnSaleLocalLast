//
//  LikeTrendListViewController.m
//  OnSaleLocal
//
//  Created by tiankong360 on 13-10-17.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "LikeTrendListViewController.h"
#import "TKHttpRequest.h"

@interface LikeTrendListViewController ()

@end

@implementation LikeTrendListViewController
@synthesize userid;

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
    self.l_navTitle.font = [UIFont fontWithName:AllFontBold size:All_h2_size];
    self.l_navTitle.text = [@"Likes" uppercaseString];
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.IV_result.alpha = 0.0;
    self.L_result.alpha = 0.0;
    self.leftButton.frame = CGRectMake(0, self.leftButton.frame.origin.y+5, 30, 30);
    [self.leftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
}
-(void)getData
{
//    if (waterFlow != nil)
//    {
//        waterFlow = nil;
//    }
//    [self addWaterfolow];
    
    [self.dataArr removeAllObjects];
    NSString * formatStr = [NSString stringWithFormat:@"/ws/user/user-fav-offers?userId=%@&format=json",self.userid];
    NSString * url = [DO_MAIN stringByAppendingString:formatStr];
    NSLog(@"url = %@",url);
    __block ASIHTTPRequest * request3 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request3 setTimeOutSeconds:MAX_SECONDS_REQUEST];
    [request3 setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [ request3 setNumberOfTimesToRetryOnTimeout:3]; //set times when request fail
    [request3 setDownloadCache:[TKHttpRequest ShareMyCache]];
    [request3 setSecondsToCache:60*60*2];
    [request3 setUseCookiePersistence:YES];
    [request3 buildRequestHeaders];
    NSMutableData * reciveData4 = [NSMutableData dataWithCapacity:0];
    [request3 setStartedBlock:^{
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
        [MyActivceView startAnimatedInView:self.view];
    }];
    [request3 setDataReceivedBlock:^(NSData *data) {
        [reciveData4 appendData:data];
    }];
    __block BOOL isHaveKey = NO;
    [request3 setCompletionBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        if ([request3 responseStatusCode] == 200)
        {
            NSString * resultStr = [[NSString alloc] initWithData:reciveData4 encoding:NSASCIIStringEncoding];
            NSMutableArray * arr = [[resultStr objectFromJSONString] valueForKey:@"items"];
            [arr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
                for (NSString * key in [obj allKeys])
                {
                    if ([key isEqualToString:@"offer"])
                    {
                        isHaveKey = YES;
                    }
                }
                if (isHaveKey)
                {
                    NSString * offer = [NSString stringWithFormat:@"%@",[obj valueForKey:@"offer"]];
                    if ((![offer isEqualToString:@"(null)"])&&(![offer isEqualToString:@"<null>"]))
                    {
                        [self.dataArr addObject:[obj valueForKey:@"offer"]];
                    }
                }
            }];

            dispatch_async(dispatch_get_main_queue(), ^{
                [waterFlow reloadData];
            });
        }
        else
        {
           // [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData4] title:@""];
        }
    }];
    
    [request3 setFailedBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        if ([request responseStatusCode] != 200)
        {
           // [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData] title:@""];
        }
    }];
    [request3 startAsynchronous];
}
-(void)getData1
{

    if (waterFlow != nil)
    {
        waterFlow = nil;
    }
    [self addWaterfolow];
    
    NSString * formatStr = [NSString stringWithFormat:@"/ws/user/user-fav-offers?userId=%@&format=json",self.userid];
    
    NSString * url = [DO_MAIN stringByAppendingString:formatStr];
    NSLog(@"url = %@",url);
    __block ASIHTTPRequest * request6 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request6 setTimeOutSeconds:MAX_SECONDS_REQUEST];
    [request6 setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [ request6 setNumberOfTimesToRetryOnTimeout:3]; //set times when request fail
    [request6 setDownloadCache:[TKHttpRequest ShareMyCache]];
    [request6 setSecondsToCache:60*60*2];
    [request6 setUseCookiePersistence:YES];
    [request6 buildRequestHeaders];
    [request6 startSynchronous];
    
    //[self.dataArr removeAllObjects];
    self.dataArr = nil;
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    __block BOOL isHaveKey = NO;
    NSString * str11 = [[NSString alloc] initWithData:[request6 responseData] encoding:1];
    NSMutableArray * arr = [[str11 objectFromJSONString] valueForKey:@"items"];
    [arr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
        for (NSString * key in [obj allKeys])
        {
            if ([key isEqualToString:@"offer"])
            {
                isHaveKey = YES;
            }
        }
        if (isHaveKey)
        {
            if ([obj valueForKey:@"offer"] != nil)
            {
                [self.dataArr addObject:[obj valueForKey:@"offer"]];
            }
        }
    }];
    NSLog(@"self.dataArr.cout = %d",self.dataArr.count);

    [waterFlow reloadData];
    // [waterFlow reloadData];
}
-(void)backClick:(UIButton *)aButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
