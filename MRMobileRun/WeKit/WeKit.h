//
// Created by RainyTunes on 11/24/15.
// Copyright (c) 2015 We.Can. All rights reserved.
//
# pragma mark Category
#import "UIView+We.h"
#import "UIButton+We.h"
#import "UIColor+We.h"
#import "UILabel+We.h"
#import "UIImage+We.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "LxDBAnything.h"

#ifndef ScreenWidth
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

#ifndef ScreenHeight
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#endif

#ifndef ScreenCenter
#define ScreenCenter CGPointMake(ScreenWidth / 2, ScreenHeight / 2)
#endif

#ifndef ScreenFrame
#define ScreenFrame CGRectMake(0, 0, ScreenWidth, ScreenHeight)
#endif

@interface WeKit : NSObject
//对UserDefault的封装
+ (NSInteger)numForKey:(NSString *)str;
+ (void)setNum:(NSInteger)num ForKey:(NSString *)key;
+ (NSString *)stringForKey:(NSString *)str;
+ (void)setString:(NSString *)str ForKey:(NSString *)key;
+ (NSInteger)randomIntegerFrom:(NSInteger)startNum To:(NSInteger)endNum;
+ (void)setPasteBoardString:(NSString *)str;
@end
