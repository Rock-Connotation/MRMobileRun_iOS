//
//  MGDDataView.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGDDataView : UIView
//这个文件是两个图表，速度和步频，大的UIView套上两个小的UIView

//文字
@property (nonatomic, strong) UILabel *pace;
@property (nonatomic, strong) UILabel *speed;
@property (nonatomic, strong) UILabel *paceLab;
@property (nonatomic, strong) UILabel *speedLab;
@property (nonatomic, strong) UILabel *descSpeed;
@property (nonatomic, strong) UILabel *descPace;
//圆点
@property (nonatomic, strong) UIView *speedDotView;
@property (nonatomic, strong) UIView *paceDotView;

//整体背景
@property (nonatomic, strong) UIView *backView;

//速度背景View
@property (nonatomic, strong) UIView *speedBackView;

//步频背景View
@property (nonatomic, strong) UIView *paceBackView;

@end

NS_ASSUME_NONNULL_END
