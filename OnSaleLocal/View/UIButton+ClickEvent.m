//
//  UIButton+ClickEvent.m
//  OnSaleLocal
//
//  Created by Kevin Zhang on 12/18/13.
//  Copyright (c) 2013 junyuan ji. All rights reserved.
//

#import "UIButton+ClickEvent.h"

@implementation UIButton (ClickEvent)

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:singleTap];
}

@end
