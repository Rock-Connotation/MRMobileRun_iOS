//
//  MGDDataViewController.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/27.
//

#import <UIKit/UIKit.h>
#import "MGDOverView.h"
#import "MGDDataView.h"
#import "MGDButtonsView.h"
#import "MGDShareView.h"
#import "MGDShareDataView.h"

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(12.0))
@interface MGDDataViewController : UIViewController

@property (nonatomic, strong) NSString *userIconStr;
@property (nonatomic, strong) NSString *userNmaeStr;
@property (nonatomic, strong) NSString *distanceStr;
@property (nonatomic, strong) NSString *speedStr; //配速
@property (nonatomic, strong) NSString *stepFrequencyStr; //步频
@property (nonatomic, strong) NSString *timeStr; //跑步时间
@property (nonatomic, strong) NSString *energyStr;//千卡
//这里要获取的是跑步的具体日期，你把时间转换一下传过来就行，具体的形式可以参考我的cell跳转到分享页面时的具体的日期
@property (nonatomic, strong) NSString *date; //日期
@property (nonatomic, strong) NSString *time; //时间


@property (nonatomic, strong) NSArray *locationAry; //首页中采集到的所有定位点的数据
@property (nonatomic, strong) NSArray *drawLineAry; //首页中采集到的所有用来绘制轨迹的数据

@property (nonatomic, strong) NSArray *caculatedSpeedAry; //首页中处理后的速度数组
@property (nonatomic, strong) NSArray *cacultedStepsAry; //首页中的处理后步频数组

@property int averageStepFrequency; //平均步频
@property int maxStepFrequencyLastest; //最大步频
@property double averageSpeed; //平均速度
@property double maxSpeedLastest; //最大速度

@property (nonatomic, strong) NSArray *originStepsAry; //原始的获取到的步频数组；

@property (nonatomic ,strong) UIScrollView *backScrollView;

@property (nonatomic ,strong) MGDOverView *overView;

@property (nonatomic ,strong) MGDDataView *dataView;

@property (nonatomic ,strong) MGDButtonsView *twoBtnView;

@property (nonatomic ,strong) MGDShareView *shareView;

//关于天气
@property (nonatomic, strong) NSString *temperature;
@property (nonatomic, strong) NSString *weather;
//@property (nonatomic, strong) UIImageView *weatherImageView; //显示天气图片的图片框

@property (nonatomic ,strong) MGDShareDataView *shareDataView;
@end

NS_ASSUME_NONNULL_END
