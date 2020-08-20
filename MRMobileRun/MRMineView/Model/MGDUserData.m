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
<<<<<<< HEAD
=======

>>>>>>> 46c8a1a5b52742d11a1a90aebbf27bb03dc178fa
