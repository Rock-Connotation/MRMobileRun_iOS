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
        NSLog(@"字典转模型成功");
    }
    return self;
}

+ (instancetype)DataWithDict:(NSDictionary *)dict {
    NSLog(@"正在转模型");
    return [[self alloc] initWithDic:dict];
}

@end
