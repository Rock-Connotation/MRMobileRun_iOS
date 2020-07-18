//
//  MGDUserData.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/16.
//

#import "MGDUserData.h"

@implementation MGDUserData

- (instancetype)initWithDic:(NSDictionary *)dict {
    if (self = [super init]) {
        self.total_distance = dict[@"total_distance"];
        self.total_duration = dict[@"total_duration"];
        self.total_consume = dict[@"total_consume"];
    }
    return self;
}

+ (instancetype)DataWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDic:dict];
}

@end
