//
//  ZYLSteps.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/5/3.
//

#import "ZYLSteps.h"

@interface ZYLSteps ()
@end
@implementation ZYLSteps
- (NSNumber *)getStepsFromBeginTime:(NSDate *)begin ToEndTime:(NSDate *)end{
    
    CMPedometer *pedometer = [[CMPedometer alloc] init];
    if ([CMPedometer isStepCountingAvailable]) {
        //获取昨天的步数与距离数据
        [pedometer queryPedometerDataFromDate:begin toDate:end withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            if (error) {
                NSLog(@"error===%@",error);
            }
            else {
                NSLog(@"步数===%@",pedometerData.numberOfSteps);
                self.getStepsBlcok(pedometerData.numberOfSteps);
            }
        }];
    } else {
        NSLog(@"不可用===");
        return @0;
    }
    return @0;
}

@end
