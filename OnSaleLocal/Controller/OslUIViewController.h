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
@end
