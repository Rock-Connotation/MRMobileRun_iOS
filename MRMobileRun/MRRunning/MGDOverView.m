//
//  MGDOverView.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/26.
//

#import "MGDOverView.h"
#import <MapKit/MapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AFNetworking.h>
#import <SDWebImageCompat.h>
#import <SDWebImageManager.h>

#import "UIImageView+WebCache.h"
#import "HttpClient.h"
#import <Masonry.h>
#define UNITCOLOR [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1.0]

@implementation MGDOverView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //地图的View
        _mapView = [[MAMapView alloc] init];
        [self addSubview:_mapView];
        
        //温度的label
        _degree = [[UILabel alloc] init];
        _degree.font = [UIFont fontWithName:@"PingFangSC" size: 18];
        _degree.textAlignment = NSTextAlignmentCenter;
        [self.mapView addSubview:_degree];
        
        //下方显示跑步信息的View
        _backView = [[UIView alloc] init];
        [self addSubview:_backView];
        
        //用户头像
        _userIcon = [[UIImageView alloc] init];
        _userIcon.layer.masksToBounds = YES;
        _userIcon.layer.cornerRadius = 36.0;
        _userIcon.contentMode = UIViewContentModeScaleToFill;
        [self.backView addSubview:_userIcon];
        
        //用户姓名
        _userName = [[UILabel alloc] init];
        _userName.textAlignment = NSTextAlignmentLeft;
        _userName.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
        _userName.numberOfLines = 0;
        [self.backView addSubview:_userName];
        
        //展示跑步信息的一些Label
        _kmLab = [[UILabel alloc] init];
        _kmLab.textAlignment = NSTextAlignmentCenter;
        _kmLab.font = [UIFont fontWithName:@"Impact" size: 44];
        _kmLab.numberOfLines = 0;
        [self.backView addSubview:_kmLab];
        
        _km = [[UILabel alloc] init];
        _km.textAlignment = NSTextAlignmentCenter;
        _km.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];
        _km.text = @"公里";
        [self.backView addSubview:_km];
        
        _speedLab = [[UILabel alloc] init];
        _speedLab.textAlignment = NSTextAlignmentCenter;
        _speedLab.font = [UIFont fontWithName:@"Impact" size: 24];
        [self.backView addSubview:_speedLab];
        
        _speed = [[UILabel alloc] init];
        _speed.textAlignment = NSTextAlignmentCenter;
        _speed.font =  [UIFont fontWithName:@"PingFangSC-Semibold" size: 12];
        _speed.text = @"配速";
        _speed.tintColor = UNITCOLOR;
        [self.backView addSubview:_speed];
        
        _paceLab = [[UILabel alloc] init];
        _paceLab.textAlignment = NSTextAlignmentCenter;
        _paceLab.font = self.speedLab.font;
        [self.backView addSubview:_paceLab];
        
        _pace = [[UILabel alloc] init];
        _pace.textAlignment = NSTextAlignmentCenter;
        _pace.font =  _speed.font;
        _pace.text = @"步频";
        _pace.tintColor = UNITCOLOR;
        [self.backView addSubview:_pace];
        
        _timeLab = [[UILabel alloc] init];
        _timeLab.textAlignment = NSTextAlignmentCenter;
        _timeLab.font = self.speedLab.font;
        [self.backView addSubview:_timeLab];
        
        _time = [[UILabel alloc] init];
        _time.textAlignment = NSTextAlignmentCenter;
        _time.font =  self.speed.font;
        _time.text = @"时间";
        _time.tintColor = UNITCOLOR;
        [self.backView addSubview:_time];
        
        _calLab = [[UILabel alloc] init];
        _calLab.textAlignment = NSTextAlignmentCenter;
        _calLab.font = self.speedLab.font;
        [self.backView addSubview:_calLab];
        
        _cal = [[UILabel alloc] init];
        _cal.textAlignment = NSTextAlignmentCenter;
        _cal.font =  self.speed.font;
        _cal.text = @"千卡";
        _cal.tintColor = UNITCOLOR;
        [self.backView addSubview:_cal];
        
        _date = [[UILabel alloc] init];
        _date.textAlignment = NSTextAlignmentRight;
        _date.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
        [self.backView addSubview:_date];
        
        _currentTime = [[UILabel alloc] init];
        _currentTime.textAlignment = NSTextAlignmentRight;
        _currentTime.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
        [self.backView addSubview:_currentTime];
        
        
        if (@available(iOS 11.0, *)) {
            self.backView.backgroundColor = bottomColor;
            self.kmLab.tintColor = bottomTitleColor;
            self.speedLab.tintColor = bottomTitleColor;
            self.paceLab.tintColor = bottomTitleColor;
            self.timeLab.tintColor = bottomTitleColor;
            self.calLab.tintColor = bottomTitleColor;
            self.km.tintColor = kmColor;
            self.currentTime.tintColor = MGDTextColor2;
            self.date.tintColor = MGDColor2;
        } else {
            // Fallback on earlier versions
        }
        //数据测试
        [self test];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (kIs_iPhoneX) {
        [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(screenHeigth * 0.6478);
        }];
        
        [_degree mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(58);
            make.right.mas_equalTo(self.mas_right).mas_offset(-58);
            make.width.equalTo(@44);
            make.height.equalTo(@25);
        }];
        
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mapView.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(screenHeigth * 0.6478);
        }];
        
        [_date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backView.mas_top).mas_offset(14);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(266);
            make.right.mas_equalTo(self.backView.mas_right).mas_offset(-55);
            make.height.equalTo(@17);
        }];
        
        [_currentTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backView.mas_top).mas_offset(14);
            make.left.mas_equalTo(self.date.mas_right).mas_offset(5);
            make.right.mas_equalTo(self.backView.mas_right).mas_offset(-15);
            make.height.equalTo(@17);
        }];
        
    }else {
        [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(screenHeigth * 0.6222);
        }];
        
        [_degree mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(36);
            make.right.mas_equalTo(self.mas_right).mas_offset(-58);
            make.width.mas_equalTo(screenWidth * 0.1174);
            make.height.mas_equalTo(screenHeigth * 0.0493);
        }];
        
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mapView.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(screenHeigth * 0.2789);
        }];
    }
    
    [_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView.mas_top).mas_offset(screenHeigth * 0.0255);
        make.left.mas_equalTo(self.backView.mas_left).mas_offset(screenWidth * 0.0507);
        make.width.equalTo(@72);
        make.height.equalTo(@72);
    }];
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView.mas_top).mas_offset(42);
        make.left.mas_equalTo(self.userIcon.mas_right).mas_offset(screenWidth * 0.0374);
        make.width.mas_equalTo(screenWidth * 0.3387);
        make.height.mas_equalTo(screenHeigth * 0.0243);
    }];
    
    [_kmLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView.mas_top).mas_offset(screenHeigth * 0.3779 * 0.1231);
        make.right.mas_equalTo(self.backView.mas_right).mas_offset(-screenWidth * 0.136);
        make.width.mas_greaterThanOrEqualTo(screenWidth * 0.2107);
        make.height.mas_equalTo(screenHeigth * 0.2104 * 0.3779);
    }];
    
    [_km mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView.mas_top).mas_offset(54);
        make.left.mas_equalTo(self.kmLab.mas_right);
        make.bottom.mas_equalTo(self.kmLab.mas_bottom).mas_offset(-5);
        make.width.equalTo(@36);
    }];
    
    [_speedLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userIcon.mas_bottom).mas_offset(25);
        make.left.mas_equalTo(self.backView.mas_left).mas_offset(screenWidth * 0.04);
        make.width.mas_equalTo(screenWidth * 0.208);
        make.height.equalTo(@29);
    }];
    
    [_speed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.speedLab.mas_bottom).mas_offset(4);
        make.left.mas_equalTo(self.speedLab.mas_left).mas_offset(9);
        make.right.mas_equalTo(self.speedLab.mas_right).mas_offset(-7);
        make.height.equalTo(@24);
    }];
    
    [_paceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userIcon.mas_bottom).mas_offset(25);
        make.left.mas_equalTo(self.backView.mas_left).mas_offset(screenWidth * 0.2773);
        make.right.mas_equalTo(self.backView.mas_right).mas_offset(-(screenWidth * 0.5147));
        make.height.equalTo(@29);
    }];
    
    [_pace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.paceLab.mas_bottom).mas_offset(4);
        make.left.mas_equalTo(self.paceLab.mas_left).mas_offset(21);
        make.right.mas_equalTo(self.paceLab.mas_right).mas_offset(-21);
        make.height.equalTo(@24);
    }];
    
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userIcon.mas_bottom).mas_offset(25);
        make.left.mas_equalTo(self.backView.mas_left).mas_offset(screenWidth * 0.5147);
        make.right.mas_equalTo(self.backView.mas_right).mas_offset(-(screenWidth * 0.2773));
        make.height.equalTo(@29);
    }];
    
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLab.mas_bottom).mas_offset(4);
        make.left.mas_equalTo(self.timeLab.mas_left).mas_offset(21);
        make.right.mas_equalTo(self.timeLab.mas_right).mas_offset(-21);
        make.height.equalTo(@24);
    }];
    
    [_calLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userIcon.mas_bottom).mas_offset(25);
        make.left.mas_equalTo(self.backView.mas_left).mas_offset(screenWidth * 0.752);
        make.right.mas_equalTo(self.backView.mas_right).mas_offset(-(screenWidth * 0.04));
        make.height.equalTo(@29);
    }];
    
    [_cal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLab.mas_bottom).mas_offset(4);
        make.left.mas_equalTo(self.calLab.mas_left).mas_offset(21);
        make.right.mas_equalTo(self.calLab.mas_right).mas_offset(-21);
        make.height.equalTo(@24);
    }];
    
    
}

- (void)test {
   
    //设置地图相关属性
    self.mapView.zoomLevel = 18;
    self.mapView.mapType = MAMapTypeStandard; //设置地图的样式
   self.mapView.showsUserLocation = NO; //不显示小蓝点
   self.mapView.userTrackingMode = MAUserTrackingModeFollow;
   self.mapView.pausesLocationUpdatesAutomatically = NO;
   self.mapView.showsCompass = NO;
   self.mapView.showsScale = NO;
//       self.mapView.userInteractionEnabled = YES;  //是否禁止地图与用户的交互
   [self.mapView setAllowsBackgroundLocationUpdates:YES];//打开后台定位
   self.mapView.distanceFilter = 10;
//自定义用户小蓝点，不让其显示精度圈
    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
    r.showsAccuracyRing = NO;//不显示精度圈
    r.image = [UIImage imageNamed:@"userAnnotation"];
    [self.mapView updateUserLocationRepresentation:r];
    self.mapView.userInteractionEnabled = NO;
    [self getUserInfo];
    
    //判断当前的系统模式，并设定地图的自定义样式
    if (@available(iOS 13.0, *)) {
        UIUserInterfaceStyle  mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
        if (mode == UIUserInterfaceStyleDark) {
            NSLog(@"深色模式");
            NSString *path =   [[NSBundle mainBundle] pathForResource:@"style" ofType:@"data"];
            NSData *data = [NSData dataWithContentsOfFile:path];
            MAMapCustomStyleOptions *options = [[MAMapCustomStyleOptions alloc] init];
            options.styleData = data;
            [self.mapView setCustomMapStyleOptions:options];
            [self.mapView setCustomMapStyleEnabled:YES];
        } else if (mode == UIUserInterfaceStyleLight) {
            NSLog(@"浅色模式");
            NSString *path =   [[NSBundle mainBundle] pathForResource:@"style2" ofType:@"data"];
            NSData *data = [NSData dataWithContentsOfFile:path];
            MAMapCustomStyleOptions *options = [[MAMapCustomStyleOptions alloc] init];
                        options.styleData = data;
            [self.mapView setCustomMapStyleOptions:options];
            [self.mapView setCustomMapStyleEnabled:YES];
        } else {
            NSLog(@"未知模式");
        }
    }

    //天气的图片框
    self.weatherImagview = [[UIImageView alloc] init];
    [self addSubview:self.weatherImagview];
    [self.weatherImagview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.degree.mas_right).offset(8);
        make.centerY.height.equalTo(self.degree);
        make.width.mas_equalTo(25);
    }];
}
//获取用户的头像、昵称
- (void)getUserInfo {
    NSUserDefaults  *user = [NSUserDefaults standardUserDefaults];
    NSString *nickName = [user objectForKey:@"nickname"];
    NSString *imageUrl = [user objectForKey:@"avatar_url"];
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    self.userName.text = nickName;
}


@end

