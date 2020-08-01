//
//  MGDSportData.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/31.
//

#import "MGDSportData.h"

@implementation MGDSportData

-(instancetype)initWithDic:(NSDictionary *)dict {
    if (self = [super init]) {
        self.totalTime = dict[@"duration"];
        self.distance = dict[@"mileage"];
        self.cal = dict[@"kcal"];
        NSLog(@"字典转模型成功");
    }
    return self;
}

+(instancetype)SportDataWithDict:(NSDictionary *)dict {
    NSLog(@"正在转模型");
    return [[self alloc] initWithDic:dict];
}

@end
