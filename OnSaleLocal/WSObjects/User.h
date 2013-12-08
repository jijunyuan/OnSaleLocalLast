//
//  User.h
//  OnSaleLocal
//
//  Created by Kevin Zhang on 12/8/13.
//  Copyright (c) 2013 junyuan ji. All rights reserved.
//

#import "WSObject.h"

@interface User : WSObject

@property (nonatomic, assign) NSInteger notifications;
@property (nonatomic, assign) NSInteger followers;
@property (nonatomic, assign) NSInteger followings;
@property (nonatomic, assign) NSInteger offers;
@property (nonatomic, assign) BOOL myFollower;
@property (nonatomic, assign) BOOL myFollowing;
@property (nonatomic, assign) NSInteger likes;
@property (nonatomic, assign) NSInteger stores;
@property (nonatomic, retain) NSString* status;
@property (nonatomic, retain) NSString* login;
@property (nonatomic, retain) NSString* zipcode;
@property (nonatomic, retain) NSString* firstName;
@property (nonatomic, retain) NSString* lastName;
@property (nonatomic, retain) NSString* tempPassword;
@property (nonatomic, assign) NSInteger birthYear;
@property (nonatomic, retain) NSString* gender;
@property (nonatomic, retain) NSString* img;
@property (nonatomic, retain) NSString* noti;
@property (nonatomic, retain) NSString* id;
@property (nonatomic, assign) long created;
@property (nonatomic, assign) long updated;

@end
