//
//  RunningModel.h
//  MRMobileRun
//
//  Created by 石子涵 on 2020/7/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol RunmodelDelegate <NSObject>

- (void)senderTime:(NSInteger )timeNum;
- (void)showSportsPresentTime:(NSString *)timeStr intTime:(int )time;

@end


@interface RunningModel : NSObject
@property(nonatomic,copy)NSString *distanceStr; //距离
@property(nonatomic,copy)NSString *speedStr; //配速
@property(nonatomic,copy)NSString *energyStr; // 卡路里

@property (nonatomic,assign) NSInteger selectTime; // 运动时间

@property(nonatomic,weak)id<RunmodelDelegate>delegate;

-(void)startSelectData;//开始采集数据
-(void)pauseSports;//运动暂停
-(void)continueToSports;//继续跑步
-(void)endSports;//结束跑步

@end

NS_ASSUME_NONNULL_END
