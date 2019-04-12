//
//  ZYLInvitationRankViewModel.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYLInvitationRankViewModel : NSObject

//传递分页和时间段
+ (void)ZYLGetInvitationRankWithPages:(NSString *)page andtime:(NSString *)time;
+ (void)ZYLGetMyInvitationRankWithdtime:(NSString *)time;
@end

NS_ASSUME_NONNULL_END
