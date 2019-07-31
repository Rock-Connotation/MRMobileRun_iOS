//
//  LJJSearchedView.h
//  MRMobileRun
//
//  Created by J J on 2019/7/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJJSearchedView : UIView
//邀约label
@property(strong, nonatomic) UILabel *labelInvite;
//历史记录返回按钮
@property(strong, nonatomic) UIButton *btnBack;
//背景图片
@property(strong, nonatomic) UIImageView *imageViewBack;
//邀约呈现图片
@property(strong, nonatomic) UIImageView *idInfoView;
//分割线
@property(strong, nonatomic) UIImageView *cutLine;
//头像图片
@property(strong, nonatomic) UIImageView *headView;
@end

NS_ASSUME_NONNULL_END
