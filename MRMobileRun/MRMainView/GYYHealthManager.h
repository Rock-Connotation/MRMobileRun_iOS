//
//  GYYHealthTableViewCell.m
//  MRMobileRun
//
//  Created by 郭蕴尧 on 2020/7/9.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

/**
 xcodeproj - TARGETS - Signing & Capabilities - + Capability - HealthKit
 
 开启HealthKit之后，在info.plist中增加 Privacy - Health Share Usage Description 与 Privacy - Health Update Usage Description，内容如实填写。
 */

NS_ASSUME_NONNULL_BEGIN

@interface GYYHealthManager : NSObject

@property (nonatomic, strong) HKHealthStore *healthStore;

+ (id)shareInstance;

//权限验证
- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion;

//获取步数
- (void)getStepCountIsToday:(BOOL)isToday completion:(void(^)(double value, NSError *error))completion;

//获取阶梯数
- (void)getStairIsToday:(BOOL)isToday completion:(void(^)(double value, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
