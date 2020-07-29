//
//  RunMainPageCV.h
//  MRMobileRun
//
//  Created by 石子涵 on 2020/7/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//运动状态枚举
typedef enum : NSUInteger {
    SportsStateIdle,//准备中
    SportsStateStart,//开始跑步,状态完成之后会自动流转到跑步中
    SportsStateRunning,//跑步中
    SportsStateStop,//停止跑步
} SportsState;



@interface RunMainPageCV : UIViewController
 // 当前跑步状态
@property(nonatomic,assign)SportsState sportsState;

 // 当前跑步距离
@property(nonatomic,assign)double distance;



@end

NS_ASSUME_NONNULL_END
