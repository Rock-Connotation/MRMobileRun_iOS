//
//  ZYLPersonalInformationView.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/12.
//

#import <UIKit/UIKit.h>
#import "ZYLLogoutBtn.h"
#import "ZYLSetAvatarBtn.h"
#import "ZYLNicknameTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYLPersonalInformationView : UIView
@property (nonatomic,strong) ZYLSetAvatarBtn *avatarBtu;
//设置头像按钮
@property (nonatomic,strong) UIButton *backBtu;
// 返回按钮
@property (nonatomic,strong) ZYLLogoutBtn * logoutBtu;
//退出登录按钮
@property (nonatomic,strong) ZYLNicknameTextField *nickameTextField;

//输入昵称的文本框
@end

NS_ASSUME_NONNULL_END
