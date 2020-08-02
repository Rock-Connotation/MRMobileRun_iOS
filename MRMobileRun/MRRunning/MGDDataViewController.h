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

NS_ASSUME_NONNULL_BEGIN

@interface MGDDataViewController : UIViewController

@property (nonatomic, strong) NSString *distanceStr;
@property (nonatomic, strong) NSString *speedStr; //配速
@property (nonatomic, strong) NSString *stepFrequencyStr; //步频
@property (nonatomic, strong) NSString *timeStr; //跑步时间
@property (nonatomic, strong) NSString *energyStr;//千卡


@property (nonatomic, strong) NSArray *locationAry; //首页中采集到的所有定位点的数据
@property (nonatomic, strong) NSArray *drawLineAry; //首页中采集到的所有用来绘制轨迹的数据



@property (nonatomic ,strong) UIScrollView *backScrollView;

@property (nonatomic ,strong) MGDOverView *overView;

@property (nonatomic ,strong) MGDDataView *dataView;

@property (nonatomic ,strong) MGDButtonsView *twoBtnView;

@property (nonatomic ,strong) MGDShareView *shareView;

@end

NS_ASSUME_NONNULL_END
