//
//  OslUIViewController.h
//  OnSaleLocal
//
//  Created by Kevin Zhang on 12/14/13.
//  Copyright (c) 2013 junyuan ji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OslUIViewController : UIViewController

@property (assign, nonatomic) BOOL poped;

- (void) dataChangedNotificationCallback:(NSNotification *)noti;
- (void) likeUnlike:(NSString *)offerId :(BOOL)liked :(id)params;
- (void) followUnfollowUser:(NSString *)userId :(BOOL)follow :(id)params;
- (void) followUnfollowStore:(NSString *)storeId :(BOOL)follow :(id)params;
- (BOOL) isLoginUser:(NSString *)userId;
- (id)   searchTableView:(UITableView *)tv forClass:(Class)cls withTag:(int)tag;
- (id)   searchTableView:(UITableView *)tv forClass:(Class)cls withStringTag:(NSString *)tag;
- (int)  changeNumer:(NSDictionary *)dic diff:(int)diff forKey:(NSString *)key;
- (void) setBool:(NSDictionary *)dic value:(BOOL)value forKey:(NSString *)key;
- (void) setButtonClickAction:(SEL)action withTarget:(id)target toButton:(UIButton *)btn;
- (BOOL) showCenterViewControllerIfVisible:(Class)cls;
- (BOOL) hasViewController:(UIViewController *)controller;
@end
