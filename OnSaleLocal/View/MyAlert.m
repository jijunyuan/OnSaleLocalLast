//
//  MyAlert.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-16.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "MyAlert.h"

@implementation MyAlert

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+(void)ShowAlertMessage:(NSString *)aMessage title:(NSString *)aTitle
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:aTitle message:aMessage delegate:nil cancelButtonTitle:@"YES" otherButtonTitles:nil, nil];

    [alert show];
}
- (void)willPresentAlertView:(UIAlertView *)alertView
{
    for (UIView *tempView in alertView.subviews) {
        if ([tempView isKindOfClass:[UILabel class]]) {
            UILabel *tempLabel = (UILabel *) tempView;
            if ([tempLabel.text isEqualToString:alertView.message]) {
                [tempLabel setFont:[UIFont fontWithName:AllFont size:AllFontSize]];
            }
        }
    }
}

@end
