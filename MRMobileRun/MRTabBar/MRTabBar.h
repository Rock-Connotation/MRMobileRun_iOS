//
//  MRTabBar.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/5/8.
//


/*
 为了优化界面跳转(使用组件化跳转)重写了TabBar
 */

#import <UIKit/UIKit.h>
#import "MRTabBarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MRTabBar : UIView
@property (strong, nonatomic) MRTabBarView *tabView;
//- (void)initTabView;
@end

NS_ASSUME_NONNULL_END
