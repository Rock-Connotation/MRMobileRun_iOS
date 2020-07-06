//
//  ZYLMainView.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/3/23.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "ZYLRankModel.h"
#import "ZYLArrowBtn.h"
#import "ZYLAvatarBtn.h"
#import "ZYLTitleLabel.h"
#import "ZYLBackgroundView.h"
#import "ZYLLeaderboardBtn.h"
#import "ZYLRunningRecordBtn.h"
#import "ZYLNoticeBanner.h"
#import "MRNumLabel.h"
#import "MRTimeLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZYLMainView : UIView

@property (nonatomic, strong) UILabel *nicknameLab;
@property (strong, nonatomic)ZYLRankModel *rankModel;
@property (nonatomic,strong) ZYLAvatarBtn *avatarBtu;
//头像按钮
@property (nonatomic,strong) UIImageView *avatarImage;
//@property (nonatomic,strong) MRStartRunningBtu *beginRunningBtu;
//开始跑步按钮
@property (nonatomic,strong) ZYLLeaderboardBtn *leaderboardBtu;
//排行榜的图标按钮
@property (nonatomic,strong) ZYLArrowBtn *leaderboardArrowBtu;
//排行榜的箭头按钮
@property (nonatomic,strong) MRNumLabel * dayMileage;
//转动圆环里的今日里程
@property (nonatomic,strong) MRNumLabel * totalDistance;
//跑步记录的总里程
@property (nonatomic,strong) MRNumLabel * smallTotalDistance;
//排行榜的总里程
@property (nonatomic,strong) MRNumLabel * distanceGap;
//距离差距
@property (nonatomic,strong) MRNumLabel * Ranking;
//排名
@property (nonatomic,strong) UILabel *timeLabel;
//跑步时间
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) ZYLBackgroundView *backGroundView;
//该界面的背景图片和一些提示性的文字
@property (nonatomic,strong) ZYLRunningRecordBtn *runingRecordBtu;
//跑步记录的图标按钮
@property (nonatomic,strong) ZYLArrowBtn *runingRecordArrowBtu;
//跑步记录的箭头按钮
@property (nonatomic,strong) UIButton *backGroundOne;
@property (nonatomic,strong) UIButton *backGroundTwo;
@property (nonatomic, strong) ZYLNoticeBanner *noticeBanner;
@end

NS_ASSUME_NONNULL_END
