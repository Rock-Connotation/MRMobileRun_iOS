//
//  MGDUserInfo.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/16.
//

#import "MGDUserInfo.h"

@implementation MGDUserInfo
- (instancetype)initWithDic:(NSDictionary *)dict {
    if (self = [super init]) {
        self.userName = dict[@"Nickname"];
        self.userSign = dict[@"Signature"];
        self.userIcon = dict[@"AvatarUrl"];
    }
    return self;
}

+ (instancetype)InfoWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDic:dict];
}

@end
