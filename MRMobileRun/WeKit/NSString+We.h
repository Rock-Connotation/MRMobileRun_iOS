//
//  NSObject+We.h
//  test
//
//  Created by RainyTunes on 16/4/9.
//  Copyright © 2016年 We.Can. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (We)
@property NSString *str;
//链式字符串相加
- (NSString *(^) (NSString *str))add;

//- (NSString *)URLEncodedString;
//- (NSString *)stringByRegularPattern:(NSString *)regularString;
@end
