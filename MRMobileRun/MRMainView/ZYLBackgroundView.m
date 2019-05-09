//
//  ZYLBackgroundView.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/3/23.
//

#import "ZYLBackgroundView.h"
#import "ZYLTitleLabel.h"
#import <Masonry.h>
//三张背景图片
//这个类包含该界面内的提示性文字，如排行榜，跑步记录，路程，时间等（颜色为灰色的）

@interface ZYLBackgroundView ()
@property (nonatomic,strong) UIImageView *backgroundImageOne;
@property (nonatomic,strong) UIImageView *backgroundImageTwo;
@property (nonatomic,strong) UIImageView *backgroundImageThree;
@property (nonatomic,strong) UIImageView *dividingLine;
@property (nonatomic,strong) UIImageView *distanceImageView;
@property (nonatomic,strong) UIImageView *leaderboardImageView;

//五张背景图片
@property (nonatomic,strong) UILabel *runningRecordLabel;
@property (nonatomic,strong) UILabel *distanceLabel;
@property (nonatomic,strong) UILabel *KMLabel;
//跑步记录周围的灰色文字
@property (nonatomic,strong) UILabel *leaderboardLabel;
@property (nonatomic,strong) UILabel *rankingLabel;
@property (nonatomic,strong) UILabel *rankingLabeltwo;
@property (nonatomic,strong) UILabel *gapLabel;
@property (nonatomic,strong) UILabel *distanceLabelTwo;
@property (nonatomic,strong) UILabel *KMLabelTwo;
@property (nonatomic,strong) UILabel *KMLabelThree;
//排行榜周围的灰色文字
@property (nonatomic,strong) UILabel *oneDayDistanceLabel;
@property (nonatomic,strong) UILabel *KMLabelFour;
//圆环周围的灰色文字
@end

@implementation ZYLBackgroundView
- (void)initBackground{
    
    self.frame = CGRectMake(0, 0, screenWidth, screenHeigth);
    
    self.backgroundImageOne = [[UIImageView alloc]init];
    self.backgroundImageOne.image = [UIImage imageNamed:@"纯色背景"];
    self.backgroundImageOne.frame = self.frame;
    [self addSubview:self.backgroundImageOne];
    
    self.backgroundImageTwo = [[UIImageView alloc]init];
    self.backgroundImageTwo.image = [UIImage imageNamed:@"跑步记录按钮背景底"];
    [self addSubview:self.backgroundImageTwo];
    [self.backgroundImageTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(22.0/1334.0*screenHeigth, 406.0/750.0*screenWidth, 796.0/1334.0*screenHeigth,0));
        make.top.equalTo(self.mas_top).mas_offset(22);
        make.right.equalTo(self.mas_right);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(280);
    }];
    //顺序上，左，下，右
    
    
    self.dividingLine = [[UIImageView alloc]init];
    self.dividingLine.image = [UIImage imageNamed:@"分割线"];
    [self addSubview:self.dividingLine];
    [self.dividingLine mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(886.0/1334.0*screenHeigth, 42.0/750.0*screenWidth, 447.0/1334.0*screenHeigth, 41.0/750.0*screenWidth));
        make.top.equalTo(self.mas_top).mas_offset(488);
        make.left.equalTo(self.mas_left).mas_offset(42.0/750.0*screenWidth);
        make.width.equalTo(self.mas_width).mas_offset(-2*42.0/750.0*screenWidth);
        make.height.mas_equalTo(1);
    }];
    //分割线
    
    self.distanceImageView = [[UIImageView alloc]init];
    self.distanceImageView.image = [UIImage imageNamed:@"跑步记录icon"];
    [self addSubview:self.distanceImageView];
    [self.distanceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(375);
        make.left.mas_equalTo(44.0/750.0*screenWidth);
        make.width.mas_equalTo(30/750.0*screenWidth);
        make.height.mas_equalTo(35/750.0*screenWidth);
    }];
    
    
    self.leaderboardImageView = [[UIImageView alloc]init];
    self.leaderboardImageView.image = [UIImage imageNamed:@"Group 11"];
    [self addSubview:self.leaderboardImageView];
    [self.leaderboardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(914.0/1334.0*screenHeigth, 42.0/750.0*screenWidth, 383.0/1334.0*screenHeigth,680.0/750.0*screenWidth));
        make.top.equalTo(self.mas_top).mas_offset(505);
        make.left.mas_equalTo(44.0/750.0*screenWidth);
        make.width.mas_equalTo(30/750.0*screenWidth);
        make.height.mas_equalTo(35/750.0*screenWidth);
    }];
    
    
}

- (void)initRunningRecordLabel{
    //跑步记录周围的文字
    self.runningRecordLabel = [[ZYLTitleLabel alloc] init];
    self.runningRecordLabel.font = [UIFont boldSystemFontOfSize:15*screenWidth/414.0];
    self.runningRecordLabel.text = @"跑步记录";
    self.runningRecordLabel.textColor = [UIColor colorWithRed:170.0/255.0 green:174.0/255.0 blue:203.0/255.0 alpha:1];
    [self addSubview:self.runningRecordLabel];
    [self.runningRecordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(680.0/1334.0*screenHeigth, 98.0/750.0*screenWidth, 614.0/1334.0*screenHeigth, 500.0/750.0*screenWidth));
        make.centerY.equalTo(self.distanceImageView.mas_centerY);
        make.left.mas_equalTo(98.0/750.0*screenWidth);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    self.distanceLabel = [[ZYLTitleLabel alloc] init];
    self.distanceLabel.font = [UIFont boldSystemFontOfSize:13*screenWidth/414.0];
    self.distanceLabel.text = @"路程";
    self.distanceLabel.textColor = [UIColor colorWithRed:170.0/255.0 green:174/255.0 blue:203.0/255.0 alpha:1];
    [self addSubview:self.distanceLabel];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(749.0/1334.0*screenHeigth, 42.0/750.0*screenWidth, 548.0/1334.0*screenHeigth, 657.0/750.0*screenWidth));
        make.top.equalTo(self.runningRecordLabel.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(42.0/750.0*screenWidth);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];
    
    
    
    self.KMLabel = [[ZYLTitleLabel alloc] init];
    self.KMLabel.font = [UIFont boldSystemFontOfSize:13*screenWidth/414.0];
    self.KMLabel.text = @"km";
    self.KMLabel.textColor = [UIColor colorWithRed:170.0/255.0 green:174/255.0 blue:203.0/255.0 alpha:1];
    [self addSubview:self.KMLabel];
    
    [self.KMLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(820.0/1334.0*screenHeigth, 187.0/750.0*screenWidth, 484.0/1334.0*screenHeigth, 525/750.0*screenWidth));
        make.top.equalTo(self.distanceLabel.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(187.0/750.0*screenWidth);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(17);
    }];
    
    self.timeRecordLabel = [[ZYLTitleLabel alloc] init];
    self.timeRecordLabel.font = [UIFont boldSystemFontOfSize:13*screenWidth/414.0];
    self.timeRecordLabel.text = @"时间";
    self.timeRecordLabel.textColor = [UIColor colorWithRed:170.0/255.0 green:174/255.0 blue:203.0/255.0 alpha:1];
    [self addSubview:self.timeRecordLabel];
    
    [self.timeRecordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(750.0/1334.0*screenHeigth, 373.0/750.0*screenWidth, 547.0/1334.0*screenHeigth, 326.0/750.0*screenWidth));
        make.top.equalTo(self.runningRecordLabel.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(373.0/750.0*screenWidth);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];
    
}

- (void)initLeaderboard{
    //排行榜周围的文字
    
    self.leaderboardLabel = [[ZYLTitleLabel alloc] init];
    self.leaderboardLabel.font = [UIFont boldSystemFontOfSize:14*screenWidth/414.0];
    self.leaderboardLabel.text = @"排行榜";
    self.leaderboardLabel.textColor = [UIColor colorWithRed:170.0/255.0 green:174.0/255.0 blue:203.0/255.0 alpha:1];
    [self addSubview:self.leaderboardLabel];
    [self.leaderboardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(914.0/1334.0*screenHeigth, 96.0/750.0*screenWidth, 380.0/1334.0*screenHeigth, 568.0/750.0*screenWidth));
        make.centerY.equalTo(self.leaderboardImageView.mas_centerY);
        make.left.mas_equalTo(98.0/750.0*screenWidth);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    
    self.distanceLabelTwo = [[ZYLTitleLabel alloc] init];
    self.distanceLabelTwo.font = [UIFont boldSystemFontOfSize:13*screenWidth/414.0];
    self.distanceLabelTwo.text = @"路程";
    self.distanceLabelTwo.textColor = [UIColor colorWithRed:170.0/255.0 green:174/255.0 blue:203.0/255.0 alpha:1];
    [self addSubview:self.distanceLabelTwo];
    [self.distanceLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(985.0/1334.0*screenHeigth, 375.0/750.0*screenWidth, 312.0/1334.0*screenHeigth, 324.0/750.0*screenWidth));
        make.top.equalTo(self.leaderboardLabel.mas_bottom).mas_offset(19);
        make.left.mas_equalTo(373.0/750.0*screenWidth);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];
    
    self.rankingLabel = [[ZYLTitleLabel alloc] init];
    self.rankingLabel.font = [UIFont boldSystemFontOfSize:13*screenWidth/414.0];
    self.rankingLabel.text = @"名次";
    self.rankingLabel.textColor = [UIColor colorWithRed:170.0/255.0 green:174/255.0 blue:203.0/255.0 alpha:1];
    [self addSubview:self.rankingLabel];
    [self.rankingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(977.0/1334.0*screenHeigth, 39.0/750.0*screenWidth, 320.0/1334.0*screenHeigth, 660.0/750.0*screenWidth));
        make.top.equalTo(self.leaderboardLabel.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(42.0/750.0*screenWidth);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];
    
    self.rankingLabeltwo = [[ZYLTitleLabel alloc] init];
    self.rankingLabeltwo.font = [UIFont boldSystemFontOfSize:14*screenWidth/414.0];
    self.rankingLabeltwo.text = @"名";
    self.rankingLabeltwo.textColor = [UIColor colorWithRed:170.0/255.0 green:174/255.0 blue:203.0/255.0 alpha:1];
    [self addSubview:self.rankingLabeltwo];
    [self.rankingLabeltwo mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(1045.0/1334.0*screenHeigth, 106.0/750.0*screenWidth, 263.0/1334.0*screenHeigth, 602.0/750.0*screenWidth));
        make.top.equalTo(self.rankingLabel.mas_bottom).mas_offset(17);
        make.left.mas_equalTo(106.0/750.0*screenWidth);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(17);
    }];
    
    self.KMLabelTwo = [[ZYLTitleLabel alloc] init];
    self.KMLabelTwo.font = [UIFont boldSystemFontOfSize:12*screenWidth/414.00];
    self.KMLabelTwo.text = @"km";
    self.KMLabelTwo.textColor = [UIColor colorWithRed:170.0/255.0 green:174/255.0 blue:203.0/255.0 alpha:1];
    [self addSubview:self.KMLabelTwo];
    [self.KMLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(991.0/1334.0*screenHeigth, 511.0/750.0*screenWidth, 313.0/1334.0*screenHeigth, 204.0/750.0*screenWidth));
        make.top.equalTo(self.leaderboardLabel.mas_bottom).mas_offset(23);
        make.left.mas_equalTo(511.0/750.0*screenWidth);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(17);
    }];
    
    self.KMLabelThree = [[ZYLTitleLabel alloc] init];
    self.KMLabelThree.font = [UIFont boldSystemFontOfSize:12*screenWidth/414.0];
    self.KMLabelThree.text = @"km";
    self.KMLabelThree.textColor = [UIColor colorWithRed:170.0/255.0 green:174/255.0 blue:203.0/255.0 alpha:1];
    [self addSubview:self.KMLabelThree];
    [self.KMLabelThree mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(1044.0/1334.0*screenHeigth, 578.0/750.0*screenWidth, 266.0/1334.0*screenHeigth, 138.0/750.0*screenWidth));
        make.top.equalTo(self.distanceLabelTwo.mas_bottom).mas_offset(13);
        make.left.mas_equalTo(578.0/750.0*screenWidth);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(16);
    }];
    
    self.gapLabel = [[ZYLTitleLabel alloc] init];
    self.gapLabel.font = [UIFont boldSystemFontOfSize:13*screenWidth/414.0];
    self.gapLabel.text = @"距上一名还差";
    self.gapLabel.textColor = [UIColor colorWithRed:170.0/255.0 green:174/255.0 blue:203.0/255.0 alpha:1];
    [self addSubview:self.gapLabel];
    [self.gapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(1044.0/1334.0*screenHeigth, 375.0/750.0*screenWidth, 266.0/1334.0*screenHeigth, 138.0/750.0*screenWidth));
        make.top.equalTo(self.distanceLabelTwo.mas_bottom).mas_offset(9);
        make.left.mas_equalTo(373.0/750.0*screenWidth);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
}

- (void)initProgressCircle{
    self.progressCircle = [[WeProgressCircle alloc]initWithFrame:CGRectMake( 0, 0, 189.5, 185)];
    [self addSubview: self.progressCircle];
    [self.progressCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(228.0/1334.0*screenHeigth, 190.0/750*screenWidth, 736.0/1334.0*screenHeigth, 180.0/750.0*screenWidth));
        make.top.equalTo(self.mas_top).mas_offset(135.0);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(189.5);
        make.height.mas_equalTo(185);
    }];
    [self.progressCircle sendSubviewToBack:self];
    
    //圆环内的灰色文字
    self.oneDayDistanceLabel = [[ZYLTitleLabel alloc] init];
    self.oneDayDistanceLabel.font = [UIFont boldSystemFontOfSize:13*screenWidth/414.0];
    self.oneDayDistanceLabel.text = @"当天里程";
    self.oneDayDistanceLabel.textAlignment = NSTextAlignmentCenter;
    self.oneDayDistanceLabel.textColor = [UIColor colorWithRed:170.0/255.0 green:174/255.0 blue:203.0/255.0 alpha:1];
    [self addSubview:self.oneDayDistanceLabel];
    [self.oneDayDistanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(298.0/1334.0*screenHeigth, 326.0/750.0*screenWidth, 1003.0/1334.0*screenHeigth, 327.0/750.0*screenWidth));
        make.top.equalTo(self.mas_top).mas_offset(165.0);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    self.KMLabelFour = [[ZYLTitleLabel alloc] init];
    self.KMLabelFour.font = [UIFont boldSystemFontOfSize:24*screenWidth/414.0];
    self.KMLabelFour.text = @"KM";
    self.KMLabelFour.textAlignment = NSTextAlignmentCenter;
    self.KMLabelFour.textColor = [UIColor colorWithRed:170.0/255.0 green:174/255.0 blue:203.0/255.0 alpha:1];
    [self addSubview:self.KMLabelFour];
    [self.KMLabelFour mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(491.0/1334.0*screenHeigth, 345.0/750.0*screenWidth, 786.0/1334.0*screenHeigth, 336.0/750.0*screenWidth));
        make.top.equalTo(self.mas_top).mas_offset(270);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    //设置旋转的圆环
}
@end
