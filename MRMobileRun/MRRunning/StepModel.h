//
//  StepModel.h
//  MRMobileRun
//
//  Created by 石子涵 on 2020/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StepModel : NSObject
//g是一个震动幅度的系数,通过一定的判断条件来判断是否计做一步
@property(nonatomic,assign) double g;

@property(nonatomic,strong) NSDate *date;

@property(nonatomic,assign) int record_no;

@property(nonatomic, strong) NSString *record_time;

@property(nonatomic,assign) int step;

@end

NS_ASSUME_NONNULL_END
