//
//  StepManager.h
//  MRMobileRun
//
//  Created by 石子涵 on 2020/9/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface StepManager : NSObject
@property (nonatomic) NSInteger step;                       // 运动步数（总计）

+ (StepManager *)sharedManager;

//开始计步
- (void)startWithStep;
@end

NS_ASSUME_NONNULL_END
