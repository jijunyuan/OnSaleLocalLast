//
//  UIGestureRecognizer+Blocks.h
//  OnSaleLocal
//
//  Created by Kevin Zhang on 12/21/13.
//  Copyright (c) 2013 junyuan ji. All rights reserved.
//

#import <UIKit/UIKit.h>

// Declare a completion block to be called when the action fires
typedef void (^UIGestureRecognizerActionBlock)(UIGestureRecognizer *);

@interface UIGestureRecognizer (Blocks)

// New initializer for the gesture recognizer with blocks
- (id)initWithBlock:(UIGestureRecognizerActionBlock)block;

@end
