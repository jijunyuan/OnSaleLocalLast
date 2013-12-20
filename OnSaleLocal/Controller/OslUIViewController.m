//
//  OslUIViewController.m
//  OnSaleLocal
//
//  Created by Kevin Zhang on 12/14/13.
//  Copyright (c) 2013 junyuan ji. All rights reserved.
//

#import "OslUIViewController.h"
#import "WebService.h"
#import "UIView+StringTag.h"
#import "AppDelegate.h"

@interface OslUIViewController ()

@end

@implementation OslUIViewController

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
    self.dataChangedTime = 0;
    self.appearTime = 0;
    self.disappearTime = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChangedNotificationCallback:) name:@"dataChangedNotification" object:nil];
    NSLog(@"addObserver dataChangedNotification");
}

- (void)viewDidunload
{
    NSLog(@"%@ viewDidunload called", [self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dataChanged" object:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.disappearTime = [[NSDate date] timeIntervalSince1970];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.appearTime = [[NSDate date] timeIntervalSince1970];
}

-(BOOL) isAppearing
{
    return self.appearTime > self.disappearTime;
}

-(void)dataChangedNotificationCallback:(NSNotification *)noti
{
    self.dataChangedTime = [[NSDate date] timeIntervalSince1970];
}

-(BOOL) dataChanged
{
    return self.dataChangedTime > self.disappearTime;
}

- (void) likeUnlike:(NSString *)offerId :(BOOL)liked :(id)params
{
    NSLog(@"---------- likeUnlike");
    NSNumber *num = [NSNumber numberWithBool:liked];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:offerId forKey:@"offerId"];
    [userInfo setValue:num forKey:@"liked"];
    if(params) {
        [userInfo setValue:params forKey:@"params"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName: @"dataChangedNotification" object:nil userInfo:userInfo];
    
    if(liked) {
        NSURLRequest * request = [WebService LikeOffer:offerId];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
                                   if(connectionError != nil) {
                                       NSLog(@"like offer failed");
                                       NSNumber *num = [NSNumber numberWithBool:!liked];
                                       NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:offerId forKey:@"offerId"];
                                       [userInfo setValue:num forKey:@"liked"];
                                       if(params) {
                                           [userInfo setValue:params forKey:@"params"];
                                       }
                                       [[NSNotificationCenter defaultCenter] postNotificationName: @"dataChangedNotification" object:nil userInfo:userInfo];
                                   }
                               }
         ];
    }
    else {
        NSURLRequest * request = [WebService UnLikeOffer:offerId];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
                                   if(connectionError != nil) {
                                       NSLog(@"unlike offer failed");
                                       NSNumber *num = [NSNumber numberWithBool:!liked];
                                       NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:offerId forKey:@"offerId"];
                                       [userInfo setValue:num forKey:@"liked"];
                                       if(params) {
                                           [userInfo setValue:params forKey:@"params"];
                                       }
                                       [[NSNotificationCenter defaultCenter] postNotificationName: @"dataChangedNotification" object:nil userInfo:userInfo];
                                   }
                               }
         ];
    }
}

- (void) followUnfollowUser:(NSString *)userId :(BOOL)follow :(id)params
{
    NSLog(@"---------- followUnfollowUser");
    NSNumber *num = [NSNumber numberWithBool:follow];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:userId forKey:@"userId"];
    [userInfo setValue:num forKey:@"followUser"];
    if(params) {
        [userInfo setValue:params forKey:@"params"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName: @"dataChangedNotification" object:nil userInfo:userInfo];
    
    if(follow) {
        NSURLRequest * request = [WebService LikeFollow:userId];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
                                   if(connectionError != nil) {
                                       NSLog(@"follow user failed");
                                       NSNumber *num = [NSNumber numberWithBool:!follow];
                                       NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:userId forKey:@"userId"];
                                       [userInfo setValue:num forKey:@"followUser"];
                                       if(params) {
                                           [userInfo setValue:params forKey:@"params"];
                                       }
                                       [[NSNotificationCenter defaultCenter] postNotificationName: @"dataChangedNotification" object:nil userInfo:userInfo];
                                   }
                               }
         ];
    }
    else {
        NSURLRequest * request = [WebService UnLikeFollow:userId];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
                                   if(connectionError != nil) {
                                       NSLog(@"follow user failed");
                                       NSNumber *num = [NSNumber numberWithBool:!follow];
                                       NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:userId forKey:@"userId"];
                                       [userInfo setValue:num forKey:@"followUser"];
                                       if(params) {
                                           [userInfo setValue:params forKey:@"params"];
                                       }
                                       [[NSNotificationCenter defaultCenter] postNotificationName: @"dataChangedNotification" object:nil userInfo:userInfo];
                                   }
                               }
         ];
    }
}

- (void) followUnfollowStore:(NSString *)storeId :(BOOL)follow :(id)params
{
    NSLog(@"---------- followUnfollowStore");
    NSNumber *num = [NSNumber numberWithBool:follow];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:storeId forKey:@"storeId"];
    [userInfo setValue:num forKey:@"followStore"];
    if(params) {
        [userInfo setValue:params forKey:@"params"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName: @"dataChangedNotification" object:nil userInfo:userInfo];
    
    if(follow) {
        NSURLRequest * request = [WebService LikeStore:storeId];
        [NSURLConnection sendAsynchronousRequest:request
            queue:[NSOperationQueue mainQueue]
            completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
                if(connectionError != nil) {
                    NSLog(@"follow store failed");
                    NSNumber *num = [NSNumber numberWithBool:!follow];
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:storeId forKey:@"storeId"];
                    [userInfo setValue:num forKey:@"followStore"];
                    if(params) {
                        [userInfo setValue:params forKey:@"params"];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName: @"dataChangedNotification" object:nil userInfo:userInfo];
                }
            }
         ];
    }
    else {
        NSURLRequest * request = [WebService UnLikeStore:storeId];
        [NSURLConnection sendAsynchronousRequest:request
                           queue:[NSOperationQueue mainQueue]
               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
                   if(connectionError != nil) {
                       NSLog(@"unfollow store failed");
                       NSNumber *num = [NSNumber numberWithBool:!follow];
                       NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:storeId forKey:@"storeId"];
                       [userInfo setValue:num forKey:@"followStore"];
                       if(params) {
                           [userInfo setValue:params forKey:@"params"];
                       }
                       [[NSNotificationCenter defaultCenter] postNotificationName: @"dataChangedNotification" object:nil userInfo:userInfo];
                   }
               }
         ];
    }
}

- (BOOL)isLoginUser:(NSString *)userId
{
    return [userId isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_ID]];
}

-(id) searchTableView:(UITableView *)tv forClass:(Class)cls withTag:(int)tag
{
    for (int i=0; i<1000; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: i inSection: 0];
        UIView *cell = [tv cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:cls] && cell.tag == tag){
            return (id)cell;
        }
    }
    return nil;
}

-(id) searchTableView:(UITableView *)tv forClass:(Class)cls withStringTag:(NSString *)tag
{
    for (int i=0; i<1000; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: i inSection: 0];
        UIView *cell = [tv cellForRowAtIndexPath:indexPath];
        BOOL isCls = [cell isKindOfClass:cls];
        NSString *cellTag = cell.stringTag;
        if (isCls && [tag isEqualToString:cellTag]){
            return (id)cell;
        }
    }
    return nil;
}

-(int) changeNumer:(NSDictionary *)dic diff:(int)diff forKey:(NSString *)key
{
    int number = [[dic objectForKey:key] intValue] + diff;
    [dic setValue:[NSNumber numberWithInt:number] forKey:key];
    return number;
}

-(void) setBool:(NSDictionary *)dic value:(BOOL)value forKey:(NSString *)key
{
    [dic setValue:[NSNumber numberWithBool:value] forKey:key];
}

- (void)setButtonClickAction:(SEL)action withTarget:(id)target toButton:(UIButton *)btn;
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [btn addGestureRecognizer:singleTap];
}

-(BOOL) showCenterViewControllerIfVisible:(Class)cls
{
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    if([[delegate.nav_Center visibleViewController] isKindOfClass:cls]) {
        JASidePanelController * controller = (JASidePanelController *)delegate.viewController1;
        [controller showCenterPanelAnimated:YES];
        return YES;
    }
    return NO;
}
@end

