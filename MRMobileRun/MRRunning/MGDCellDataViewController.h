//
//  MGDCellDataViewController.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/8/13.
//

#import <UIKit/UIKit.h>
#import "MGDOverView.h"
#import "MGDDataView.h"
#import "MGDButtonsView.h"
#import "MGDShareView.h"

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(12.0))
@interface MGDCellDataViewController : UIViewController

@property (nonatomic, strong) NSString *distanceStr; //距离
@property (nonatomic, strong) NSString *speedStr; //配速
@property (nonatomic, strong) NSString *stepFrequencyStr; //步频
@property (nonatomic, strong) NSString *timeStr; //跑步时间
@property (nonatomic, strong) NSString *energyStr;//千卡
@property (nonatomic, strong) NSString *date; //日期
@property (nonatomic, strong) NSString *time; //时间
@property (nonatomic, strong) NSString *MaxStepFrequency; //最大步频
@property (nonatomic, strong) NSString *MaxSpeed; //最大速度
@property (nonatomic, strong) NSString *degree; //温度

@property (nonatomic, strong) NSArray *locationAry; //毛国栋页面采集到的所有位置数据

@property (nonatomic, strong) NSArray *speedArray; //毛国栋页面得到的网络速度数据
@property (nonatomic, strong) NSArray *stepFrequencyArray; //毛国栋页面得到的网络步频数据


@property (nonatomic ,strong) UIScrollView *backScrollView;

@property (nonatomic ,strong) MGDOverView *overView;

@property (nonatomic ,strong) MGDDataView *dataView;

@property (nonatomic ,strong) MGDButtonsView *twoBtnView;

@property (nonatomic ,strong) MGDShareView *shareView;

@end

NS_ASSUME_NONNULL_END
