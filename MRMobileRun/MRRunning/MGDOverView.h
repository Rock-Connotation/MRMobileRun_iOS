//
//  MGDOverView.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//这个页面是点击结束跑步按钮后展示出的页面，上面的mapView用来放地图，下面的label，UIImageview等控件用来显示这次跑步的信息（缺少一个天气的UIImageView）

@interface MGDOverView : UIView
//温度
@property (nonatomic, strong) UILabel *degree;
//地图
@property (nonatomic, strong) UIView *mapView;
//下方背景
@property (nonatomic, strong) UIView *backView;
//头像
@property (nonatomic, strong) UIImageView *userIcon;
//用户名
@property (nonatomic, strong) UILabel *userName;
//公里数
@property (nonatomic, strong) UILabel *kmLab;
//公里单位
@property (nonatomic, strong) UILabel *km;
//配速
@property (nonatomic, strong) UILabel *speedLab;
//配速单位
@property (nonatomic, strong) UILabel *speed;
//步频
@property (nonatomic, strong) UILabel *paceLab;
//步频单位
@property (nonatomic, strong) UILabel *pace;
//时间
@property (nonatomic, strong) UILabel *timeLab;
//时间单位
@property (nonatomic, strong) UILabel *time;
//千卡
@property (nonatomic, strong) UILabel *calLab;
//千卡单位
@property (nonatomic, strong) UILabel *cal;
//日期
@property (nonatomic, strong) UILabel *date;
//时间
@property (nonatomic, strong) UILabel *currentTime;


@end

NS_ASSUME_NONNULL_END
