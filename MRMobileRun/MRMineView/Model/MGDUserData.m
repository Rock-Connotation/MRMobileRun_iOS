//
//  mgduserdata.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/8/1.
//

#import "MGDUserData.h"

@implementation MGDUserData

- (instancetype)initWithDic:(NSDictionary *)dict {
    if (self = [super init]) {
        self.distance = dict[@"TotalDistance"];
        self.duration = dict[@"TotalDuration"];
        self.consume = dict[@"TotalConsume"];
    }
    return self;
}

+ (instancetype)DataWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDic:dict];
}

@end

