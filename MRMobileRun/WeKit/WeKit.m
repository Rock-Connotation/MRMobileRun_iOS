//
//  WeKit.m
//  WeKeyChain
//
//  Created by RainyTunes on 16/10/13.
//  Copyright © 2016年 We.Can. All rights reserved.
//

#import "WeKit.h"


@implementation WeKit
+ (NSInteger)numForKey:(NSString *)str {
    return [self stringForKey:str].integerValue;
}
+ (void)setNum:(NSInteger)num ForKey:(NSString *)key {
    [self setString:[NSString stringWithFormat:@"%ld",num] ForKey:key];
}

+ (NSString *)stringForKey:(NSString *)str {
    return [[NSUserDefaults standardUserDefaults]objectForKey:str];
}
+ (void)setString:(NSString *)str ForKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:key];
}
+ (void)setPasteBoardString:(NSString *)str {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = str;
}

+ (NSInteger)randomIntegerFrom:(NSInteger)startNum To:(NSInteger)endNum {
    return startNum + arc4random() % (endNum - startNum);
}
@end
