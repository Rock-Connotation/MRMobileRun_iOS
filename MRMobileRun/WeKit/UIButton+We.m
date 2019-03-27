//
// Created by RainyTunes on 11/21/15.
// Copyright (c) 2015 We.Can. All rights reserved.
//

#import "UIButton+We.h"
#import "UIColor+We.h"
#import "UIView+We.h"
#import "UIImage+We.h"


#import <objc/runtime.h>

@interface UIButton ()
@property (nonatomic, strong, readwrite)WeButtonEventHandler handler;

@end

static NSString *blockKey = @"blockKey";

@implementation UIButton (We)
- (void)addAction:(WeButtonEventHandler)handler {
    self.handler = handler;
    [self addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setHandler:(WeButtonEventHandler)handler{
    objc_setAssociatedObject(self, &blockKey, handler, OBJC_ASSOCIATION_COPY);
}

- (WeButtonEventHandler)handler {
    return objc_getAssociatedObject(self, &blockKey);
}

- (void)action {
    self.handler();
}

- (void)setTextSize:(NSInteger)textSize {
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:textSize];
}

+ (UIButton *)templateButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.width = 120;
    button.height = 60;
    [button.layer setCornerRadius:5.0];
    button.layer.masksToBounds = YES;
    [button setBackgroundColor:[UIColor paperColorDeepOrange]];
    [button setBackgroundImage:[UIImage imageWithColorFilled:UIColorFromRGB(0x9e9e9e)] forState:UIControlStateHighlighted];
    [button setTitle:@"Button" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0xf5f5f5) forState:UIControlStateHighlighted];
    return button;
}
+ (UIButton *)templateButtonWithCenter:(CGPoint)origin {
    UIButton *button = [UIButton templateButton];
    [button setCenter:origin];
    return button;
}
@end
