//
//  ZYLStudentRankViewModel.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYLStudentRankViewModel : NSObject
//传递分页和时间段
+ (void)ZYLGetStudentRankWithPages:(NSString *)page andtime:(NSString *)time;
+ (void)ZYLGetMyStudentRankWithdtime:(NSString *)time;
@end

NS_ASSUME_NONNULL_END
