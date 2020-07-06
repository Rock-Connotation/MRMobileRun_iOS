//
//  ZYLClassRankViewModel.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface ZYLClassRankViewModel : NSObject
//传递分页和时间段
+ (void)ZYLGetClassRankWithPages:(NSString *)page andtime:(NSString *)time;

+ (void)ZYLGetMyClassRankWithdtime:(NSString *)time;
@end

NS_ASSUME_NONNULL_END
