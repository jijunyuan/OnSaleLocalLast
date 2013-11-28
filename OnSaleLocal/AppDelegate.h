//
//  AppDelegate.h
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-11.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JASidePanelController.h"
#import <FacebookSDK/FacebookSDK.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableData * reciveData;
    NSHTTPURLResponse * response1;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController * nav_all;
@property (strong, nonatomic) UINavigationController * nav_Center;
@property (strong, nonatomic) UINavigationController * nav_Left;
@property (strong, nonatomic) JASidePanelController *viewController1;
@property (strong, nonatomic) FBSession *session;
@end
