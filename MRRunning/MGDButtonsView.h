//
//  MGDButtonsView.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGDButtonsView : UIView
//背景view
@property (nonatomic, strong) UIView *backView;
//完成按钮
@property (nonatomic, strong) UIButton *overBtn;
//分享按钮
@property (nonatomic, strong) UIButton *shareBtn;

@end

NS_ASSUME_NONNULL_END
