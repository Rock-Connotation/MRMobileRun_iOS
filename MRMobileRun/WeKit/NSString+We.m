 //
//  NSObject+We.m
//  test
//
//  Created by RainyTunes on 16/4/9.
//  Copyright © 2016年 We.Can. All rights reserved.
//

#import "NSString+We.h"
#import <objc/runtime.h>

@implementation NSString (We)
static NSString *strKey = @"strKey";

- (NSString *(^) (NSString *str))add {
    self.str = self;
    return ^NSString *(NSString *newStr) {
        self.str = [self.str stringByAppendingString:newStr];
        NSString *tempStr = [self.str copy];
        self.str = nil;
        return tempStr;
    };
}

- (void)setStr:(NSString *)str {
    objc_setAssociatedObject(self, &strKey, str, OBJC_ASSOCIATION_COPY);
}

- (NSString *)str {
    return objc_getAssociatedObject(self, &strKey);
}

//- (NSString *)URLEncodedString {
//    NSString *encodedString = (NSString *)
//    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                            (CFStringRef)self,
//                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
//                                            NULL,
//                                            kCFStringEncodingUTF8));
//    return encodedString;
//}

- (NSString *)stringByRegularPattern:(NSString *)regularString {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularString options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    return [self substringWithRange:result.range];
}

@end
