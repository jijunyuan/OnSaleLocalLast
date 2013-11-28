//
//  UIImage+UIImageExt.m
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-28.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "UIImage+UIImageExt.h"

@implementation UIImage (UIImageExt)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    float width = targetSize.width;
    float height = targetSize.height;
    NSLog(@"width = %f,float = %f",width,height);
    CGSize destinationSize;
    UIImage *newImage = nil;
    UIImage *sourceImage = self;
    if(width > 960 || height > 960)
    {
        if(width > height)
        {
            destinationSize.width = 960.0;
            destinationSize.height = height / (width / 960.0);
        }
        else
        {
            destinationSize.height = 960.0;
            destinationSize.width = width / (height / 960.0);
        }
        NSLog(@"UIImage resized image from %f %f to %f %f ", width, height, destinationSize.width, destinationSize.height);
        UIGraphicsBeginImageContext(destinationSize);
        [sourceImage drawInRect:CGRectMake(0,0,destinationSize.width, destinationSize.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        newImage = self;
    }
    return newImage;
}
@end
