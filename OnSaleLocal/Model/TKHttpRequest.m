//
//  TKHttpRequest.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-17.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "TKHttpRequest.h"
#import "ASIFormDataRequest.h"

@interface TKHttpRequest()
@end

@implementation TKHttpRequest

+(ASIHTTPRequest *)RequestHaveCacheUrl:(NSString *)aUrl
{
    NSURL *url = [NSURL URLWithString:aUrl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:MAX_SECONDS_REQUEST];//ASIAskServerIfModifiedCachePolicy,ASIAskServerIfModifiedWhenStaleCachePolicy
   [request setCacheStoragePolicy:ASIAskServerIfModifiedCachePolicy];
    [ request setNumberOfTimesToRetryOnTimeout:3]; //set times when request fail
   [request setDownloadCache:[self ShareMyCache]];
 //   [request ];
    [request setSecondsToCache:60*60*2];
    return request;
}

+(ASIHTTPRequest *)RequestNoCacheUrl:(NSString *)aUrl
{
    NSURL *url = [NSURL URLWithString:aUrl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:MAX_SECONDS_REQUEST];
    [ request setNumberOfTimesToRetryOnTimeout:2 ]; //set times when request fail
    [request setRequestMethod:@"POST"];
    return request;
}
+(ASIFormDataRequest *)FormRequestNoCacheUrl:(NSString *)aUrl
{
    NSURL *url = [NSURL URLWithString:aUrl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:MAX_SECONDS_REQUEST];
    [request setRequestMethod:@"POST"];
    return request;
}
///*
//  下面的方法要在程序启动的时候调用
// */

+(ASIDownloadCache *)ShareMyCache
{
    static ASIDownloadCache * cache;
    if (cache == nil)
    {
      ASIDownloadCache * cache = [[ASIDownloadCache alloc] init];
        //设置缓存路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        [cache setStoragePath:[documentDirectory stringByAppendingPathComponent:@"resource"]];
       // [cache setDefaultCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy]; //如果本地有缓存 无论其过期与否，都要拿来使用
    }
    return cache;
}
/*
   清除缓存
 */
+(void)ClearCache
{
    ASIDownloadCache * cacheData = [self ShareMyCache];
    [cacheData clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy]; //清空缓存。ASICachePermanentlyCacheStoragePolicy代表永久保存的缓存
}
@end
