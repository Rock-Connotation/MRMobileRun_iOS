//
//  ZYLSteps.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/5/3.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^GetStepsBlcok) (NSNumber *steps);

@interface ZYLSteps : NSObject

@property (nonatomic,copy)GetStepsBlcok getStepsBlcok;
- (NSNumber *)getStepsFromBeginTime:(NSDate *)begin ToEndTime:(NSDate *)end;
@end

NS_ASSUME_NONNULL_END
