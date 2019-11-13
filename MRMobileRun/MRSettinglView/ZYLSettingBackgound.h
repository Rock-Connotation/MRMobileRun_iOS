//
//  ZYLSettingBackgound.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/11.
//

#import <UIKit/UIKit.h>
@class ZYLSettingIconCell;
@class ZYLSettingNameCell;
@class ZYLSettingNomalCell;
@class ZYLSettingDarkModeCell;
NS_ASSUME_NONNULL_BEGIN

@interface ZYLSettingBackgound : UIView
@property (nonatomic, strong) ZYLSettingDarkModeCell *switchCell;
@property (nonatomic, strong) ZYLSettingIconCell *iconCell;
@property (nonatomic, strong) ZYLSettingNameCell *nicknameCell;
@property (nonatomic, strong) ZYLSettingNomalCell *signCell;
@property (nonatomic, strong) ZYLSettingNomalCell *aboutCell;
@property (nonatomic, strong) ZYLSettingNomalCell *permissionCell;
@property (nonatomic, strong) ZYLSettingNomalCell *suggestionCell;
@property (nonatomic, strong) UIButton *logoutBtn;
@end

NS_ASSUME_NONNULL_END
