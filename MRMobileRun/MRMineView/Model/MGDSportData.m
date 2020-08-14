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
        self.FinishDate = dict[@"FinishDate"];
        self.AverageSpeed = dict[@"AverageSpeed"];
        self.AverageStepFrequency = dict[@"AverageStepFrequency"];
        self.MaxSpeed = dict[@"MaxSpeed"];
        self.MaxStepFrequency = dict[@"MaxStepFrequency"];
        self.Temperature = dict[@"Temperature"];
        self.Weather = dict[@"Weather"];
        self.StepFrequencyArray = dict[@"StepFrequency"];
        self.SpeedArray = dict[@"Speed"];
        self.pathArray = dict[@"path"];
    }
    return self;
}

+(instancetype)SportDataWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDic:dict];
}

@end
