//
//  OslUIViewController.m
//  OnSaleLocal
//
//  Created by Kevin Zhang on 12/14/13.
//  Copyright (c) 2013 junyuan ji. All rights reserved.
//

#import "OslUIViewController.h"
#import "WebService.h"

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

- (void) likeUnlike:(id)offer :(BOOL)liked :(id)params
{
    NSNumber *num = [NSNumber numberWithBool:liked];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:offer forKey:@"offer"];
    [userInfo setValue:num forKey:@"liked"];
    if(params) {
        [userInfo setValue:params forKey:@"params"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName: @"dataChangedNotification" object:nil userInfo:userInfo];
}

- (void) followUnfollowUser:(NSString *)userId :(BOOL)follow :(id)params
{
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
@end

