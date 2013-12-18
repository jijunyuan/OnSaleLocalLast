//
//  MeViewController.m
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-14.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "MeViewController.h"
#import "MeListCell.h"
#import "TKHttpRequest.h"
#import "MeRootViewController.h"
#import "FollowsCell.h"

@interface MeViewController ()<UITableViewDelegate>
{
   
}
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong) IBOutlet UITableView * TV_tableView;
@end

@implementation MeViewController
@synthesize dataArr,TV_tableView;
@synthesize userId;

@synthesize meRootController;


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
    
    
    if (self.isFollowing)
    {
        self.l_navTitle.font = [UIFont fontWithName:AllFontBold size:All_h2_size];
    self.l_navTitle.text = @"Followings";
    }
    else
    {
        self.l_navTitle.font = [UIFont fontWithName:AllFontBold size:All_h2_size];
    self.l_navTitle.text = @"Followers";
    }
    
}

-(void)getData
{
    NSString * formatStr;
    if (self.isFollowing)
    {
        formatStr = [NSString stringWithFormat:@"/ws/v2/user/followings?userId=%@&format=json",self.userId];
    }
    else
    {
        formatStr = [NSString stringWithFormat:@"/ws/v2/user/followers?userId=%@&format=json",self.userId];
    }
    NSString * url = [DO_MAIN stringByAppendingString:formatStr];
    NSLog(@"url = %@",url);
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeOutSeconds:MAX_SECONDS_REQUEST];
    [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [ request setNumberOfTimesToRetryOnTimeout:3]; //set times when request fail
    [request setDownloadCache:[TKHttpRequest ShareMyCache]];
    [request setSecondsToCache:60*60*2];
    [request buildRequestHeaders];
    NSMutableData * reciveData = [NSMutableData dataWithCapacity:0];
    [request setStartedBlock:^{
        [MyActivceView startAnimatedInView2:self.view];
        self.myTableView.alpha = 0.0;
        self.dataArr= [NSMutableArray arrayWithCapacity:0];
    }];
    [request setDataReceivedBlock:^(NSData *data) {
        [reciveData appendData:data];
    }];
    [request setCompletionBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        self.myTableView.alpha = 1.0;
        if ([request responseStatusCode] == 200)
        {
            NSMutableArray * arr = [[reciveData objectFromJSONData] valueForKey:@"items"];
            NSLog(@"arr = %@",arr);
            [arr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:[obj valueForKey:@"user"]];
                if (self.isFollowing)
                {
                    [dic setObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"myFollowing"]] forKey:@"myFollowing"];
                }
                else
                {
                    [dic setObject:[NSString stringWithFormat:@"%d",[[obj valueForKey:@"myFollowing"] intValue]] forKey:@"myFollowing"];
                }
                [self.dataArr addObject:dic];
            }];
            [self.myTableView reloadData];
        }
        else
        {
           // [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData] title:@""];
        }
    }];
    
    [request setFailedBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        if ([request responseStatusCode] != 200)
        {
          //  [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData] title:@""];
        }
    }];
    [request startAsynchronous];
}
-(void)getdata1
{
    NSString * formatStr;
    if (self.isFollowing)
    {
        formatStr = [NSString stringWithFormat:@"/ws/v2/user/followings?userId=%@&format=json",self.userId];
    }
    else
    {
        formatStr = [NSString stringWithFormat:@"/ws/v2/user/followers?userId=%@&format=json",self.userId];
    }
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
    [request startSynchronous];
    NSMutableArray * arr = [[[request responseData] objectFromJSONData] valueForKey:@"items"];
    self.dataArr = nil;
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    [arr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:[obj valueForKey:@"user"]];
        if (self.isFollowing)
        {
            
            [dic setObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"myFollowing"]] forKey:@"myFollower"];
            // [dic setObject:@"1" forKey:@"myFollower"];
        }
        else
        {
            [dic setObject:[NSString stringWithFormat:@"%d",[[obj valueForKey:@"myFollowing"] intValue]] forKey:@"myFollower"];
        }
        NSLog(@"self.dataArr = %@",self.dataArr);
        [self.dataArr addObject:dic];
    }];
    [self.myTableView reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [self.dataArr objectAtIndex:indexPath.row];
    NSString * userid = [dic valueForKey:@"id"];
    MeRootViewController * me;
    if (iPhone5)
    {
        me = [[MeRootViewController alloc] initWithNibName:@"MeRootViewController" bundle:nil];
    }
    else
    {
        me = [[MeRootViewController alloc] initWithNibName:@"MeRootViewController4" bundle:nil];
    }
    me.userid = userid;
    [self.navigationController pushViewController:me animated:YES];
}
-(void)photoClick:(UITapGestureRecognizer *)aTap
{
    UIImageView * imageView = (UIImageView *)[aTap view];
    NSDictionary * dic = [self.dataArr objectAtIndex:imageView.tag];
    NSString * userid = [dic valueForKey:@"id"];
    MeRootViewController * me;
    if (iPhone5)
    {
        me = [[MeRootViewController alloc] initWithNibName:@"MeRootViewController" bundle:nil];
    }
    else
    {
        me = [[MeRootViewController alloc] initWithNibName:@"MeRootViewController4" bundle:nil];
    }
    me.userid = userid;
    [self.navigationController pushViewController:me animated:YES];
}
-(void)didFinishReciveData
{
}
-(void)backClick:(UIButton *)aButton
{
//    if (self.isFollowing)
//    {
//        self.meRootController.followingLabNum = [NSString stringWithFormat:@"%@ followings",[NSString stringWithFormat:@"%d",self.dataArr.count]];
//    }
//    else
//    {
//        self.meRootController.followNumLabNum = [NSString stringWithFormat:@"%@ follows",[NSString stringWithFormat:@"%d",self.dataArr.count]];
//        self.meRootController.followingLabNum = [NSString stringWithFormat:@"%@ followings",[NSString stringWithFormat:@"%d",self.currFollowings]];
//    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dataChangedNotificationCallback:(NSNotification *)noti
{
    [super dataChangedNotificationCallback:noti];
    NSDictionary *userInfo = noti.userInfo;
    
    NSNumber *liked = [userInfo objectForKey:@"liked"];
    if(liked) {
        NSString * likedOfferId = [[userInfo objectForKey:@"offer"] objectForKey:@"id"];
    }
    
    NSNumber *followUser = [userInfo objectForKey:@"followUser"];
    if(followUser) {
        NSString * userId = [userInfo objectForKey:@"userId"];
        [self changeUserFollowState:userId followed:[followUser boolValue]];
    }
    
    NSNumber *followStore = [userInfo objectForKey:@"followStore"];
    if(followStore) {
        NSString * storeId = [userInfo objectForKey:@"storeId"];
    }
}

- (void)changeUserFollowState:(NSString *)userId followed:(BOOL)followed
{
    for(int i=0; i<[self.dataArr count]; i++) {
        NSDictionary *dic = [self.dataArr objectAtIndex:i];
        if([userId isEqualToString:[dic objectForKey:@"id"]]) {
            NSMutableDictionary *newdic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [newdic setObject:[NSNumber numberWithBool:followed] forKey:@"myFollowings"];
            [self changeNumer:dic diff:(followed ? 1 : -1) forKey:@"followers"];
            [self.dataArr replaceObjectAtIndex:i withObject:newdic];
        }
        if([self isLoginUser:[dic objectForKey:@"id"]]) {
            NSMutableDictionary *newdic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [self changeNumer:dic diff:(followed ? 1 : -1) forKey:@"followings"];
            [self.dataArr replaceObjectAtIndex:i withObject:newdic];
        }
    }
    
    FollowsCell *cell = [self searchTableView:self.myTableView forClass:[FollowsCell class] withStringTag:userId];
    if(cell) {
        if(followed) {
            [cell.Btn_follow setImage:[UIImage imageNamed:@"followed.png"] forState:UIControlStateNormal];
        }
        else {
            [cell.Btn_follow setImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
        }
    }
}
@end
