//
//  CategoriesViewController.m
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-14.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "CategoriesViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "TKHttpRequest.h"
#import "EGORefreshTableHeaderView.h"
#import "CategoriesDetailViewController.h"
#import "SearchViewController.h"

@interface CategoriesViewController ()<CLLocationManagerDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate>
{
    CLLocationManager * manger;
    EGORefreshTableHeaderView *_refreshTableView;
    BOOL _reloading;
}
////开始重新加载时调用的方法
- (void)reloadTableViewDataSource;
////完成加载时调用的方法
- (void)doneLoadingTableViewData;
@property (nonatomic,strong) IBOutlet UITableView * myTableView;
@property (nonatomic,strong) NSMutableArray * dataArr;
-(void)getData;
-(void)getData1;
@end

@implementation CategoriesViewController
@synthesize myTableView;
@synthesize dataArr;

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
    
    self.myTableView.tableFooterView = [[UIView alloc] init];
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    self.l_navTitle.text = @"Categories";
    
    if (_refreshTableView == nil)
    {
        //初始化下拉刷新控件
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.myTableView.bounds.size.height, self.view.frame.size.width, self.myTableView.bounds.size.height)];
        refreshView.delegate = self;
        //将下拉刷新控件作为子控件添加到UITableView中
        [self.myTableView addSubview:refreshView];
        _refreshTableView = refreshView;
    }

    if ([WebService isConnectionAvailable])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getData];
        });
    }

}
-(void)getData
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
    float longit = manger.location.coordinate.longitude;    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:IS_CURR_LOCATION] isEqualToString:@"0"])
    {
        lat = [[user valueForKey:USING_LAT] floatValue];
        longit = [[user valueForKey:USING_LONG] floatValue];
    }

//#warning mark - change value
    ////test 37.378536   -122.086586
    // ASIHTTPRequest * request = [WebService GetClasslistByLat:37.378536 long:-122.086586 radius:10.0];
    NSString * formatStr = [NSString stringWithFormat:@"%@/ws/category/top-categories?lat=%f&lng=%f&radius=%f&format=json",DO_MAIN,lat,longit,10.0];
    __weak ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:formatStr]];
    [request setTimeOutSeconds:MAX_SECONDS_REQUEST];
    [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [ request setNumberOfTimesToRetryOnTimeout:3]; //set times when request fail
    [request setDownloadCache:[TKHttpRequest ShareMyCache]];
    [request setSecondsToCache:60*60*2];
    [request setUseCookiePersistence:YES];
    [request buildRequestHeaders];
    [request startAsynchronous];
    __block NSMutableData * reciveData = [NSMutableData dataWithCapacity:0];
    [request setStartedBlock:^{
        self.myTableView.hidden = YES;
        [MyActivceView startAnimatedInView2:self.view];
    }];
    [request setDataReceivedBlock:^(NSData *data) {
        [reciveData appendData:data];
    }];
    [request setCompletionBlock:^{
       [MyActivceView stopAnimatedInView:self.view];
        if (request.responseStatusCode == 200)
        {
            self.dataArr = [[reciveData objectFromJSONData] valueForKey:@"items"];
            self.myTableView.hidden = NO;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView reloadData];
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
    float longit = manger.location.coordinate.longitude;    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:IS_CURR_LOCATION] isEqualToString:@"0"])
    {
        lat = [[user valueForKey:USING_LAT] floatValue];
        longit = [[user valueForKey:USING_LONG] floatValue];
    }

//#warning mark - change value
    NSString * formatStr = [NSString stringWithFormat:@"%@/ws/category/top-categories?lat=%f&lng=%f&radius=%f&format=json",DO_MAIN,lat,longit,10.0];
     ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:formatStr]];
    [request setTimeOutSeconds:MAX_SECONDS_REQUEST];
    [request setUseCookiePersistence:YES];
    [request buildRequestHeaders];
    [request startSynchronous];
    self.dataArr = [[request.responseData objectFromJSONData] valueForKey:@"items"];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    manger = manager;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * idStr = @"mark";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:idStr];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idStr];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.textLabel.textColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0];
    cell.textLabel.font = [UIFont fontWithName:AllFont size:AllContentSize];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoriesDetailViewController * categories;
    if (iPhone5)
    {
        categories = [[CategoriesDetailViewController alloc] initWithNibName:@"CategoriesDetailViewController" bundle:nil];
    }
    else
    {
       categories = [[CategoriesDetailViewController alloc] initWithNibName:@"CategoriesDetailViewController4" bundle:nil];
    }
    categories.key = [[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"name"];
    [self.navigationController pushViewController:categories animated:YES];
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
    [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
    [self.myTableView reloadData];
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
