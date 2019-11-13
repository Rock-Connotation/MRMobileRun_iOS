//
//  ZYLSettingIconCell.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/11.
//

/*
 继承自ZYLSettingNomalCell
 隐藏右边箭头，添加右边头像按钮
 */
#import "ZYLSettingNomalCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYLSettingIconCell : ZYLSettingNomalCell
@property (nonatomic, strong) UIButton *iconButton;
@end

NS_ASSUME_NONNULL_END
