//
//  UIFont+AdjustAuto.m
//  MobileRun
//
//  Created by xiaogou134 on 2017/12/18.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "UIFont+AdjustAuto.h"

@implementation UIFont (AdjustAuto)
+ (UIFont *)adjustFontSize:(CGFloat)fontSize
{
    CGFloat width = screenWidth / 375;
    UIFont *font = [UIFont systemFontOfSize:fontSize * width];
    return font;
}
@end
