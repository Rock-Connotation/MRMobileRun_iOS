//
//  MGDShareDataView.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/9/24.
//

#import "MGDShareDataView.h"
#import <Masonry.h>
#define UNITCOLOR [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1.0]

@implementation MGDShareDataView

- (instancetype)init {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        //下方显示跑步信息的View
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor clearColor];
        [self addSubview:_backView];
        
        //用户头像
        _userIcon = [[UIImageView alloc] init];
        _userIcon.backgroundColor = [UIColor clearColor];
        _userIcon.layer.masksToBounds = YES;
        _userIcon.contentMode = UIViewContentModeScaleToFill;
        [self.backView addSubview:_userIcon];
        
        //用户姓名
        _userName = [[UILabel alloc] init];
        _userName.backgroundColor = [UIColor clearColor];
        _userName.textAlignment = NSTextAlignmentLeft;
        _userName.numberOfLines = 0;
        [self.backView addSubview:_userName];
        
        //展示跑步信息的一些Label
        _kmLab = [[UILabel alloc] init];
        _kmLab.backgroundColor = [UIColor clearColor];
        _kmLab.textAlignment = NSTextAlignmentRight;
        _kmLab.numberOfLines = 0;
        [self.backView addSubview:_kmLab];
        
        _km = [[UILabel alloc] init];
        _km.backgroundColor = [UIColor clearColor];
        _km.textAlignment = NSTextAlignmentLeft;
        _km.text = @"公里";
        [self.backView addSubview:_km];
        
        _speedLab = [[UILabel alloc] init];
        _speedLab.backgroundColor = [UIColor clearColor];
        _speedLab.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:_speedLab];
        
        _speed = [[UILabel alloc] init];
        _speed.backgroundColor = [UIColor clearColor];
        _speed.textAlignment = NSTextAlignmentCenter;
        _speed.text = @"配速";
        _speed.tintColor = UNITCOLOR;
        [self.backView addSubview:_speed];
        
        _paceLab = [[UILabel alloc] init];
        _paceLab.backgroundColor = [UIColor clearColor];
        _paceLab.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:_paceLab];
        
        _pace = [[UILabel alloc] init];
        _pace.backgroundColor = [UIColor clearColor];
        _pace.textAlignment = NSTextAlignmentCenter;
        _pace.text = @"步频";
        _pace.tintColor = UNITCOLOR;
        [self.backView addSubview:_pace];
        
        _timeLab = [[UILabel alloc] init];
        _timeLab.backgroundColor = [UIColor clearColor];
        _timeLab.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:_timeLab];
        
        _time = [[UILabel alloc] init];
        _time.backgroundColor = [UIColor clearColor];
        _time.textAlignment = NSTextAlignmentCenter;
        _time.text = @"时间";
        _time.tintColor = UNITCOLOR;
        [self.backView addSubview:_time];
        
        _calLab = [[UILabel alloc] init];
        _calLab.backgroundColor = [UIColor clearColor];
        _calLab.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:_calLab];
        
        _cal = [[UILabel alloc] init];
        _cal.backgroundColor = [UIColor clearColor];
        _cal.textAlignment = NSTextAlignmentCenter;
        _cal.text = @"千卡";
        _cal.tintColor = UNITCOLOR;
        [self.backView addSubview:_cal];
        
        _date = [[UILabel alloc] init];
        _date.backgroundColor = [UIColor clearColor];
        _date.textAlignment = NSTextAlignmentRight;
        _date.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
        [self.backView addSubview:_date];
        
        _currentTime = [[UILabel alloc] init];
        _currentTime.backgroundColor = [UIColor clearColor];
        _currentTime.textAlignment = NSTextAlignmentRight;
        _currentTime.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
        [self.backView addSubview:_currentTime];
        
        if (kIs_iPhoneX) {
            _userName.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
            _kmLab.font = [UIFont fontWithName:@"Impact" size: 44];
            _km.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];
            _speedLab.font = [UIFont fontWithName:@"Impact" size: 24];
            _speed.font =  [UIFont fontWithName:@"PingFangSC-Semibold" size: 12];
        }else {
            //非全面屏手机此处信息的字体调小一点以便于全部显示
            _userName.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 13];
            _kmLab.font = [UIFont fontWithName:@"Impact" size: 38];
            _km.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
            _speedLab.font = [UIFont fontWithName:@"Impact" size: 22];
            _speed.font =  [UIFont fontWithName:@"PingFangSC-Semibold" size: 10];
        }
        _paceLab.font = self.speedLab.font;
        _pace.font =  _speed.font;
        _timeLab.font = self.speedLab.font;
        _time.font =  self.speed.font;
        _calLab.font = self.speedLab.font;
        _cal.font =  self.speed.font;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (kIs_iPhoneX) {
        CGFloat W = screenWidth * 0.92;
        CGFloat H = screenHeigth * 0.3522;
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.width.mas_equalTo(W);
            make.height.mas_equalTo(screenHeigth * 0.2057);
        }];
        
        [_date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backView.mas_top).mas_offset(H * 0.0489);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(W * 0.7093);
            make.width.mas_equalTo(W * 0.144);
            make.height.mas_equalTo(H * 0.0594);
        }];
        
        [_currentTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.date);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(W * 0.8666);
            make.width.mas_equalTo(W * 0.0933);
            make.height.mas_equalTo(_date);
        }];
        
        [_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backView.mas_top).mas_offset(H * 0.0594);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(W * 0.0506);
            make.width.height.mas_equalTo(W * 0.192);
        }];
        _userIcon.layer.cornerRadius = W * 0.192 / 2;
        
        [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backView.mas_top).mas_offset(H * 0.1468);
            make.left.mas_equalTo(self.userIcon.mas_right).mas_offset(W * 0.0373);
            make.right.mas_equalTo(self.kmLab.mas_left).mas_offset(W * 0.0346);
            make.height.mas_equalTo(H * 0.0769);
        }];
        
        [_kmLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backView.mas_top).mas_offset(H * 0.1083);
            make.right.mas_equalTo(self.backView.mas_right).mas_offset(-W * 0.136);
            make.width.mas_greaterThanOrEqualTo(W * 0.2106);
            make.height.mas_equalTo(H * 0.1853);
        }];
        
        [_km mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.kmLab.mas_top).mas_offset(H * 0.0283);
            make.left.mas_equalTo(self.kmLab.mas_right);
            make.bottom.mas_equalTo(_kmLab);
            make.right.mas_equalTo(self.mas_right).mas_offset(W * 0.01);
        }];
        
        [_speedLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.kmLab.mas_bottom).mas_offset(H * 0.0369);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(W * 0.04);
            make.width.mas_equalTo(W * 0.208);
            make.height.mas_equalTo(H * 0.1013);
        }];
        
        [_speed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.speedLab.mas_bottom).mas_offset(H * 0.0049);
            make.left.mas_equalTo(self.speedLab.mas_left).mas_offset(W * 0.024);
            make.right.mas_equalTo(self.speedLab.mas_right).mas_offset(-W * 0.0186);
            make.height.mas_equalTo(H * 0.0839);
        }];
        
        [_paceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.speedLab);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(W * 0.2773);
            make.width.mas_equalTo(self.speedLab);
            make.height.mas_equalTo(self.speedLab);
        }];
        
        [_pace mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.speed);
            make.left.mas_equalTo(self.paceLab.mas_left).mas_offset(W * 0.056);
            make.right.mas_equalTo(self.paceLab.mas_right).mas_offset(-W * 0.056);
            make.height.mas_equalTo(self.speed);
        }];
        
        [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.speedLab);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(W * 0.5146);
            make.width.mas_equalTo(self.speedLab);
            make.height.mas_equalTo(self.speedLab);
        }];
        
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.speed);
            make.left.mas_equalTo(self.timeLab.mas_left).mas_offset(W * 0.056);
            make.right.mas_equalTo(self.timeLab.mas_right).mas_offset(-W * 0.056);
            make.height.mas_equalTo(self.speed);
        }];
        
        [_calLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.speedLab);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(W * 0.752);
            make.width.mas_equalTo(self.speedLab);
            make.height.mas_equalTo(self.speedLab);
        }];
        
        [_cal mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.speed);
            make.left.mas_equalTo(self.calLab.mas_left).mas_offset(W * 0.056);
            make.right.mas_equalTo(self.calLab.mas_right).mas_offset(-W * 0.056);
            make.height.mas_equalTo(self.speed);
        }];
        
    }else {
        CGFloat W = screenWidth * 0.7761;
        CGFloat H = screenHeigth * 0.3778;
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.width.mas_equalTo(W);
            make.height.mas_equalTo(screenHeigth * 0.213);
        }];
        
        [_date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backView.mas_top).mas_offset(H * 0.0489);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(W * 0.6393);
            make.width.mas_equalTo(W * 0.204);
            make.height.mas_equalTo(H * 0.0594);
        }];
        
        [_currentTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.date);
            make.width.mas_equalTo(self.date);
            make.right.mas_equalTo(self.backView.mas_right).mas_offset(-W * 0.02);
            make.height.mas_equalTo(H * 0.0594);
        }];
        
        [_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backView.mas_top).mas_offset(H * 0.0674);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(W * 0.0506);
            make.width.height.mas_equalTo(W * 0.1921);
        }];
        _userIcon.layer.cornerRadius = W * 0.1921 / 2;
        
        [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.userIcon.mas_top).mas_offset(H * 0.0374);
            make.left.mas_equalTo(self.userIcon.mas_right).mas_offset(W * 0.0373);
            make.right.mas_equalTo(self.kmLab.mas_left).mas_offset(-W * 0.0346);
            make.bottom.mas_equalTo(self.userIcon.mas_bottom).mas_offset(-H * 0.0374 );
        }];
        
        [_kmLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(H * 0.123);
            make.right.mas_equalTo(self.backView.mas_right).mas_offset(-W * 0.136);
            make.width.mas_greaterThanOrEqualTo(W * 0.2106);
            make.height.mas_equalTo(H * 0.2103);
        }];
        
        [_km mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backView.mas_top).mas_offset(H * 0.1888);
            make.right.mas_equalTo(self.backView.mas_right);
            make.left.mas_equalTo(self.kmLab.mas_right);
            make.height.mas_equalTo(H * 0.0992);
        }];
        
        [_speedLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.kmLab.mas_bottom).mas_offset(H * 0.0374);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(W * 0.04);
            make.width.mas_equalTo(W * 0.208);
            make.height.mas_equalTo(H * 0.115);
        }];
        
        [_speed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.speedLab.mas_bottom).mas_offset(H * 0.0059);
            make.left.mas_equalTo(self.speedLab.mas_left).mas_offset(W * 0.024);
            make.right.mas_equalTo(self.speedLab.mas_right).mas_offset(-W * 0.0186);
            make.height.mas_equalTo(H * 0.0952);
        }];
        
        [_paceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.speedLab);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(W * 0.2773);
            make.width.mas_equalTo(self.speedLab);
            make.height.mas_equalTo(self.speedLab);
        }];
        
        [_pace mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.speed);
            make.left.mas_equalTo(self.paceLab.mas_left).mas_offset(W * 0.056);
            make.right.mas_equalTo(self.paceLab.mas_right).mas_offset(-W * 0.056);
            make.height.mas_equalTo(self.speed);
        }];
        
        [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.speedLab);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(W * 0.5146);
            make.width.mas_equalTo(self.speedLab);
            make.height.mas_equalTo(self.speedLab);
        }];
        
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.speed);
            make.left.mas_equalTo(self.timeLab.mas_left).mas_offset(W * 0.056);
            make.right.mas_equalTo(self.timeLab.mas_right).mas_offset(-W * 0.056);
            make.height.mas_equalTo(self.speed);
        }];
        
        [_calLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.speedLab);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(W * 0.752);
            make.width.mas_equalTo(self.speedLab);
            make.height.mas_equalTo(self.speedLab);
        }];
        
        [_cal mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.speed);
            make.left.mas_equalTo(self.calLab.mas_left).mas_offset(W * 0.056);
            make.right.mas_equalTo(self.calLab.mas_right).mas_offset(-W * 0.056);
            make.height.mas_equalTo(self.speed);
        }];
    }
}
@end
