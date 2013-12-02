//
//  WebService.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-17.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface WebService : NSObject
+(BOOL)ISIOS7;
+(BOOL)isConnectionAvailable;
+(ASIHTTPRequest *)GetTrendListLatitude:(float)aLat longitude:(float)aLong radius:(int)aRadius offset:(int)aOffset;
+(NSMutableURLRequest *)RegisterFirstName:(NSString *)aFirstname LastName:(NSString *)aLastName Email:(NSString *)aEmail password:(NSString *)aPwd andZipcode:(NSString *)aZipcode male:(NSString *)isMale;
+(NSMutableURLRequest *)LoginUserName:(NSString *)aUserName password:(NSString *)aPwd;
+(NSMutableURLRequest *)ResetPasswordEmail:(NSString *)aMail;
+(NSMutableURLRequest *)UpdateUserInfoFirstName:(NSString *)aFirstName lastName:(NSString *)aLastName email:(NSString *)aEmail password:(NSString *)aPwd zipcode:(NSString *)aZipcode gender:(NSString *)aGender birthday:(int)aBirthday;

+(ASIHTTPRequest *)SearchTrendkeywords:(NSString *)aKey latitude:(float)aLat longitude:(float)aLong category:(NSString *)aCategory;
+(ASIHTTPRequest *)GeCommentsListByID:(NSString *)aOfferID;
+(ASIHTTPRequest *)GetClasslistByLat:(float)aLat long:(float)aLong radius:(float)aRadius;
+(NSMutableURLRequest *)TurnonNotification;
+(NSMutableURLRequest *)TurnoffNotification;
+(NSMutableURLRequest *)SignOut;
+(NSMutableURLRequest *)CommentOfferOfID:(NSString *)aOfferId Content:(NSString *)aContent;
+(NSMutableURLRequest *)LikeOffer:(NSString *)aOfferId;
+(NSMutableURLRequest *)UnLikeOffer:(NSString *)aOfferId;
+(NSMutableURLRequest *)LikeFollow:(NSString *)aUserId;
+(NSMutableURLRequest *)UnLikeFollow:(NSString *)aUserId;
+(NSMutableURLRequest *)LikeStore:(NSString *)aStoreId;
+(NSMutableURLRequest *)UnLikeStore:(NSString *)aStoreId;

+(NSMutableURLRequest *)SumbitOfferImage:(NSData *)data title:(NSString *)aTitle description:(NSString *)aDesc merchant:(NSString *)aMerchant address:(NSString *)aAdress city:(NSString *)aCity state:(NSString *)aState country:(NSString *)aCountr phone:(NSString *)aPhone start:(double)aStartTime end:(double)aEndtime tags:(NSString *)aTag andDiscount:(NSString *)aDiscount andUrl:(NSString *)aUrl;

+(NSMutableURLRequest *)uploadImageData:(NSData *)aImageData;
+(NSMutableURLRequest *)MarkNotificationRead;

+(void)RegisterNotification:(NSString *)aDeviceToken;
+(ASIHTTPRequest *)OfferDetail:(NSString *)aUserID;
@end
