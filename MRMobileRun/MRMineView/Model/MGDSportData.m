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

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.totalTime = [aDecoder decodeObjectForKey:@"totalTime"];
        self.distance = [aDecoder decodeObjectForKey:@"distance"];
        self.cal = [aDecoder decodeObjectForKey:@"cal"];
        self.FinishDate = [aDecoder decodeObjectForKey:@"FinishDate"];
        self.AverageSpeed = [aDecoder decodeObjectForKey:@"AverageSpeed"];
        self.AverageStepFrequency = [aDecoder decodeObjectForKey:@"AverageStepFrequency"];
        self.MaxSpeed = [aDecoder decodeObjectForKey:@"MaxSpeed"];
        self.MaxStepFrequency = [aDecoder decodeObjectForKey:@"MaxStepFrequency"];
        self.Temperature = [aDecoder decodeObjectForKey:@"Temperature"];
        self.Weather = [aDecoder decodeObjectForKey:@"Weather"];
        self.StepFrequencyArray = [aDecoder decodeObjectForKey:@"StepFrequencyArray"];
        self.SpeedArray = [aDecoder decodeObjectForKey:@"SpeedArray"];
        self.pathArray = [aDecoder decodeObjectForKey:@"pathArray"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.totalTime forKey:@"totalTime"];
    [aCoder encodeObject:self.distance forKey:@"distance"];
    [aCoder encodeObject:self.cal forKey:@"cal"];
    [aCoder encodeObject:self.FinishDate forKey:@"FinishDate"];
    [aCoder encodeObject:self.AverageSpeed forKey:@"AverageSpeed"];
    [aCoder encodeObject:self.AverageStepFrequency forKey:@"AverageStepFrequency"];
    [aCoder encodeObject:self.MaxSpeed forKey:@"MaxSpeed"];
    [aCoder encodeObject:self.MaxStepFrequency forKey:@"MaxStepFrequency"];
    [aCoder encodeObject:self.Temperature forKey:@"Temperature"];
    [aCoder encodeObject:self.Weather forKey:@"Weather"];
    [aCoder encodeObject:self.StepFrequencyArray forKey:@"StepFrequencyArray"];
    [aCoder encodeObject:self.SpeedArray forKey:@"SpeedArray"];
    [aCoder encodeObject:self.pathArray forKey:@"pathArray"];
    
}


@end

