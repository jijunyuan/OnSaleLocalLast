//
//  NotificationViewController.m
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-14.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "NotificationViewController.h"
#import "TKHttpRequest.h"
#import "NotificationCell.h"
#import "EGORefreshTableHeaderView.h"
#import "SafewayViewController.h"
#import "MeRootViewController.h"
#import "TrendDetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "JASidePanelController.h"
#import "SetViewController.h"

@interface NotificationViewController ()<EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshTableView;
    BOOL _reloading;
     NSMutableArray * tempArr;
}
@property (nonatomic,strong) IBOutlet UITableView * TV_tableview;
-(void)getData1;
-(void)userImageClick:(UITapGestureRecognizer *)aTap;
-(void)ChangeNotificationStatus;
@end

@implementation NotificationViewController
@synthesize TV_tableview;
@synthesize dataArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
   
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.l_navTitle.text = @"Notification";
    
    if ([WebService ISIOS7])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
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
-(void)ChangeNotificationStatus
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest * request5 = [WebService MarkNotificationRead];
        NSData * data1 = [NSURLConnection sendSynchronousRequest:request5 returningResponse:nil error:nil];
        NSLog(@"data1 = %@",[[NSString alloc] initWithData:data1 encoding:4]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].applicationIconBadgeNumber=0;
            AppDelegate * delegate = [UIApplication sharedApplication].delegate;
            JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
            SetViewController* setViewController = (SetViewController *)controller.leftPanel;
            [setViewController viewWillAppear:YES];
        });
    });
}
-(void)getData
{
    NSString * formatStr = [NSString stringWithFormat:@"/ws/user/notifications?format=json"];
    NSString * url = [DO_MAIN stringByAppendingString:formatStr];
    NSLog(@"url = %@",url);
    __weak ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeOutSeconds:MAX_SECONDS_REQUEST];
    [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [ request setNumberOfTimesToRetryOnTimeout:3]; //set times when request fail
    [request setDownloadCache:[TKHttpRequest ShareMyCache]];
    [request setSecondsToCache:60*60*2];
    [request setUseCookiePersistence:YES];
    [request buildRequestHeaders];
    [request startAsynchronous];
    NSMutableData * reciveData1 = [NSMutableData dataWithCapacity:0];
    [request setStartedBlock:^{
        self.TV_tableview.alpha = 0.0;
        [MyActivceView startAnimatedInView2:self.view];
    }];
    [request setDataReceivedBlock:^(NSData *data) {
        [reciveData1 appendData:data];
    }];
    [request setCompletionBlock:^{
        NSLog(@"data = %@",reciveData1);
        self.TV_tableview.alpha = 1.0;
        [MyActivceView stopAnimatedInView:self.view];
        if ([request responseStatusCode] == 200)
        {
           // NSLog(@"======data = %@",[[NSString alloc] initWithData:reciveData1 encoding:1]);
            NSString * resultStr1 = [[NSString alloc] initWithData:reciveData1 encoding:1];
            self.dataArr = [[resultStr1 objectFromJSONString] valueForKey:@"items"];
            
            NSLog(@"==%@",self.dataArr);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.TV_tableview reloadData];
            });
            [self ChangeNotificationStatus];
        }
        else
        {
            //[MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData1] title:@""];
        }
    }];
    __weak typeof(self) weakSelf = self;
    [request setFailedBlock:^{
        [MyActivceView stopAnimatedInView:weakSelf.view];
        if ([request responseStatusCode] != 200)
        {
            //[MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData1] title:@""];
        }
    }];

}
-(void)getData1
{
    NSString * formatStr = [NSString stringWithFormat:@"/ws/user/notifications?format=json"];
    NSString * url = [DO_MAIN stringByAppendingString:formatStr];
    NSLog(@"url = %@",url);
    __weak ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeOutSeconds:MAX_SECONDS_REQUEST];
    [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [ request setNumberOfTimesToRetryOnTimeout:3]; //set times when request fail
    [request setDownloadCache:[TKHttpRequest ShareMyCache]];
    [request setSecondsToCache:60*60*2];
    [request setUseCookiePersistence:YES];
    [request buildRequestHeaders];
    [request startSynchronous];
    self.dataArr = nil;
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
     self.dataArr = [[[request responseData] objectFromJSONData] valueForKey:@"items"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString * str = @"cellmark";
    NotificationCell * cell = (NotificationCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil)
    {
        cell = [[NotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    NSDictionary * dic2 = [self.dataArr objectAtIndex:indexPath.row];
    NSString * isReadStr = [NSString stringWithFormat:@"%@",[dic2 valueForKey:@"unread"]];
    if ([isReadStr isEqualToString:@"1"])
    {
       // cell.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0];
      //  cell.contentView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0];
        
        UIView * bgView = [[UIView alloc] initWithFrame:cell.frame];
        bgView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0];
        cell.backgroundView = bgView;
        
    }
    if ([[dic2 valueForKey:@"type"] isEqualToString:@"FollowUser"])
    {
        [cell.IV_imageView setImageWithURL:[NSURL URLWithString:[[dic2 valueForKey:@"user"] valueForKey:@"img"]] placeholderImage:nil];
        cell.IV_imageView.layer.cornerRadius = 25;
        cell.IV_imageView.clipsToBounds = YES;
        
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageClick:)];
        cell.IV_imageView.userInteractionEnabled = YES;
        cell.IV_imageView.tag = indexPath.row;
        [cell.IV_imageView addGestureRecognizer:tap1];
    }
    else if ([[dic2 valueForKey:@"type"] isEqualToString:@"LikeOffer"])
    {
        cell.IV_imageView.layer.cornerRadius = 25;
        cell.IV_imageView.clipsToBounds = YES;
        [cell.IV_imageView setImageWithURL:[NSURL URLWithString:[[dic2 valueForKey:@"user"] valueForKey:@"img"]] placeholderImage:nil];
    }
    else
    {
        CLLocationCoordinate2D location1;
        location1.latitude = [[[dic2 valueForKey:@"store"] valueForKey:@"latitude"] floatValue];
        location1.longitude = [[[dic2 valueForKey:@"store"] valueForKey:@"longitude"] floatValue];

        MKCoordinateRegion region;
        region.center = location1;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.007;
        span.longitudeDelta = 0.007;
        region.center = location1;
        region.span = span;
        MKMapView * mapview = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [mapview setRegion:region animated:YES];
        mapview.userInteractionEnabled = NO;
        [cell.IV_imageView addSubview:mapview];
    }
   
    //cell.L_people.text = [NSString stringWithFormat:@"%@ shared",[[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"user"] valueForKey:@"firstName"]];
    NSDateFormatter  * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:([[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"created"] floatValue]/1000)];
    NSString * dateStr = [formatter stringFromDate:date];
    cell.L_time.text = dateStr;
    cell.L_name.text = [[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"alert"];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic2 = [self.dataArr objectAtIndex:indexPath.row];
    NSLog(@"dic2 = %@",dic2);
    if ([[dic2 valueForKey:@"type"] isEqualToString:@"FollowUser"])
    {
        MeRootViewController * me;
        if (iPhone5)
        {
            me = [[MeRootViewController alloc] initWithNibName:@"MeRootViewController" bundle:nil];
        }
        else
        {
            me = [[MeRootViewController alloc] initWithNibName:@"MeRootViewController4" bundle:nil];
        }
        me.userid = [dic2 valueForKey:@"param"];
        [self.navigationController pushViewController:me animated:YES];
    }
    else if ([[dic2 valueForKey:@"type"] isEqualToString:@"LikeOffer"])
    {
        TrendDetailViewController * trend;
        if (iPhone5)
        {
            trend = [[TrendDetailViewController alloc] initWithNibName:@"TrendDetailViewController" bundle:nil];
        }
        else
        {
            trend = [[TrendDetailViewController alloc] initWithNibName:@"TrendDetailViewController4" bundle:nil];
        }
        trend.dic = [dic2 valueForKey:@"offer"];
        [self.navigationController pushViewController:trend animated:YES];
    }
    else
    {
        SafewayViewController * safe;
        if (iPhone5)
        {
            safe = [[SafewayViewController alloc] initWithNibName:@"SafewayViewController" bundle:nil];
        }
        else
        {
            safe = [[SafewayViewController alloc] initWithNibName:@"SafewayViewController4" bundle:nil];
        }
        safe.merchanName = [[dic2 valueForKey:@"store"] valueForKey:@"name"];
        safe.merchantId = [[dic2 valueForKey:@"store"] valueForKey:@"id"];
        [self.navigationController pushViewController:safe animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
-(void)userImageClick:(UITapGestureRecognizer *)aTap
{
    UIImageView * userimage = (UIImageView *)[aTap view];
    NSDictionary * dic2 = [self.dataArr objectAtIndex:userimage.tag];
    MeRootViewController * me;
    if (iPhone5)
    {
        me = [[MeRootViewController alloc] initWithNibName:@"MeRootViewController" bundle:nil];
    }
    else
    {
        me = [[MeRootViewController alloc] initWithNibName:@"MeRootViewController4" bundle:nil];
    }
    me.userid = [[dic2 valueForKey:@"user"] valueForKey:@"id"];
    [self.navigationController pushViewController:me animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
