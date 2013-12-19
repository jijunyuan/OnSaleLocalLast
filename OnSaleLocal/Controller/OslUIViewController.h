//
//  OslUIViewController.h
//  OnSaleLocal
//
//  Created by Kevin Zhang on 12/14/13.
//  Copyright (c) 2013 junyuan ji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OslUIViewController : UIViewController
@property(assign, nonatomic) long appearTime;
@property(assign, nonatomic) long disappearTime;
@property(assign, nonatomic) long dataChangedTime;

-(BOOL) dataChanged;
-(void)dataChangedNotificationCallback:(NSNotification *)noti;
- (void) likeUnlike:(id)offer :(BOOL)liked :(id)params;
- (void) followUnfollowUser:(NSString *)userId :(BOOL)follow :(id)params;
- (void) followUnfollowStore:(NSString *)storeId :(BOOL)follow :(id)params;
- (BOOL)isLoginUser:(NSString *)userId;
-(id) searchTableView:(UITableView *)tv forClass:(Class)cls withTag:(int)tag;
-(id) searchTableView:(UITableView *)tv forClass:(Class)cls withStringTag:(NSString *)tag;
-(void) changeNumer:(NSDictionary *)dic diff:(int)diff forKey:(NSString *)key;
-(void) setBool:(NSDictionary *)dic value:(BOOL)value forKey:(NSString *)key;
- (void)setButtonClickAction:(SEL)action withTarget:(id)target toButton:(UIButton *)btn;
@end
