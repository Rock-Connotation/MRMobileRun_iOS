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
        
        self.StepFrequencyArray = [self StringToArray:dict[@"StepFrequency"]];
        self.SpeedArray = [self StringToArray:dict[@"Speed"]];
        self.pathArray = [self StringToArray:dict[@"path"]];
        //字典转模型时取数组
        
    }
    return self;
}

+(instancetype)SportDataWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDic:dict];
}

- (NSArray *)StringToArray:(NSString *)JsonStr {
    NSString *str = JsonStr;
    if (str.length > 0) {
        str =  [str substringFromIndex:2];
        NSArray *tempArr = [str componentsSeparatedByString:@"],["];
         return tempArr;
    }else {
        return @[];
    }
}

@end
