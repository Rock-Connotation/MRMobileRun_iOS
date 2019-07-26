//
//  LJJInviteSearchView.h
//  MRMobileRun
//
//  Created by J J on 2019/5/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJJInviteSearchView : UIView
//邀约背景色
@property (nonatomic,strong) UIImageView *backImage;
//邀约背景修饰图
@property (nonatomic,strong) UIImageView *roundBack;
//邀约浮动球1
@property (nonatomic,strong) UIImageView *flowBall01;
//邀约浮动球2
@property (nonatomic,strong) UIImageView *flowBall02;
//邀约浮动球3
@property (nonatomic,strong) UIImageView *flowBall03;
//邀约返回箭头_白
@property (nonatomic,strong) UIImageView *whiteBack;
//邀约返回按钮
@property (nonatomic,strong) UIButton *backBtn;
//邀约返回箭头_黑
@property (nonatomic,strong) UIImageView *blackBack;
//邀约水波纹
@property (nonatomic,strong) UIImageView *ripple;
//邀约检索库框底板
@property (nonatomic,strong) UIImageView *searchBoard;
//邀约搜索textfield
@property (nonatomic,strong) UITextField *inviteTextField;
//邀约加载icon
@property (nonatomic,strong) UIImageView *loadIcon;
//邀约标题
@property (nonatomic,strong) UILabel *head;
//邀约标题
@property (nonatomic,strong) UILabel *loading;
//邀约取消按钮
@property (nonatomic,strong) UIButton *cancel;
//邀约波浪前
@property (nonatomic,strong) UIImageView *imageFront;
//邀约波浪后
@property (nonatomic,strong) UIImageView *imageBack;
//邀约检索取消
@property (nonatomic,strong) UIButton *inviteTextCancel;
//邀约历史记录
@property (nonatomic,strong) UILabel *historyLabel;
//cell邀约历史记录底板
@property (nonatomic,strong) UIImageView *cellImage;
@end

NS_ASSUME_NONNULL_END
