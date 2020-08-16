//
//  ZYLSettingNameCell.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/11.
//


/*
继承自ZYLSettingNomalCell
 右侧添加显示昵称的Label
*/


#import "ZYLSettingNomalCell.h"
#import "ZYLNicknameTextField.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZYLSettingNameCell : ZYLSettingNomalCell
@property (nonatomic, strong) ZYLNicknameTextField *nicknameTextFiled;
@end

NS_ASSUME_NONNULL_END
