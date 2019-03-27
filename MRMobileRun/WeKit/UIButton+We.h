//
// Created by RainyTunes on 11/21/15.
// Copyright (c) 2015 We.Can. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (We)
typedef void(^WeButtonEventHandler)();
//用代码块给Button增加action，减少耦合度
- (void)addAction:(WeButtonEventHandler)action;
//设置Text字体大小
- (void)setTextSize:(NSInteger)textSize;
+ (UIButton *)templateButton;
+ (UIButton *)templateButtonWithCenter:(CGPoint)origin;
@end