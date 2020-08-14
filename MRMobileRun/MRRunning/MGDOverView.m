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
            make.height.mas_equalTo(screenHeigth - 100 - screenHeigth * 0.6478);
        }];
        
        [_date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backView.mas_top).mas_offset(14);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(266);
            make.width.equalTo(@54);
            make.height.equalTo(@17);
        }];
        
        [_currentTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backView.mas_top).mas_offset(15);
            make.left.mas_equalTo(self.date.mas_right).mas_offset(5);
            make.width.equalTo(@35);
            make.height.equalTo(@17);
        }];
        
    }else {
        [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.equalTo(@415);
        }];
        
        [_degree mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(36);
            make.right.mas_equalTo(self.mas_right).mas_offset(-58);
            make.width.equalTo(@44);
            make.height.equalTo(@25);
        }];
        
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(415);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-66);
        }];
    }
    
    [_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView.mas_top).mas_offset(17);
        make.left.mas_equalTo(self.backView.mas_left).mas_offset(19);
        make.width.equalTo(@72);
        make.height.equalTo(@72);
    }];
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView.mas_top).mas_offset(42);
        make.left.mas_equalTo(self.userIcon.mas_right).mas_offset(14);
        make.width.equalTo(@127);
        make.height.equalTo(@22);
    }];
    
    [_kmLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView.mas_top).mas_offset(31);
        make.right.mas_equalTo(self.km.mas_left);
        make.width.mas_greaterThanOrEqualTo(79);
        make.height.equalTo(@53);
    }];
    
    [_km mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView.mas_top).mas_offset(54);
        make.right.mas_equalTo(self.backView.mas_right).mas_offset(-15);
        make.width.equalTo(@36);
        make.height.equalTo(@25);
    }];
    
    [_speedLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userIcon.mas_bottom).mas_offset(25);
        make.left.mas_equalTo(self.backView.mas_left).mas_offset(15);
        make.width.equalTo(@78);
        make.height.equalTo(@29);
    }];
    
    [_speed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.speedLab.mas_bottom).mas_offset(4);
        make.left.mas_equalTo(self.backView.mas_left).mas_offset(24);
        make.width.equalTo(@62);
        make.height.equalTo(@24);
    }];
    
    [_paceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userIcon.mas_bottom).mas_offset(25);
        make.left.mas_equalTo(self.backView.mas_left).mas_offset(104);
        make.width.equalTo(@78);
        make.height.equalTo(@29);
    }];
    
    [_pace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.paceLab.mas_bottom).mas_offset(4);
        make.left.mas_equalTo(self.backView.mas_left).mas_offset(125);
        make.width.equalTo(@36);
        make.height.equalTo(@24);
    }];
    
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userIcon.mas_bottom).mas_offset(25);
        make.right.mas_equalTo(self.backView.mas_right).mas_offset(-104);
        make.width.equalTo(@78);
        make.height.equalTo(@29);
    }];
    
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLab.mas_bottom).mas_offset(4);
        make.right.mas_equalTo(self.backView.mas_right).mas_offset(-125);
        make.width.equalTo(@36);
        make.height.equalTo(@24);
    }];
    
    [_calLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userIcon.mas_bottom).mas_offset(25);
        make.right.mas_equalTo(self.backView.mas_right).mas_offset(-15);
        make.width.equalTo(@78);
        make.height.equalTo(@29);
    }];
    
    [_cal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLab.mas_bottom).mas_offset(4);
        make.right.mas_equalTo(self.backView.mas_right).mas_offset(-36);
        make.width.equalTo(@36);
        make.height.equalTo(@24);
    }];
    
    
}

- (void)test {
   
    //设置地图相关属性
       self.mapView.zoomLevel = 18;
    self.mapView.showsUserLocation = NO;
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
    
    
    //测试温度
    _degree.text = @"23°C";
//    //测试头像
//    _userIcon.image = [UIImage imageNamed:@"avatar"];
//    //测试用户名
//    _userName.text = @"你的寒王";
        [self getUserInfo];
    
    //测试公里数
    _kmLab.text = @"37.26";
    //测试配速
    _speedLab.text = @"3'55''";
    //测试步频
    _paceLab.text = @"132";
    //测试时间
    _timeLab.text = @"6:16";
    //测试千卡
    _calLab.text = @"131";
    //测试日期
    _date.text = @"10月23日";
    //测试时间
    _currentTime.text = @"20:36";
}
//网络请求 ，从网络上获取用户的头像、昵称
- (void)getUserInfo {
               HttpClient *client = [HttpClient defaultClient];
              NSUserDefaults  *user = [NSUserDefaults standardUserDefaults];
               NSString *student_id = [user objectForKey:@"studentID"];
               NSString *pwd = [user objectForKey:@"password"];
               NSDictionary *param = @{@"studentId":student_id,@"password":pwd};
               NSDictionary *head = @{@"Content-Type":@"application/x-www-form-urlencoded"};
               [client requestWithHead:kLoginURL method:HttpRequestPost parameters:param head:head prepareExecute:^
                {
                    //
                } progress:^(NSProgress *progress)
                {
                    //
                } success:^(NSURLSessionDataTask *task, id responseObject)
                {
//                    self->_userModel = [MGDUserInfo InfoWithDict:responseObject[@"data"]];
//                    [self reloadUserInfo:self->_userModel];
                   NSString *imageUrl = responseObject[@"data"][@"avatar_url"];
                   [self.userIcon sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
                   
                   NSString *nickName = responseObject[@"data"][@"nickname"];
                   self.userName.text = nickName;
       //            NSDictionary *dict = responseObject[@"data"];
       //            MGDUserInfo *model = [[MGDUserInfo alloc] init];
       //            model.userName = [dict objectForKey:@"nickname"];
       //            model.userSign = [dict objectForKey:@"signature"];
       //            model.userIcon = [dict objectForKey:@"avatar_url"];
       //            [self reloadUserInfo:model];
                   
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    //
                    NSLog(@"%@",error);
                }];
       }

@end
