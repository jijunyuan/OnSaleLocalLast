//
//  Globle.h
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-11.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//



#ifndef OnSaleLocal_Globle_h
#define OnSaleLocal_Globle_h

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad?YES:NO)

#define MAX_SECONDS_REQUEST 15.0

#define CURRENT_LOCATION_ANNOTATION @"CurrentLocation1234"

#import "MyActivceView.h"
#import "ASIHTTPRequest.h"
#import "DataBase.h"
#import "WebService.h"
#import "MyAlert.h"
#import "JSONKit.h"
#import "NSString+JsonString.h"
#import "UIImageView+WebCache.h"


#define DO_MAIN @"http://onsalelocal.com/osl2"

#define APP_ID @"com.gaoshin.shopplus"
#define UM_APP_KEY @"524a2a4356240b850b0d71bd"


#define LOGIN_FIRST_NAME @"firstName"
#define LOGIN_LAST_NAME @"lastName"
#define LOGIN_BIRTHYEAR @"birthYear"
#define LOGIN_CREATED @"created"
#define LOGIN_GENDER @"gender"
#define LOGIN_ID @"id"
#define LOGIN_LOGIN @"login"
#define LOGIN_NOTI @"noti"
#define LOGIN_PASSWORD @"password"
#define LOGIN_UPDATED @"updated"
#define LOGIN_ZIPCODE @"zipcode"
#define LOGIN_STATUS @"loginstatus"
#define LOGIN_IMAGE @"login_image"
#define LOGIN_NOTIFICATION @"notifications_login"

#define USING_LAT @"using_lat"
#define USING_LONG @"using_long"

#define CURR_LAT @"lat_curr"
#define CURR_LONG @"long_curr"   


#define FBSessionStateChangedNotification @"FBSessionStateChangedNotification"
#define FB_LOGIN_SUCCESS @"FB_LOGIN_SUCCESS"
#define FB_ACCESS_TOKEN @"FB_ACCESS_TOKEN"

#define IS_CURR_LOCATION @"curr_location"
#define DEVIVE_TOKEN @"devicetoken"

#define AllFont @"Gotham"
#define AllFontSize ceil(17.0*1.2)
#define AllContentSize ceil(14.0*1.2)
#define AllContentSmallSize 10.0

#endif
