//
//  ZYLHostView.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/26.
//

#import "ZYLHostView.h"
#import "ZYLBackGroudView.h"
#import "ZYLNumLabel.h"
#import "ZYLRedBar.h"
#import "ZYLGraybar.h"
#import <Masonry.h>

@implementation ZYLHostView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.bounds = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        self.scrollEnabled = YES;
//       禁止回弹效果
//        self.alwaysBounceVertical = NO;
        self.alwaysBounceHorizontal = NO;
//        禁止显示指示条
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        [self initBackGround];
        [self initGreetLabel];
        [self initWeatherBanner];
        [self initNumLabels];
        [self initBars];
    }
    return self;
}

- (void)initBackGround{
    self.bkg = [[ZYLBackGroudView alloc] init];
    self.bkg.frame = [UIScreen mainScreen].bounds;
    [self addSubview: self.bkg];
}

- (void)initGreetLabel{
    self.greetLab = [[UILabel alloc] init];
    self.greetLab.textColor = COLOR_WITH_HEX(0xA0A0A0);
    self.greetLab.textAlignment = NSTextAlignmentLeft;
    self.greetLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14*kRateX];
    [self addSubview: self.greetLab];
    [self.greetLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(63*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(15*kRateX);
        make.width.mas_offset(230*kRateX);
        make.height.mas_offset(20*kRateY);
    }];
}

- (void)initWeatherBanner{
    self.weatherImage = [[UIImageView alloc] init];
    [self addSubview: self.weatherImage];
    [self.weatherImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(60*kRateY);
        make.right.equalTo(self.mas_right).mas_offset(23*kRateX);
        make.width.mas_offset(24*kRateX);
        make.height.mas_offset(27*kRateY);
    }];
    
    self.weatherLab = [[UILabel alloc] init];
    self.weatherLab.textColor = COLOR_WITH_HEX(0x64686F);
    self.weatherLab.textAlignment = NSTextAlignmentLeft;
    self.weatherLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18*kRateX];
    [self addSubview:self.weatherLab];
    [self.weatherLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(60*kRateY);
        make.right.equalTo(self.weatherImage.mas_left).mas_offset(10*kRateX);
        make.width.mas_offset(44*kRateX);
        make.height.mas_offset(25*kRateY);
    }];
}

- (void)initNumLabels{
    self.stepLab = [[ZYLNumLabel alloc] init];
    [self addSubview:self.stepLab];
    [self.stepLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(137*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(15*kRateX);
        make.width.mas_offset(68*kRateX);
        make.height.mas_offset(33*kRateY);
    }];
    
    self.stairLab = [[ZYLNumLabel alloc] init];
    [self addSubview:self.stairLab];
    [self.stairLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stepLab.mas_bottom).mas_offset(110*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(15*kRateX);
        make.width.mas_offset(43*kRateX);
        make.height.mas_offset(33*kRateY);
    }];
    
    self.distanceLab_1 = [[ZYLNumLabel alloc] init];
    [self addSubview:self.distanceLab_1];
    [self.distanceLab_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stairLab.mas_bottom).mas_offset(130*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(15*kRateX);
        make.width.mas_offset(50*kRateX);
        make.height.mas_offset(33*kRateY);
    }];
    
    self.timeLab = [[ZYLNumLabel alloc] init];
    [self addSubview:self.timeLab];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceLab_1.mas_bottom).mas_offset(77*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(15*kRateX);
        make.width.mas_offset(50*kRateX);
        make.height.mas_offset(33*kRateY);
    }];
    
    self.distanceLab_2 = [[ZYLNumLabel alloc] init];
    [self addSubview:self.distanceLab_2];
    [self.distanceLab_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLab.mas_bottom).mas_offset(77*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(15*kRateX);
        make.width.mas_offset(50*kRateX);
        make.height.mas_offset(33*kRateY);
    }];
    
    self.consumeLab = [[ZYLNumLabel alloc] init];
    [self addSubview:self.consumeLab];
    [self.consumeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceLab_2.mas_bottom).mas_offset(77*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(15*kRateX);
        make.width.mas_offset(50*kRateX);
        make.height.mas_offset(33*kRateY);
    }];
}

- (void)initBars{
    self.todayStepBar = [[ZYLRedBar alloc] init];
    [self addSubview: self.todayStepBar];
    [self.todayStepBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stepLab.mas_bottom);
        make.left.equalTo(self.mas_left).mas_offset(15*kRateX);
        make.width.mas_offset(338*kRateX);
        make.height.mas_offset(25*kRateY);
    }];
//    self.todayStepBar.barTittle = @"今日步数";
//    self.todayStepBar.barWidth = 25;
//    [self.todayStepBar setBarProgress:1.0];
    self.todayStepBar.textLabStr = @"今日步数";
    
    self.yesterdayStepBar = [[ZYLGraybar alloc] init];
//    self.yesterdayStepBar.barTittle = @"昨日步数";
//    self.yesterdayStepBar.barText = @"4431步";
    [self addSubview: self.yesterdayStepBar];
    [self.yesterdayStepBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.todayStepBar.mas_bottom).mas_offset(11*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(15*kRateX);
        make.width.mas_offset(338*kRateX);
        make.height.mas_offset(25*kRateY);
    }];
    self.yesterdayStepBar.textLabStr = @"昨日步数";
    self.yesterdayStepBar.dataLabStr = @"4431步";
    
    self.todayStairBar = [[ZYLRedBar alloc] init];
//    [self.todayStairBar setBarTittle: @"今日阶梯"];;
    [self addSubview: self.todayStairBar];
    [self.todayStairBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stairLab.mas_bottom).mas_offset(15*kRateX);
        make.left.equalTo(self.mas_left).mas_offset(15*kRateX);
        make.width.mas_offset(338*kRateX);
        make.height.mas_offset(25*kRateY);
    }];
    self.todayStairBar.textLabStr = @"今日阶梯";
       
    self.yesterdayStairBar = [[ZYLGraybar alloc] init];
//    self.yesterdayStairBar.barTittle = @"昨日阶梯";
//    self.yesterdayStairBar.barText = @"441阶";
    [self addSubview: self.yesterdayStairBar];
    [self.yesterdayStairBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.todayStairBar.mas_bottom).mas_offset(11*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(15*kRateX);
        make.width.mas_offset(338*kRateX);
        make.height.mas_offset(25*kRateY);
    }];
    self.yesterdayStairBar.textLabStr = @"昨日阶梯";
    self.yesterdayStairBar.dataLabStr = @"441阶";
    
    self.distanceBar_1 = [[ZYLRedBar alloc] init];
//    self.distanceBar_1.barTittle = @"昨日里程";
    [self addSubview: self.distanceBar_1];
    [self.distanceBar_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceLab_1.mas_bottom).mas_offset(15*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(15*kRateX);
        make.width.mas_offset(338*kRateX);
        make.height.mas_offset(25*kRateY);
    }];
    self.distanceBar_1.textLabStr = @"昨日里程";
    
    self.timeBar = [[ZYLRedBar alloc] init];
//    self.timeBar.barTittle = @"昨日运动时间";
    [self addSubview: self.timeBar];
    [self.timeBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLab.mas_bottom).mas_offset(15*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(15*kRateX);
        make.width.mas_offset(338*kRateX);
        make.height.mas_offset(25*kRateY);
    }];
    self.timeBar.textLabStr = @"昨日运动时间";

    self.distanceBar_2 = [[ZYLRedBar alloc] init];
//    self.distanceBar_2.barTittle = @"上次里程";
    [self addSubview: self.distanceBar_2];
    [self.distanceBar_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceLab_2.mas_bottom).mas_offset(15*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(15*kRateY);
        make.width.mas_offset(338*kRateX);
        make.height.mas_offset(25*kRateY);
    }];
    self.distanceBar_2.textLabStr = @"上次里程";

    self.consumeBar = [[ZYLRedBar alloc] init];
//    self.consumeBar.barTittle = @"上次运动时间";
    [self addSubview: self.consumeBar];
    [self.consumeBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.consumeLab.mas_bottom).mas_offset(15*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(15*kRateX);
        make.width.mas_offset(338*kRateX);
        make.height.mas_offset(25*kRateY);
    }];
    self.consumeBar.textLabStr = @"上次运动时间";
}

- (void)setTextOfStepLab:(NSString *)steps andStairLab:(NSString *)stairs{
    self.stepLab.text = steps;
    self.stairLab.text = stairs;
}

@end
