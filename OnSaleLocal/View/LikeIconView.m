//
//  LikeIconView.m
//  OnSaleLocal
//
//  Created by Kevin Zhang on 12/14/13.
//  Copyright (c) 2013 junyuan ji. All rights reserved.
//

#import "LikeIconView.h"

@implementation LikeIconView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.likedImg = [UIImage imageNamed:@"liked.png"];
        self.unlikedImg = [UIImage imageNamed:@"like.png"];
        
        [self like:NO];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(onImageViewClicked)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:singleTap];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) like:(BOOL)liked
{
    self.liked = liked;
    [self setImage:liked ? self.likedImg : self.unlikedImg];
}

- (void) onImageViewClicked
{
    NSLog(@"image view clicked");
    [self like:!self.liked];
}
@end
