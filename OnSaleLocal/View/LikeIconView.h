//
//  LikeIconView.h
//  OnSaleLocal
//
//  Created by Kevin Zhang on 12/14/13.
//  Copyright (c) 2013 junyuan ji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LikeIconView : UIImageView

@property (assign, nonatomic) BOOL liked;
@property (strong, nonatomic) UIImage *likedImg;
@property (strong, nonatomic) UIImage *unlikedImg;

- (void) like:(BOOL) liked;

@end
