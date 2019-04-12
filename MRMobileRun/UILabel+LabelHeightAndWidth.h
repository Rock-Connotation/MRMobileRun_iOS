//
//  UILabel+LabelHeightAndWidth.h
//  MobileRun
//
//  Created by 郑沛越 on 2017/3/12.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LabelHeightAndWidth)
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;
//高度自适应
+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;
//宽度自适应
@end
