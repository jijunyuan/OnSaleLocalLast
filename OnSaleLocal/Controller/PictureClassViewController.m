//
//  PictureClassViewController.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-27.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "PictureClassViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TKHttpRequest.h"
#import <CoreLocation/CoreLocation.h>
#import "EGORefreshTableHeaderView.h"
#import "PictureDetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UIButton+ClickEvent.h"


@interface PictureClassViewController ()<CLLocationManagerDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate>
{
    CLLocationManager * manger;
    EGORefreshTableHeaderView *_refreshTableView;
    BOOL _reloading;
    NSString * currIdOrName;
    NSMutableArray * buttonArr;
}
@property (nonatomic,strong) IBOutlet UITableView * TV_tableview;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) NSMutableDictionary * myDicStaus;
-(void)nextClick;
-(void)getData;
////开始重新加载时调用的方法
- (void)reloadTableViewDataSource;
////完成加载时调用的方法
- (void)doneLoadingTableViewData;
-(void)buttonClick:(UIButton *)aButton;
@end

@implementation PictureClassViewController
@synthesize TV_tableview;
@synthesize dataArr;
@synthesize imageData;
@synthesize myDicStaus;

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
    self.myDicStaus = [NSMutableDictionary dictionaryWithCapacity:0];
    self.l_navTitle.font = [UIFont fontWithName:AllFontBold size:All_h2_size];
    self.l_navTitle.text = @"Categories";
    
    if ([WebService ISIOS7])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    buttonArr = [NSMutableArray arrayWithCapacity:0];
    
    self.TV_tableview.tableFooterView = [[UIView alloc] init];
    [self.rightBtn setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(nextClick) forControlEvents:UIButtonClickEvent];
    
    if (_refreshTableView == nil)
    {
        //初始化下拉刷新控件
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.TV_tableview.bounds.size.height, self.view.frame.size.width, self.TV_tableview.bounds.size.height)];
        refreshView.delegate = self;
        //将下拉刷新控件作为子控件添加到UITableView中
        [self.TV_tableview addSubview:refreshView];
        _refreshTableView = refreshView;
    }

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getData];
    });
}
-(void)getData
{
//#warning mark - change value
    ////test 37.378536   -122.086586
    
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
    
    float lat = manger.location.coordinate.latitude;
    float longit = manger.location.coordinate.longitude;    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:IS_CURR_LOCATION] isEqualToString:@"0"])
    {
        lat = [[user valueForKey:USING_LAT] floatValue];
        longit = [[user valueForKey:USING_LONG] floatValue];
    }


    
    
    // ASIHTTPRequest * request = [WebService GetClasslistByLat:37.378536 long:-122.086586 radius:10.0];
    NSString * formatStr = [NSString stringWithFormat:@"%@/ws/category/top-categories?lat=%f&lng=%f&radius=%f&format=json",DO_MAIN,lat,longit,10.0];
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:formatStr]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:MAX_SECONDS_REQUEST];
    [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [ request setNumberOfTimesToRetryOnTimeout:3]; //set times when request fail
    [request setDownloadCache:[TKHttpRequest ShareMyCache]];
    [request setSecondsToCache:60*60*2];
    __block NSMutableData * reciveData = [NSMutableData dataWithCapacity:0];
    [request setStartedBlock:^{
        self.TV_tableview.hidden = YES;
         [MyActivceView startAnimatedInView:self.view];
    }];
    [request setDataReceivedBlock:^(NSData *data) {
        [reciveData appendData:data];
    }];
    [request setCompletionBlock:^{
         [MyActivceView stopAnimatedInView:self.view];
        if (request.responseStatusCode == 200)
        {
            self.dataArr = [[reciveData objectFromJSONData] valueForKey:@"items"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.TV_tableview.hidden = NO;
                [self.TV_tableview reloadData];
            });
            NSLog(@"dataArr =%@",self.dataArr);
        }
        else
        {
           // [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData] title:@""];
        }
    }];
    [request setFailedBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        //[MyAlert ShowAlertMessage:@"Not to force the network" title:@""];
    }];
    [request startAsynchronous];
}
-(void)getData1
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
    
    float lat = manger.location.coordinate.latitude;
    float longit = manger.location.coordinate.longitude;
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:IS_CURR_LOCATION] isEqualToString:@"0"])
    {
        lat = [[user valueForKey:USING_LAT] floatValue];
        longit = [[user valueForKey:USING_LONG] floatValue];
    }
    
//#warning mark - change value
    NSString * formatStr = [NSString stringWithFormat:@"%@/ws/category/top-categories?lat=%f&lng=%f&radius=%f&format=json",DO_MAIN,lat,longit,10.0];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:formatStr]];
    [request setTimeOutSeconds:MAX_SECONDS_REQUEST];
    [request startSynchronous];
    self.dataArr = [[request.responseData objectFromJSONData] valueForKey:@"items"];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    manger = manager;
}
-(void)nextClick
{
    PictureDetailViewController * detail;
    if (iPhone5)
    {
        detail = [[PictureDetailViewController alloc] initWithNibName:@"PictureDetailViewController" bundle:nil];
    }
    else
    {
        detail = [[PictureDetailViewController alloc] initWithNibName:@"PictureDetailViewController4" bundle:nil];
    }
    detail.lat = manger.location.coordinate.latitude;
    detail.longt = manger.location.coordinate.longitude;
    detail.imageData = self.imageData;
    if (currIdOrName.length>0)
    {
        detail.classId = currIdOrName;
        [self.navigationController pushViewController:detail animated:YES];
    }
    else
    {
        [MyAlert ShowAlertMessage:@"Please select categories!" title:@""];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * markCell = @"markcell";
    UITableViewCell * cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:markCell];
    UIButton * button;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:markCell];
       // cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.borderColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0].CGColor;
        button.tag = indexPath.row;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIButtonClickEvent];
        button.frame = CGRectMake(275, 15, 20, 20);
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 10;
    }
   
    NSLog(@"1111");
    if (self.myDicStaus.count>0)
    {
        
        NSString * result1 = [self.myDicStaus valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        NSLog(@"result1 = %@",result1);
        if ([result1 isEqualToString:@"1"])
        {
            [button setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        }
        else
        {
          [button setImage:nil forState:UIControlStateNormal];
        }
    }
    [cell addSubview:button];
    [buttonArr addObject:button];
    cell.textLabel.text = [[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.textLabel.font = [UIFont fontWithName:AllFont size:AllFontSize];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.textLabel.textColor = [UIColor colorWithRed:37.0/255.0 green:197.0/255.0 blue:187.0/255.0 alpha:1.0];
    __block UIButton * tempButton;
    [cell.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]])
        {
            tempButton = (UIButton *)obj;
        }
    }];
    if (tempButton.imageView.image == nil)
    {
        [tempButton setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        currIdOrName = [[self.dataArr objectAtIndex:tempButton.tag] valueForKey:@"name"];
        NSLog(@"buttonarr = %@",buttonArr);
        [buttonArr enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL *stop) {
            [self.myDicStaus setValue:@"0" forKey:[NSString stringWithFormat:@"%d",idx]];
            if (idx != indexPath.row)
            {
                obj.imageView.image = nil;
                [self.myDicStaus setValue:@"0" forKey:[NSString stringWithFormat:@"%d",idx]];
            }
            else
            {
                [obj setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
                 [self.myDicStaus setValue:@"1" forKey:[NSString stringWithFormat:@"%d",idx]];
            }
        }];
        NSLog(@"dic = %@",self.myDicStaus);
    }
    else
    {
        tempButton.imageView.image = nil;
        currIdOrName = @"";
    }
}
-(void)buttonClick:(UITapGestureRecognizer *)gr
{
    UIButton *aButton = gr.view;
    if (aButton.imageView.image == nil)
    {
        [aButton setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        currIdOrName = [[self.dataArr objectAtIndex:aButton.tag] valueForKey:@"name"];
        [buttonArr enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL *stop) {
            [self.myDicStaus setValue:@"0" forKey:[NSString stringWithFormat:@"%d",idx]];
            if (![obj isEqual:aButton])
            {
                obj.imageView.image = nil;
                 [self.myDicStaus setValue:@"0" forKey:[NSString stringWithFormat:@"%d",idx]];
            }
            else
            {
                [obj setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
                [self.myDicStaus setValue:@"1" forKey:[NSString stringWithFormat:@"%d",idx]];
            }
        }];
    }
    else
    {
        aButton.imageView.image = nil;
        currIdOrName = @"";
    }
}

- (void)reloadTableViewDataSource
{
    _reloading = YES;
    [NSThread detachNewThreadSelector:@selector(doInBackground) toTarget:self withObject:nil];
}
////完成加载时调用的方法
- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:self.TV_tableview];
    [self.TV_tableview reloadData];
}
-(void)doInBackground
{
    if ([WebService isConnectionAvailable])
    {
        [self getData1];
    }
    [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:YES];
}
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
}

-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}

-(NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshTableView egoRefreshScrollViewDidScroll:scrollView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshTableView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
