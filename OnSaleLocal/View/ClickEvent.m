//
//  ClickEvent.m
//  OnSaleLocal
//
//  Created by Kevin Zhang on 12/18/13.
//  Copyright (c) 2013 junyuan ji. All rights reserved.
//

#import "ClickEvent.h"

@implementation ClickEvent

-(ClickEvent *) init
{
    self = [super init];
    return self;
}

-(ClickEvent *) initWithTarget:(id)target forSel:(SEL)sel
{
    self = [super init];
    self.target = target;
    self.action = sel;
    return self;
}
@end
