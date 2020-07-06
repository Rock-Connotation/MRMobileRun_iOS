//
//  LJJInviteSearchResultView.h
//  MRMobileRun
//
//  Created by J J on 2019/4/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJJInviteSearchResultView : UIView

//导航栏
@property (nonatomic,strong) UIImageView *imageNavigation;
//邀约
@property (nonatomic,strong) UILabel *labelInvite;
//背景
@property (nonatomic,strong) UIImageView *backImage;
//返回
@property (nonatomic,strong) UIImageView *back;
//搜索
@property (nonatomic,strong) UILabel *labelResult;
//cell背景
@property (nonatomic,strong) UIImageView *cellImage;
//网名
@property (nonatomic,strong) UILabel *labelName;
//学院
@property (nonatomic,strong) UILabel *labelCollege;
//学号
@property (nonatomic,strong) UILabel *labelStuID;
//添加按钮
@property (nonatomic,strong) UIButton *btnAdd;
//分割线
@property (nonatomic,strong) UIImageView *imageCut;
//删除img
@property (nonatomic,strong) UIButton *imgEraser01;
@property (nonatomic,strong) UIImageView *imgEraser02;
@end

NS_ASSUME_NONNULL_END
