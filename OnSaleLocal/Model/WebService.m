//
//  WebService.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-17.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//



#import "WebService.h"
#import "TKHttpRequest.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#define SR_POST_BOUNDARY @"--gc0p4Jq0M2Yt08jU534c0p"




@interface WebService()
+(NSData *)HTTPPOSTMultipartBodyWithParameters:(NSDictionary *)parameters andRequest:(NSURLRequest *)aRequest;
+(void)addMultiPartData:(NSData *)data withName:(NSString *)name type:(NSString *)type filename:(NSString *)filename andReuest:(NSMutableURLRequest *)request;
@end

@implementation WebService

+(BOOL)ISIOS7
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    if (_deviceSystemMajorVersion >= 7)
    {
        return YES;
    }
    return NO;
}


+(ASIHTTPRequest *)OfferDetail:(NSString *)aUserID
{
    NSString * formatStr = [NSString stringWithFormat:@"/ws/v2/offer/details?offerId=%@&format=json",aUserID];
    NSString * url = [DO_MAIN stringByAppendingString:formatStr];
    ASIHTTPRequest * request = [TKHttpRequest RequestHaveCacheUrl:url];
    return request;
}

+(BOOL)isConnectionAvailable
{
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.google.com"];
    switch ([reach currentReachabilityStatus])
    {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
    }
//    if (!isExistenceNetwork)
//    {
//        [MyAlert ShowAlertMessage:@"No network connection" title:@""];
//    }
    return isExistenceNetwork;
}
+(ASIHTTPRequest *)GetTrendListLatitude:(float)aLat longitude:(float)aLong radius:(int)aRadius offset:(int)aOffset
{
    NSString * formatStr = [NSString stringWithFormat:@"/ws/v2/trend?latitude=%f&longitude=%f&radius=%d&offset=%d&size=20&category=&offer=1&format=json",aLat,aLong,aRadius,aOffset];
    NSString * url = [DO_MAIN stringByAppendingString:formatStr];
    NSString *encodedValue = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"usl = %@",encodedValue);
    ASIHTTPRequest * request = [TKHttpRequest RequestHaveCacheUrl:encodedValue];
    return request;
}
+(NSMutableURLRequest *)RegisterFirstName:(NSString *)aFirstname LastName:(NSString *)aLastName Email:(NSString *)aEmail password:(NSString *)aPwd andZipcode:(NSString *)aZipcode male:(NSString *)isMale
{
    NSDictionary* d = @{@"firstName":@"firstName",
                        @"lastName":@"lastName",
                        @"password":@"password",
                        @"login":@"email@email.com",
                        @"zipcode":@"12345"};
    NSString * url = [NSString stringWithFormat:@"%@/ws/user/register",DO_MAIN];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    NSUUID* uuid = [[UIDevice currentDevice]identifierForVendor];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString* userID = d[@"email"];
    NSString *header = [NSString stringWithFormat:@"ios;%@;%@;%@;%f;%f;%ld",[uuid UUIDString], version, userID,0.0, 0.0, (long)[[NSDate date]timeIntervalSince1970]];
    NSString * str1 = [NSString stringWithFormat:@"{\"firstName\":\"%@\",\"lastName\":\"%@\",\"password\":\"%@\",\"login\":\"%@\",\"zipcode\":\"%@\",\"gender\":\"%@\"}",aFirstname,aLastName,aPwd,aEmail,aZipcode,isMale];
    NSLog(@"str1 %@",str1);
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [str1 dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:header forHTTPHeaderField:@"Reqid"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPShouldHandleCookies:YES];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [[str1 dataUsingEncoding:NSUTF8StringEncoding] length]];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setTimeoutInterval:MAX_SECONDS_REQUEST];
    return request;
}
+(NSMutableURLRequest *)LoginUserName:(NSString *)aUserName password:(NSString *)aPwd
{
    NSString * url = [NSString stringWithFormat:@"%@/ws/user/login",DO_MAIN];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    //NSUUID* uuid = [[UIDevice currentDevice]identifierForVendor];
    NSUUID * uuid = [[NSUUID alloc] initWithUUIDString:@"20132546589"];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    // NSString* userID = [[NSUserDefaults standardUserDefaults]objectForKey:USER_EMAIL];
    NSString *header = [NSString stringWithFormat:@"ios;%@;%@;%@;%f;%f;%ld",[uuid UUIDString], version, aUserName,0.0, 0.0, (long)[[NSDate date]timeIntervalSince1970]];
    
    NSString * s = [NSString stringWithFormat:@"{\"password\":\"%@\",\"login\":\"%@\"}",aPwd,aUserName];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [s dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:header forHTTPHeaderField:@"Reqid"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPShouldHandleCookies:YES];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [[s dataUsingEncoding:NSUTF8StringEncoding] length]];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setTimeoutInterval:MAX_SECONDS_REQUEST];
    return request;
}
+(NSMutableURLRequest *)ResetPasswordEmail:(NSString *)aMail
{
    NSString * url = [NSString stringWithFormat:@"%@/ws/user/reset-password/%@",DO_MAIN,aMail];
    NSString *properlyEscapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"usl = %@",url);
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:properlyEscapedURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"" forHTTPHeaderField:@"Reqid"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPShouldHandleCookies:YES];
    [request setTimeoutInterval:MAX_SECONDS_REQUEST];
    return request;
}
+(NSMutableURLRequest *)UpdateUserInfoFirstName:(NSString *)aFirstName lastName:(NSString *)aLastName email:(NSString *)aEmail password:(NSString *)aPwd zipcode:(NSString *)aZipcode gender:(NSString *)aGender birthday:(int)aBirthday
{
    NSString * url = [NSString stringWithFormat:@"%@/ws/user/update",DO_MAIN];
    NSString *properlyEscapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"usl = %@",url);
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:properlyEscapedURL]];
    NSString * s = [NSString stringWithFormat:@"{\"firstName\":\"%@\",\"lastName\":\"%@\",\"login\":\"%@\",\"birthYear\":%d,\"gender\":\"%@\",\"zipcode\":\"%@\",\"password\":\"%@\"}",aFirstName,aLastName,aEmail,aBirthday,aGender,aZipcode,aPwd];
    
    NSLog(@"s = %@",s);
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [s dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPShouldHandleCookies:YES];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [[s dataUsingEncoding:NSUTF8StringEncoding] length]];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setTimeoutInterval:MAX_SECONDS_REQUEST];
    return request;
}
+(ASIHTTPRequest *)SearchTrendkeywords:(NSString *)aKey latitude:(float)aLat longitude:(float)aLong category:(NSString *)aCategory
{
    NSString * formatStr = [NSString stringWithFormat:@"/ws/v2/search?latitude=%f&longitude=%f&radius=10&offset=0&size=20&category=%@&keywords=%@&format=json",aLat,aLong,aCategory,aKey];
    NSString * url = [DO_MAIN stringByAppendingString:formatStr];
    ASIHTTPRequest * request = [TKHttpRequest RequestHaveCacheUrl:url];
    return request;
}
+(ASIHTTPRequest *)GeCommentsListByID:(NSString *)aOfferID
{
    NSString * formatStr = [NSString stringWithFormat:@"/ws/v2/offer/comments?offerId=%@&format=json",aOfferID];
    NSString * url = [DO_MAIN stringByAppendingString:formatStr];
    ASIHTTPRequest * request = [TKHttpRequest RequestHaveCacheUrl:url];
    return request;
}
+(ASIHTTPRequest *)GetClasslistByLat:(float)aLat long:(float)aLong radius:(float)aRadius
{
    NSString * formatStr = [NSString stringWithFormat:@"%@/ws/category/top-categories?lat=%f&lng=%f&radius=%f&format=json",DO_MAIN,aLat,aLong,aRadius];
    NSString *properlyEscapedURL = [formatStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"properlyEscapedURL = %@",properlyEscapedURL);
    ASIHTTPRequest * request = [TKHttpRequest RequestHaveCacheUrl:properlyEscapedURL];
    return request;
}
+(NSMutableURLRequest *)TurnonNotification
{
    NSString * url = [NSString stringWithFormat:@"%@/ws/user/notification/enable",DO_MAIN];
    NSString *properlyEscapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"usl = %@",url);
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:properlyEscapedURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"" forHTTPHeaderField:@"Reqid"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPShouldHandleCookies:YES];
    [request setTimeoutInterval:MAX_SECONDS_REQUEST];
    return request;
}
+(NSMutableURLRequest *)TurnoffNotification
{
    NSString * url = [NSString stringWithFormat:@"%@/ws/user/notification/disable",DO_MAIN];
    NSString *properlyEscapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"usl = %@",url);
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:properlyEscapedURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"" forHTTPHeaderField:@"Reqid"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPShouldHandleCookies:YES];
    [request setTimeoutInterval:MAX_SECONDS_REQUEST];
    return request;
}
+(NSMutableURLRequest *)SignOut  ///ws/v2/offer/comment
{
    NSString * url = [NSString stringWithFormat:@"%@/ws/user/logout",DO_MAIN];
    NSString *properlyEscapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"usl = %@",url);
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:properlyEscapedURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"" forHTTPHeaderField:@"Reqid"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPShouldHandleCookies:YES];
    [request setTimeoutInterval:MAX_SECONDS_REQUEST];
    return request;
}
+(NSMutableURLRequest *)CommentOfferOfID:(NSString *)aOfferId Content:(NSString *)aContent
{
    NSString * url = [NSString stringWithFormat:@"%@/ws/v2/offer/comment",DO_MAIN];
    NSString *properlyEscapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"usl = %@",url);
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:properlyEscapedURL]];
    NSString * s = [NSString stringWithFormat:@"{\"offerId\":\"%@\",\"content\":\"%@\"}",aOfferId,aContent];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [s dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPShouldHandleCookies:YES];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [[s dataUsingEncoding:NSUTF8StringEncoding] length]];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setTimeoutInterval:MAX_SECONDS_REQUEST];
    return request;
}
+(NSMutableURLRequest *)LikeOffer:(NSString *)aOfferId
{
    NSString * url = [NSString stringWithFormat:@"%@/ws/v2/offer/like/%@",DO_MAIN,aOfferId];
    NSString *properlyEscapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"usl = %@",url);
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:properlyEscapedURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPShouldHandleCookies:YES];
    [request setTimeoutInterval:MAX_SECONDS_REQUEST];
    return request;
}
+(NSMutableURLRequest *)UnLikeOffer:(NSString *)aOfferId
{
    NSString * url = [NSString stringWithFormat:@"%@/ws/v2/offer/unlike/%@",DO_MAIN,aOfferId];
    NSString *properlyEscapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"usl = %@",url);
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:properlyEscapedURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPShouldHandleCookies:YES];
    [request setTimeoutInterval:MAX_SECONDS_REQUEST];
    return request;
}
+(NSMutableURLRequest *)LikeFollow:(NSString *)aUserId
{
    NSString * url = [NSString stringWithFormat:@"%@/ws/v2/user/follow/%@",DO_MAIN,aUserId];
    NSString *properlyEscapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"usl = %@",url);
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:properlyEscapedURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPShouldHandleCookies:YES];
    [request setTimeoutInterval:MAX_SECONDS_REQUEST];
    return request;
}
+(NSMutableURLRequest *)UnLikeFollow:(NSString *)aUserId
{
    NSString * url = [NSString stringWithFormat:@"%@/ws/v2/user/unfollow/%@",DO_MAIN,aUserId];
    NSString *properlyEscapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"usl = %@",url);
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:properlyEscapedURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPShouldHandleCookies:YES];
    [request setTimeoutInterval:MAX_SECONDS_REQUEST];
    return request;
}
+(NSMutableURLRequest *)LikeStore:(NSString *)aStoreId
{
    NSString * url = [NSString stringWithFormat:@"%@/ws/v2/store/follow/%@",DO_MAIN,aStoreId];
    NSString *properlyEscapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"usl = %@",url);
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:properlyEscapedURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPShouldHandleCookies:YES];
    [request setTimeoutInterval:MAX_SECONDS_REQUEST];
    return request;
}
+(NSMutableURLRequest *)UnLikeStore:(NSString *)aStoreId
{
    NSString * url = [NSString stringWithFormat:@"%@/ws/v2/store/unfollow/%@",DO_MAIN,aStoreId];
    NSString *properlyEscapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"usl = %@",url);
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:properlyEscapedURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPShouldHandleCookies:YES];
    [request setTimeoutInterval:MAX_SECONDS_REQUEST];
    return request;
}


+(NSMutableURLRequest *)SumbitOfferImage:(NSData *)data title:(NSString *)aTitle description:(NSString *)aDesc merchant:(NSString *)aMerchant address:(NSString *)aAdress city:(NSString *)aCity state:(NSString *)aState country:(NSString *)aCountr phone:(NSString *)aPhone start:(double)aStartTime end:(double)aEndtime tags:(NSString *)aTag andDiscount:(NSString *)aDiscount andUrl:(NSString *)aUrl
{
    NSString * url = [NSString stringWithFormat:@"%@/ws/v2/offer",DO_MAIN];
    NSString *properlyEscapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"usl = %@",url);
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:properlyEscapedURL]];
    
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"YOUR_BOUNDARY_STRING";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@.jpg\"\r\n", @"whatever"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:data]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"address\"\r\n\r\n%@", aAdress] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"city\"\r\n\r\n%@", aCity] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"state\"\r\n\r\n%@", aState] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"country\"\r\n\r\n%@", aCountr] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"title\"\r\n\r\n%@", aTitle] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"price\"\r\n\r\n%@", aState] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"discount\"\r\n\r\n%@", aDiscount] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"merchant\"\r\n\r\n%@", aMerchant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"phone\"\r\n\r\n%@",aDiscount] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"latitude\"\r\n\r\n%@", @""] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"longitude\"\r\n\r\n%@",@""] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tags\"\r\n\r\n%@", aTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user\"\r\n\r\n%@", [[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_ID]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"url\"\r\n\r\n%@", aUrl] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [request setHTTPBody:body];
    [request setHTTPShouldHandleCookies:YES];
   // [request setUseCookiePersistence:YES];
    //[request buildRequestHeaders];
    
    [request setTimeoutInterval:MAX_SECONDS_REQUEST];
    
    return request;
}


+(NSData *)HTTPPOSTMultipartBodyWithParameters:(NSDictionary *)parameters andRequest:(NSURLRequest *)aRequest
{
    NSMutableData *body = [NSMutableData data];
    
    // Add Body Prefix String
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",SR_POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Add Main Body
    for (NSString *key in [parameters allKeys])
    {
        id value = [parameters objectForKey:key];
        if ([value isKindOfClass:[NSString class]]&&[value isKindOfClass:[NSNumber class]])
        {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",key,value]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n",SR_POST_BOUNDARY]dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
            //NSLog(@"please use addMultiPartData:withName:type:filename: Methods to implement");
            NSData * data = UIImagePNGRepresentation(value);
            [self addMultiPartData:data withName:key type:@"Image" filename:key andReuest:(NSMutableURLRequest *)aRequest];
        }
    }
    NSLog(@"body = %@",[[NSString alloc] initWithData:body encoding:4]);
    return body;
}
+(void)addMultiPartData:(NSData *)data withName:(NSString *)name type:(NSString *)type filename:(NSString *)filename andReuest:(NSMutableURLRequest *)request
{
    
    NSMutableData *body = (NSMutableData *)[request HTTPBody];
    // Step 1
    NSString *disposition = [[NSString alloc] init];
    if (!filename)
    {
        disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, filename];
    }
    else
    {
        disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, name];
    }
    [body appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
    // Step 2
    NSString *contentType = [NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",type];
    [body appendData:[contentType dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Step 3
    [body appendData:data];
    
    // Step 4 Add suffix boundary
    NSString *boundary = [NSString stringWithFormat:@"\r\n--%@--\r\n",SR_POST_BOUNDARY];
    [body appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:body];
}
+(NSMutableURLRequest *)uploadImageData:(NSData *)aImageData
{
    NSString * url = [NSString stringWithFormat:@"%@/ws/user/avatar",DO_MAIN];
    NSString *properlyEscapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"usl = %@",url);
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:properlyEscapedURL]];
    
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"YOUR_BOUNDARY_STRING";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSMutableData *body = [NSMutableData dataWithCapacity:0];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"imagename = %@",[NSString stringWithFormat:@"%@",[NSDate date]]);
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@.jpg\"\r\n", [NSString stringWithFormat:@"%@",[NSDate date]]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:aImageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"body = %@=====bodystr = %@",body,[[NSString alloc] initWithData:body encoding:4]);
    [request setHTTPBody:body];
    [request setHTTPShouldHandleCookies:YES];
    [request setTimeoutInterval:MAX_SECONDS_REQUEST];
    return request;
}
+(NSMutableURLRequest *)MarkNotificationRead
{
    NSString * url = [NSString stringWithFormat:@"%@/ws/user/notifications/mark-all-read",DO_MAIN];
    NSString *properlyEscapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"usl = %@",url);
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:properlyEscapedURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPShouldHandleCookies:YES];
    [request setTimeoutInterval:MAX_SECONDS_REQUEST];
    return request;
}
+(void)RegisterNotification:(NSString *)aDeviceToken
{
  //  NSString *tokeStr = [NSString stringWithFormat:@"%@",aDeviceToken];
    if ([aDeviceToken length] == 0)
    {
        return;
    }
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
    aDeviceToken = [aDeviceToken stringByTrimmingCharactersInSet:set];
    aDeviceToken = [aDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *strURL = [NSString stringWithFormat:@"%@/ws/user/register-ios-pn-id/%@",DO_MAIN,aDeviceToken];
    NSString *properlyEscapedURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"usl = %@",properlyEscapedURL);
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:properlyEscapedURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"" forHTTPHeaderField:@"Reqid"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPShouldHandleCookies:YES];
    [request setTimeoutInterval:MAX_SECONDS_REQUEST];
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
   // application.applicationIconBadgeNumber = 1;
    NSLog(@"notification  data = %@ ",[[NSString alloc] initWithData:data encoding:4]);

}
@end
