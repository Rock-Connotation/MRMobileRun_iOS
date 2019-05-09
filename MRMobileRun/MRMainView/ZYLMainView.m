//
//  ZYLMainView.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/3/23.
//

#import "ZYLMainView.h"
#import "ZYLArrowBtn.h"
#import "ZYLAvatarRequest.h"
#import "ZYLStudentRankViewModel.h"
#import "ZYLRecordTimeString.h"
#import "ZYLRunningRecordModel.h"

@implementation ZYLMainView
- (instancetype)init{
    if (self = [super init]) {
        self.bounds = [UIScreen mainScreen].bounds;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAvatar:) name:@"getAvatarSuccess" object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addRankData:) name:@"MyStuRankCatched" object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addRecordData:) name:@"getPersonnalRunningRecordSuccess" object:nil];
        [self initUI];
        
        return self;
    }
    return self;
}

- (void)initUI{
    
    [self initBackground];
    [self initAvatarBtu];
    [self initRunningRecordBtu];
    [self initLeaderboardBtu];
    [self initNumLabel];
    //这个是黑色显示统计数字label
    [self initRunningTime];
    [self initNameLabel];
    //    [self initTabBar];
    [self initbeginRuningBtu];
    [ZYLStudentRankViewModel ZYLGetMyStudentRankWithdtime: @"days"];
}



- (void)initBackground{
    
    self.backGroundView = [[ZYLBackgroundView alloc]init];
    [self.backGroundView initBackground];
    [self.backGroundView initRunningRecordLabel];
    [self.backGroundView initLeaderboard];
    [self.backGroundView initProgressCircle];
    [self addSubview:self.backGroundView];
    
    //设置相关背景和提示性文字
    
}



- (void)initAvatarBtu{
    self.avatarBtu = [[ZYLAvatarBtn alloc] init];
    [self addSubview:self.avatarBtu];
    [self.avatarBtu mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(52.0/1334.0*screenHeigth, 42.0/750*screenWidth, 1217.0/1334.0*screenHeigth, 643.0/750.0*screenWidth));
        make.top.equalTo(self.mas_top).mas_offset(60);
        make.left.equalTo(self.mas_left).mas_offset(30);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    self.avatarImage = [[UIImageView alloc]init];
    [self addSubview:self.avatarImage];
    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(52.0/1334.0*screenHeigth, 42.0/750*screenWidth, 1217.0/1334.0*screenHeigth, 643.0/750.0*screenWidth));
        make.top.equalTo(self.mas_top).mas_offset(60);
        make.left.equalTo(self.mas_left).mas_offset(30);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        
    }];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"myAvatar"]) {
        NSData *data = [defaults objectForKey: @"myAvatar"];
        self.avatarImage.image = [UIImage imageWithData: data scale: 1];
    }
    else{
        self.avatarImage.image = [UIImage imageNamed:@""];
        [ZYLAvatarRequest ZYLGetAvatar];
    }
    self.avatarImage.contentMode=UIViewContentModeScaleAspectFill;
    
    self.avatarImage.clipsToBounds=YES;
    
    self.avatarImage.layer.cornerRadius=65.0/4.0 *screenWidth /375.0 ;
    //设置头像按钮
}

- (void)initRunningRecordBtu{
    
    self.runingRecordBtu = [[ZYLRunningRecordBtn alloc] init];
    [self addSubview:self.runingRecordBtu];
    [self.runingRecordBtu mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(370.0/1334.0*screenHeigth, 609.0/750.0*screenWidth, 872.0/1334.0*screenHeigth, 49.0/750.0*screenWidth));
        make.top.equalTo(self.mas_top).mas_offset(205.0);
        make.right.equalTo(self.mas_right).mas_equalTo(-30);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    //设置跑步记录按钮
    
    self.runingRecordArrowBtu = [[ZYLArrowBtn alloc] init];
    [self addSubview:self.runingRecordArrowBtu];
    [self.runingRecordArrowBtu mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(791.0/1334.0*screenHeigth, 697.0/750.0*screenWidth, 511.0/1334.0*screenHeigth, 40.0/750.0*screenWidth));
        make.top.equalTo(self.mas_top).mas_offset(445);
        make.right.equalTo(self.mas_right).mas_offset(-25);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(18);
    }];
    //跑步记录箭头按钮
    
    self.backGroundOne = [[UIButton alloc]init];
    [self addSubview:self.backGroundOne];
    [self.backGroundOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(977.0/1334.0*screenHeigth, 42.0/750.0*screenWidth, 240.0/1334.0*screenHeigth, 41.0/750.0*screenWidth));
    }];
}

- (void)initLeaderboardBtu{
    
    self.leaderboardBtu = [[ZYLLeaderboardBtn alloc] init];
    [self addSubview:self.leaderboardBtu];
    [self.leaderboardBtu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.runingRecordBtu.mas_centerY);
        make.left.equalTo(self.mas_left).mas_equalTo(30);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(55);
    }];
    //设置排行榜按钮
    
    self.leaderboardArrowBtu = [[ZYLArrowBtn alloc] init];
    [self addSubview:self.leaderboardArrowBtu];
    [self.leaderboardArrowBtu mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(1015.0/1334.0*screenHeigth, 697.0/750.0*screenWidth, 287.0/1334.0*screenHeigth, 40.0/750.0*screenWidth));
        make.top.equalTo(self.mas_top).mas_offset(560);
        make.right.equalTo(self.mas_right).mas_offset(-25);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(18);
    }];
    //排行榜记录箭头按钮
    
    self.backGroundTwo = [[UIButton alloc]init];
    [self addSubview:self.backGroundTwo];
    [self.backGroundTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(782.0/1334.0*screenHeigth, 42.0/750.0*screenWidth, 461.0/1334.0*screenHeigth, 41.0/750.0*screenWidth));
    }];
}

- (void)initNumLabel{
    self.dayMileage = [[MRNumLabel alloc]init];
    [self.dayMileage setFontWithSize:80*screenWidth/414.0 andFloatTitle:0.00];
    self.dayMileage.textAlignment =NSTextAlignmentCenter;
    [self addSubview:self.dayMileage];
    [self.dayMileage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(190);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(60);
    }];
    //当日里程
    
    self.totalDistance = [[MRNumLabel alloc]init];
    [self.totalDistance setFontWithSize:32*screenWidth/414.0 andFloatTitle:0.000];
    [self addSubview:self.totalDistance];
    [self.totalDistance mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(782.0/1334.0*screenHeigth, 39.0/750.0*screenWidth, 479.0/1334.0*screenHeigth, 570.0/750.0*screenWidth));
        make.top.equalTo(self.mas_top).mas_offset(425);
        make.left.equalTo(self.mas_left).mas_offset(39.0/750.0*screenWidth);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    self.totalDistance.adjustsFontSizeToFitWidth =NO;
    //跑步记录旁的总路程
    
    self.smallTotalDistance = [[MRNumLabel alloc]init];
    [self.smallTotalDistance setFontWithSize:14*screenWidth/414.0 andFloatTitle:0.000];
    self.smallTotalDistance.textAlignment =NSTextAlignmentCenter;
    self.smallTotalDistance.text = @"0.00";
    [self addSubview:self.smallTotalDistance];
    [self.smallTotalDistance mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(994.0/1334.0*screenHeigth, 436.0/750.0*screenWidth, 316.0/1334.0*screenHeigth, 252.0/750.0*screenWidth));
        make.top.equalTo(self.mas_top).mas_offset(545);
        make.left.mas_equalTo(436.0/750.0*screenWidth);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    //排行榜旁的总路程
    
    self.smallTotalDistance.adjustsFontSizeToFitWidth =NO;
    
    self.distanceGap = [[MRNumLabel alloc]init];
    [self.distanceGap setFontWithSize:14*screenWidth/414.0 andIntTitle:0.0];
    self.distanceGap.text = @"0.00";
    [self addSubview:self.distanceGap];
    [self.distanceGap mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(1044.0/1334.0*screenHeigth, 527.0/750.0*screenWidth, 266.0/1334.0*screenHeigth, 179.0/750.0*screenWidth));
        make.top.equalTo(self.mas_top).mas_offset(573);
        make.left.mas_equalTo(527.0/750.0*screenWidth);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];
    self.distanceGap.adjustsFontSizeToFitWidth =YES;
    //设置文字自适应
    self.distanceGap.textAlignment=NSTextAlignmentCenter;
    //设置文字居中
    
    //与上一名的路程差
    
    self.Ranking = [[MRNumLabel alloc]init];
    [self.Ranking setFontWithSize:42*screenWidth/414.0 andIntTitle:0];
    self.Ranking.textAlignment =NSTextAlignmentCenter;
    self.Ranking.text = @"0";
    [self addSubview:self.Ranking];
    [self.Ranking mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(1011.0/1334.0*screenHeigth, 34.0/750.0*screenWidth, 260.0/1334.0*screenHeigth, 655.0/750.0*screenWidth));
        make.top.equalTo(self.mas_top).mas_offset(550);
        make.left.mas_equalTo(34.0/750.0*screenWidth);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(50);
    }];
    self.Ranking.adjustsFontSizeToFitWidth = YES;
    //排名
    
    
}

- (void)initRunningTime{
    
    //    MRTimeReversalModel *timeModel = [[MRTimeReversalModel alloc]init];
    
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:35*screenWidth/414.0];
    self.timeLabel.text = [ZYLRecordTimeString getTimeStringWithSecond:0];
    
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalDistance.mas_top).mas_offset(5);
        make.left.equalTo(self.backGroundView.timeRecordLabel.mas_left);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(50);
    }];
    self.Ranking.adjustsFontSizeToFitWidth = YES;
    //排名
}

- (void)initNameLabel{
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:20*screenWidth/414.0];
    self.nameLabel.textAlignment =NSTextAlignmentCenter;
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(68.0/1334.0*screenHeigth, 0/750.0*screenWidth, 1224.0/1334.0*screenHeigth, 0/750.0*screenWidth));
        make.top.equalTo(self.totalDistance.mas_top);
        make.right.equalTo(self.mas_right).mas_offset(-160);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
        
    }];
    
}

- (void)addAvatar:(NSNotification *)notification{
    self.avatarImage.image = notification.object;
}


- (void)addRankData:(NSNotification *)noti{
    self.rankModel = noti.object;
    if (self.rankModel.prev_difference) {
        self.Ranking.text = [self.rankModel.rank stringValue];
        self.smallTotalDistance.text = [self.rankModel.distance stringValue];
        self.distanceGap.text = self.rankModel.prev_difference;
        self.totalDistance.text = [self.rankModel.total stringValue];
        self.dayMileage.text = [self.rankModel.total stringValue];
    }
}

- (void)addRecordData:(NSNotification *)noti{
    ZYLRunningRecordModel *model = noti.object;
    if (model.student_id) {
        self.timeLabel.text = [ZYLRecordTimeString getTimeStringWithSecond:[model.end_time intValue] - [model.begin_time intValue]];
    }
}

- (void)initbeginRuningBtu{
   
}

@end
