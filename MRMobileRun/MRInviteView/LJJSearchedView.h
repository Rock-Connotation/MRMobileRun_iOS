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
//查看图片滑动View
@property(strong, nonatomic) UIScrollView *idInfoScroView;
//信息label
@property(strong, nonatomic) UILabel *infoCollege;
@property(strong, nonatomic) UILabel *infoName;
@property(strong, nonatomic) UILabel *infoDistance;
@end

NS_ASSUME_NONNULL_END
