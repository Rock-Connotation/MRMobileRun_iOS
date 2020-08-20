//
//  MGDSportData.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGDSportData : NSObject

@property (nonatomic, strong) NSString *distance;

@property (nonatomic, strong) NSString *totalTime;

@property (nonatomic, strong) NSString *cal;

@property (nonatomic, strong) NSString *AverageSpeed;

@property (nonatomic, strong) NSString *AverageStepFrequency;

@property (nonatomic, strong) NSString *MaxSpeed;

@property (nonatomic, strong) NSString *MaxStepFrequency;

@property (nonatomic, strong) NSString *FinishDate;

@property (nonatomic, strong) NSString *Weather;

@property (nonatomic, strong) NSString *Temperature;

@property (nonatomic, strong) NSArray *StepFrequencyArray;

@property (nonatomic, strong) NSArray *SpeedArray;

//一个数组
@property (nonatomic, strong) NSArray *pathArray;

-(instancetype)initWithDic:(NSDictionary *)dict;

+(instancetype)SportDataWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
<<<<<<< HEAD
=======

>>>>>>> 46c8a1a5b52742d11a1a90aebbf27bb03dc178fa
