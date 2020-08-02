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
        self.totalTime = dict[@"Duration"];
        self.distance = dict[@"Mileage"];
        self.cal = dict[@"Kcal"];
    }
    return self;
}

+(instancetype)SportDataWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDic:dict];
}

@end
