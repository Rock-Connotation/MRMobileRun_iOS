//
//  ZYLSettingDarkModeCell.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/11.
//

/*
 继承自ZYLSettingNomalCell
 右侧隐藏箭头，添加UISwitch，显示是否为暗黑模式
 */
#import "ZYLSettingNomalCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYLSettingDarkModeCell : ZYLSettingNomalCell
@property (nonatomic, strong) UISwitch *mySwitch;
@end

NS_ASSUME_NONNULL_END
