//
//  ZYLRunningTabView.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/5/2.
//

#import <UIKit/UIKit.h>
#import "MRStopBtu.h"
#import "MRPauseAndResumeBtu.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZYLRunningTabView : UIView
@property (nonatomic,strong) MRPauseAndResumeBtu *pauseAndResumeBtu;
//继续暂停按钮
@property (nonatomic,strong) MRStopBtu *stopBtu;
//停止按钮
@end

NS_ASSUME_NONNULL_END
