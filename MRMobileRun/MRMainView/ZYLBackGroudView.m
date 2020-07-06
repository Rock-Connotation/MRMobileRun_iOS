//
//  ZYLBackGroudView.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/26.
//

#import "ZYLBackGroudView.h"
#import "ZYLPlateChinieseLabel.h"
#import "ZYLMediumChineseLabel.h"
#import "ZYLUnitLabel.h"
#import <Masonry.h>
@interface ZYLBackGroudView ()
@property (nonatomic, strong) ZYLPlateChinieseLabel *healthLab;
@property (nonatomic, strong) ZYLPlateChinieseLabel *runningLab;

@property (nonatomic, strong) ZYLMediumChineseLabel *stepLab;
@property (nonatomic, strong) ZYLMediumChineseLabel *stairLab;
@property (nonatomic, strong) ZYLMediumChineseLabel *distanceLab;
@property (nonatomic, strong) ZYLMediumChineseLabel *timeLab;
@property (nonatomic, strong) ZYLMediumChineseLabel *distanceLab2;
@property (nonatomic, strong) ZYLMediumChineseLabel *consumeLab;

@property (nonatomic, strong) ZYLUnitLabel *steps_1;
@property (nonatomic, strong) ZYLUnitLabel *stairs;
@property (nonatomic, strong) ZYLUnitLabel *kilometers_1;
@property (nonatomic, strong) ZYLUnitLabel *time_1;
@property (nonatomic, strong) ZYLUnitLabel *kilometer_2;
@property (nonatomic, strong) ZYLUnitLabel *time_2;

@property (nonatomic, strong) UIImageView *stepsImage;
@property (nonatomic, strong) UIImageView *stairImage;
@property (nonatomic, strong) UIImageView *distanceImage;
@property (nonatomic, strong) UIImageView *timeImage;
@property (nonatomic, strong) UIImageView *distanceImage2;
@property (nonatomic, strong) UIImageView *consumeImage;
@end

@implementation ZYLBackGroudView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.bounds = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor whiteColor];
//        self.scrollEnabled = YES;
////       禁止回弹效果
//        self.alwaysBounceHorizontal = NO;
////        禁止显示指示条
//        self.showsVerticalScrollIndicator = NO;
//        self.showsHorizontalScrollIndicator = NO;
        [self initStepsBanner];
        [self initStairsBanner];
        [self initDistanceBanner];
        [self initExerciseTimeBanner];
        [self initStepRateBanner];
        [self initConsumeBanner];
    }
    return self;
}

- (void)initStepsBanner{
    self.healthLab = [[ZYLPlateChinieseLabel alloc] init];
    self.healthLab.text = @"健康";
    [self addSubview: self.healthLab];
    [self.healthLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(90*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(15*kRateX);
        make.width.mas_offset(40*kRateX);
        make.height.mas_offset(25*kRateY);
    }];
    
    self.stepsImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"homepage_pace"]];
    [self addSubview: self.stepsImage];
    [self.stepsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.healthLab.mas_bottom);
        make.left.equalTo(self.mas_left).mas_offset(20*kRateX);
        make.width.mas_offset(24*kRateX);
        make.height.mas_offset(24*kRateY);
    }];
    
    self.stepLab = [[ZYLMediumChineseLabel alloc] init];
    self.stepLab.text = @"步数";
    [self addSubview: self.stepLab];
    [self.stepLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stepsImage.mas_centerY);
        make.left.equalTo(self.stepsImage.mas_right).mas_offset(5*kRateX);
        make.width.mas_offset(24*kRateX);
        make.height.mas_offset(17*kRateY);
    }];
    
    self.steps_1 = [[ZYLUnitLabel alloc] init];
    self.steps_1.text = @"步";
    [self addSubview: self.steps_1];
    [self.steps_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stepLab.mas_bottom).mas_offset(14*kRateY);
        make.left.equalTo(self.stepLab.mas_right).mas_offset(22*kRateX);
        make.width.mas_offset(14*kRateX);
        make.height.mas_offset(20*kRateY);
    }];
}

- (void)initStairsBanner{
    self.stairImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homepage_stairs"]];
    [self addSubview: self.stairImage];
    [self.stairImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stepLab.mas_bottom).mas_offset(116*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(20*kRateX);
        make.width.mas_offset(24*kRateX);
        make.height.mas_offset(24*kRateY);
    }];
    
    self.stairLab = [[ZYLMediumChineseLabel alloc] init];
    self.stairLab.text = @"已爬楼梯";
    [self addSubview: self.stairLab];
    [self.stairLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stairImage.mas_centerY);
        make.left.equalTo(self.stairImage.mas_right).mas_offset(5*kRateX);
        make.width.mas_offset(48*kRateX);
        make.height.mas_offset(17*kRateY);
    }];
    
    self.stairs = [[ZYLUnitLabel alloc] init];
    self.stairs.text = @"阶";
    [self addSubview: self.stairs];
    [self.stairs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stairImage.mas_bottom).mas_offset(14*kRateY);
        make.left.equalTo(self.stairImage.mas_right).mas_offset(27*kRateX);
        make.width.mas_offset(14*kRateX);
        make.height.mas_offset(20*kRateY);
    }];
}

- (void) initDistanceBanner{
    self.runningLab = [[ZYLPlateChinieseLabel alloc] init];
    self.runningLab.text = @"跑步";
    [self addSubview: self.runningLab];
    [self.runningLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.healthLab.mas_bottom).mas_offset(280*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(15*kRateX);
        make.width.mas_offset(40*kRateX);
        make.height.mas_offset(25*kRateY);
    }];
    
    self.distanceImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"homepage_kilometer"]];
    [self addSubview: self.distanceImage];
    [self.distanceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.runningLab.mas_bottom);
        make.left.equalTo(self.mas_left).mas_offset(20*kRateX);
        make.width.mas_offset(24*kRateX);
        make.height.mas_offset(24*kRateY);
    }];
    
    self.distanceLab = [[ZYLMediumChineseLabel alloc] init];
    self.distanceLab.text = @"里程";
    [self addSubview: self.distanceLab];
    [self.distanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.distanceImage.mas_centerY);
        make.left.equalTo(self.distanceImage.mas_right).mas_offset(5*kRateX);
        make.width.mas_offset(24*kRateX);
        make.height.mas_offset(17*kRateY);
    }];
    
    self.kilometers_1 = [[ZYLUnitLabel alloc] init];
    self.kilometers_1.text = @"公里";
    [self addSubview: self.kilometers_1];
    [self.kilometers_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceLab.mas_bottom).mas_offset(14*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(65*kRateX);
        make.width.mas_offset(30*kRateX);
        make.height.mas_offset(20*kRateY);
    }];
}

- (void)initExerciseTimeBanner{
    self.timeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"homepage_time"]];
    [self addSubview: self.timeImage];
    [self.timeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceImage.mas_bottom).mas_offset(84*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(20*kRateX);
        make.width.mas_offset(24*kRateX);
        make.height.mas_offset(24*kRateY);
    }];
    
    self.timeLab = [[ZYLMediumChineseLabel alloc] init];
    self.timeLab.text = @"运动时间";
    [self addSubview: self.timeLab];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeImage.mas_centerY);
        make.left.equalTo(self.timeImage.mas_right).mas_offset(5*kRateX);
        make.width.mas_offset(48*kRateX);
        make.height.mas_offset(17*kRateY);
    }];
    
    self.time_1 = [[ZYLUnitLabel alloc] init];
    self.time_1.text = @"时间";
    [self addSubview: self.time_1];
    [self.time_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLab.mas_bottom).mas_offset(14*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(71*kRateX);
        make.width.mas_offset(28*kRateX);
        make.height.mas_offset(20*kRateY);
    }];
}

- (void)initStepRateBanner{
    self.distanceImage2 = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"homepage_pace"]];
    [self addSubview: self.distanceImage2];
    [self.distanceImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeImage.mas_bottom).mas_offset(84*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(20*kRateX);
        make.width.mas_offset(24*kRateX);
        make.height.mas_offset(24*kRateY);
    }];
    
    self.distanceLab2 = [[ZYLMediumChineseLabel alloc] init];
    self.distanceLab2.text = @"步频";
    [self addSubview: self.distanceLab2];
    [self.distanceLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.distanceImage2.mas_centerY);
        make.left.equalTo(self.distanceImage2.mas_right).mas_offset(5*kRateX);
        make.width.mas_offset(24*kRateX);
        make.height.mas_offset(17*kRateY);
    }];
    
    self.kilometer_2 = [[ZYLUnitLabel alloc] init];
    self.kilometer_2.text = @"公里";
    [self addSubview: self.kilometer_2];
    [self.kilometer_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceLab2.mas_bottom).mas_offset(14*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(71*kRateX);
        make.width.mas_offset(28*kRateX);
        make.height.mas_offset(20*kRateY);
    }];
}

- (void)initConsumeBanner{
    self.consumeImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"homepage_consume"]];
    [self addSubview: self.consumeImage];
    [self.consumeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceImage2.mas_bottom).mas_offset(84*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(20*kRateX);
        make.width.mas_offset(24*kRateX);
        make.height.mas_offset(24*kRateY);
    }];
    
    self.consumeLab = [[ZYLMediumChineseLabel alloc] init];
    self.consumeLab.text = @"消耗";
    [self addSubview: self.consumeLab];
    [self.consumeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.consumeImage.mas_centerY);
        make.left.equalTo(self.consumeImage.mas_right).mas_offset(5*kRateX);
        make.width.mas_offset(24*kRateX);
        make.height.mas_offset(17*kRateY);
    }];
    
    self.time_2 = [[ZYLUnitLabel alloc] init];
    self.time_2.text = @"时间";
    [self addSubview: self.time_2];
    [self.time_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.consumeLab.mas_bottom).mas_offset(14*kRateY);
        make.left.equalTo(self.mas_right).mas_offset(71*kRateX);
        make.width.mas_offset(28*kRateX);
        make.height.mas_offset(20*kRateY);
    }];
}
@end
