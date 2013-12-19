//
//  ClickEvent.h
//  OnSaleLocal
//
//  Created by Kevin Zhang on 12/18/13.
//  Copyright (c) 2013 junyuan ji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClickEvent : NSObject
@property(assign, nonatomic) SEL action;
@property(strong, nonatomic) id target;

-(ClickEvent *) initWithTarget:(id)target forSel:(SEL)sel;
@end
