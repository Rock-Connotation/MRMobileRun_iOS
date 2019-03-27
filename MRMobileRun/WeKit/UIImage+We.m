//
// Created by RainyTunes on 11/26/15.
// Copyright (c) 2015 We.Can. All rights reserved.
//

#import "UIImage+We.h"


@implementation UIImage (We)
+ (UIImage *)imageWithColorFilled:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end