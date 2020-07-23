//
//  RunningMainPageView.m
//  MRMobileRun
//
//  Created by 石子涵 on 2020/7/10.
//

#import "RunningMainPageView.h"
#import "RunningModel.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <Masonry.h>
//屏幕的宽和高
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHight [UIScreen mainScreen].bounds.size.height

@implementation RunningMainPageView

//初始化View
- (void)mainRunView{
    [self addMapView];
    [self addViewOnMap];
    [self addViewOnBottomView];
    [self addViewOnTopView];
    [self addViewsOnBtn];
    
   
    
}

//添加地图视图
- (void)addMapView{
    //添加地图
    self.mapView = [[MAMapView alloc] init];
    self.mapView.mapType = MAMapTypeStandard;  //设置地图类型
    //定位以后改变地图的图层显示
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    [self addSubview:self.mapView];
    //设置地图位置：
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-10);
        }];
    //设置地图相关属性
    self.mapView.zoomLevel = 18;
    self.mapView.showsUserLocation = YES;
    self.mapView.pausesLocationUpdatesAutomatically = NO;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    self.mapView.userInteractionEnabled = YES;
    [self.mapView setAllowsBackgroundLocationUpdates:YES];//打开后台定位
    self.mapView.distanceFilter = 10;
}

//在地图上添加控件
- (void)addViewOnMap{
    

   
    //设置一个未显示地图时白色的蒙板
    self.topView = [[UIView alloc] init];
    [self.mapView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.mapView);
//        make.bottom.equalTo(self.bottomView.mas_top);
    }];
        //适配深色模式
    if (@available(iOS 11.0, *)) {
        self.topView.backgroundColor = WhiteColor;
    } else {
        // Fallback on earlier versions
    }
    self.topView.alpha = 0.7;
    
    //下面的白色View
       self.bottomView = [[UIView alloc] init];
       [self.mapView addSubview:self.bottomView];
       [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.mas_top).offset(kScreenHight * 0.5369);
           make.bottom.equalTo(self.mas_bottom);
           make.width.mas_equalTo(kScreenWidth);
       }];
        //适配深色模式
       if (@available(iOS 11.0, *)) {
           self.bottomView.backgroundColor = WhiteColor;
       } else {
           // Fallback on earlier versions
       }
       self.bottomView.layer.cornerRadius = 22;
       self.bottomView.layer.shadowColor = [UIColor colorWithRed:73/255.0 green:80/255.0 blue:90/255.0 alpha:0.1].CGColor;
       self.bottomView.layer.shadowOpacity = 1;
       self.bottomView.layer.shadowRadius = 6;
       
}

//在底部视图上添加控件
- (void)addViewOnBottomView{
#pragma mark- 配速相关
      //图片框
    self.speedImgView = [[UIImageView alloc] init];
    [self.bottomView addSubview:self.speedImgView];
    [self.speedImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kScreenWidth * 0.1707);
        make.top.equalTo(self.bottomView.mas_top).offset(kScreenHight * 0.0435);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    self.speedImgView.image = [UIImage imageNamed:@"配速灰"];
    
     //显示数字的lable
    self.speedNumberLbl = [[UILabel alloc] init];
    [self.bottomView addSubview:self.speedNumberLbl];
    [self.speedNumberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.speedImgView);
        make.top.equalTo(self.speedImgView.mas_bottom).offset(kScreenHight * 0.0225);
        make.size.mas_equalTo(CGSizeMake(90, 34));
    }];
//    self.speedNumberLbl.font = [UIFont fontWithName:@"Impact" size: 28];
    self.speedNumberLbl.font = [UIFont systemFontOfSize:28];
    self.speedNumberLbl.textColor = [UIColor colorWithRed:65/255.0 green:68/255.0 blue:72/255.0 alpha:1.0];
    self.speedNumberLbl.textAlignment = NSTextAlignmentCenter;
    self.speedNumberLbl.text = @"3'55''";
    //显示“配速”的label
    self.speedLbl = [[UILabel alloc] init];
    [self.bottomView addSubview:self.speedLbl];
    [self.speedLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.speedImgView.mas_centerX);
        make.top.equalTo(self.speedNumberLbl.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(54, 24));
    }];
    self.speedLbl.font = [UIFont fontWithName:@"PingFangSC" size: 14];
    self.speedLbl.textColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1.0];
    self.speedLbl.textAlignment = NSTextAlignmentCenter;
    self.speedLbl.text = @"配速";
    

#pragma mark- 时间相关
        //时间的图片
    self.timeImgView = [[UIImageView alloc] init];
    [self.bottomView addSubview:self.timeImgView];
    [self.timeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.speedImgView.mas_centerY);
        make.left.equalTo(self.speedImgView.mas_right).offset(kScreenWidth * 0.256);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    self.timeImgView.image = [UIImage imageNamed:@"时间灰"];
    
        //显示时间的数字的lable
    self.timeNumberLbl = [[UILabel alloc] init];
    [self.bottomView addSubview:self.timeNumberLbl];
    [self.timeNumberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.timeImgView);
        make.centerY.equalTo(self.speedNumberLbl);
        make.size.mas_equalTo(CGSizeMake(108, 34));
    }];
    self.timeNumberLbl.font = self.speedNumberLbl.font;
    self.timeNumberLbl.textColor = self.speedNumberLbl.textColor;
    self.timeNumberLbl.textAlignment = self.speedNumberLbl.textAlignment;
    self.timeNumberLbl.text = @"03:26";
        //显示“时间”的label
    self.timeLbl = [[UILabel alloc] init];
    [self.bottomView addSubview:self.timeLbl];
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.timeImgView.mas_centerX);
        make.centerY.equalTo(self.speedLbl.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(54, 24));
    }];
    self.timeLbl.font = self.speedLbl.font;
    self.timeLbl.textColor = self.speedLbl.textColor;
    self.timeLbl.textAlignment = NSTextAlignmentCenter;
    self.timeLbl.text = @"时间";
    
    
#pragma mark- 燃烧卡路里
                //燃烧卡路里的图标
    self.energyImgView = [[UIImageView alloc] init];
    [self.bottomView addSubview:self.energyImgView];
    [self.energyImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.speedImgView);
//        make.left.equalTo(self.timeImgView.mas_right).offset(kScreenWidth * 0.272);
        make.right.equalTo(self.mas_right).offset(-kScreenWidth * 0.1703);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    self.energyImgView.image = [UIImage imageNamed:@"千卡灰色"];
    
                //燃烧多少卡路里的数字
    self.energyNumberLbl = [[UILabel alloc] init];
    [self.bottomView addSubview:self.energyNumberLbl];
    [self.energyNumberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.energyImgView);
        make.centerY.equalTo(self.speedNumberLbl);
        make.size.mas_equalTo(CGSizeMake(90, 34));
    }];
    self.energyNumberLbl.font = self.speedNumberLbl.font;
    self.energyNumberLbl.textColor = self.speedNumberLbl.textColor;
    self.energyNumberLbl.textAlignment = NSTextAlignmentCenter;
    self.energyNumberLbl.text = @"71";
            
                //显示“卡路里”的lable
    self.energyLbl = [[UILabel alloc] init];
    [self.bottomView addSubview:self.energyLbl];
    [_energyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.energyImgView);
        make.centerY.equalTo(self.speedLbl);
        make.size.mas_equalTo(CGSizeMake(46, 24));
    }];
    self.energyLbl.font = self.speedLbl.font;
    self.energyLbl.textColor = self.speedLbl.textColor;
    self.energyLbl.text = @"千卡";
    self.energyLbl.textAlignment = NSTextAlignmentCenter;
    
    
    #pragma mark- 可拖拽使得View高度变化的label
    self.dragLabel = [[UILabel alloc] init];
//    _dragLabel.backgroundColor = [UIColor redColor];
    [self.bottomView addSubview:self.dragLabel];
    [self.dragLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.speedLbl.mas_left);
        make.right.equalTo(self.energyLbl.mas_right);
        make.top.equalTo(self.bottomView.mas_top);
        make.bottom.equalTo(self.timeImgView.mas_top);
    }];
    
    #pragma mark- 关于按钮
    
#pragma mark- 锁屏按钮
    self.lockBtn = [[UIButton alloc] init];
    [self.bottomView addSubview:self.lockBtn];
    [self.lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.speedImgView);
        make.top.equalTo(self.speedLbl.mas_bottom).offset(kScreenHight * 0.0843);
        make.size.mas_equalTo(CGSizeMake(24, 26));
    }];
    //图片
//    self.lockBtn.imageView.image = [UIImage imageNamed:@"smallLockImage"];
    [self.lockBtn setImage:[UIImage imageNamed:@"smallLockImage"] forState:UIControlStateNormal];
    
    self.lockBtn.hidden = NO;
    
    #pragma mark- 暂停按钮
    self.pauseBtn = [[UIButton alloc] init];
    [self.bottomView addSubview:self.pauseBtn];
    [self.pauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.timeImgView);
        make.centerY.equalTo(self.lockBtn);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    self.pauseBtn.layer.cornerRadius = 45;
//    self.pauseBtn.clipsToBounds = YES;
    self.pauseBtn.layer.masksToBounds = 45 ? YES : NO;
    if (@available(iOS 11.0, *)) {
        self.pauseBtn.backgroundColor = GrayColor;
    } else {
        // Fallback on earlier versions
    }
    //图片
    
//    self.pauseBtn.imageView.image = [UIImage imageNamed:@"pauseBtnImage"];
    self.pauseBtn.hidden = NO;
    
    
       #pragma mark- 结束的View （相当于button）
    self.endLongPressView = [[LongPressView alloc] init];
    [self.endLongPressView initLongPressView];
    [self.bottomView addSubview:self.endLongPressView];
    [self.endLongPressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kScreenWidth * 0.2213);
        make.top.equalTo(self.bottomView.mas_top).offset(kScreenHight * 0.2153);
        make.size.mas_equalTo(CGSizeMake(102, 102));
    }];
    self.endLongPressView.bgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:92/255.0 blue:119/255.0 alpha:1.0];
        //设置titlelabel
//    self.endLongPressView.titleLbl.font =  [UIFont fontWithName:@"PingFangSC" size: 12];
     self.endLongPressView.titleLbl.font = [UIFont fontWithName:@"PingFangSC" size: 12];
    self.endLongPressView.titleLbl.textColor = self.pauseLabel.textColor;
    self.endLongPressView.titleLbl.text = @"长按结束";
        //图片框的图片，等待后置
    self.endLongPressView.imgView.image = [UIImage imageNamed:@"endBtnImage"];
    self.endLongPressView.layer.cornerRadius = 51;
    self.endLongPressView.layer.masksToBounds = YES;
    self.endLongPressView.hidden = YES;
    
    
     #pragma mark- 继续按钮
    self.continueBtn = [[UIButton alloc] init];
    [self.bottomView addSubview:self.continueBtn];
    [self.continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.endtBtn);
        make.left.equalTo(self.endtBtn.mas_right).offset(kScreenWidth * 0.08);
        make.size.equalTo(self.endtBtn);
    }];
        //图片
    self.continueBtn.imageView.image = [UIImage imageNamed:@"continueBtnImage"];
    
    self.continueBtn.backgroundColor = [UIColor colorWithRed:85/255.0 green:213/255.0 blue:226/255.0 alpha:1.0];
    self.continueBtn.layer.cornerRadius = self.endtBtn.layer.cornerRadius;
    self.continueBtn.layer.masksToBounds = self.endtBtn.layer.masksToBounds;
    self.continueBtn.hidden = YES;
    
   #pragma mark- 解锁的View（相当于按钮）
    self.unlockLongPressView = [[LongPressView alloc] init];
    [self.unlockLongPressView initLongPressView];
    [self.bottomView addSubview:self.unlockLongPressView];
    [self.unlockLongPressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.pauseBtn);
        make.size.mas_equalTo(CGSizeMake(102, 102));
    }];
    self.unlockLongPressView.bgView.backgroundColor = self.pauseBtn.backgroundColor;
    self.unlockLongPressView.titleLbl.font = [UIFont fontWithName:@"PingFangSC" size: 12];
    self.unlockLongPressView.titleLbl.textColor = self.pauseLabel.textColor;
    //图片
    self.unlockLongPressView.imgView.image = [UIImage imageNamed:@"BigLockBtnImage"];
    self.unlockLongPressView.titleLbl.text = @"长按解锁";
    self.unlockBtn.hidden = YES;
}

//在顶部视图上添加控件
- (void)addViewOnTopView{
    
        //左上角的GPS图标
        self.GPSImgView = [[UIImageView alloc] init];
        [self addSubview:self.GPSImgView];
        [self.GPSImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(kScreenWidth * 0.04);
            make.top.equalTo(self.mas_top).offset(kScreenHight * 0.0739);
            make.size.mas_equalTo(CGSizeMake(28, 28));
        }];
        
    
        //中心显示跑了多少公里数字的label
        self.numberLabel = [[UILabel alloc] init];
        [self addSubview:self.numberLabel];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.GPSImgView.mas_bottom).offset(kScreenHight * 0.1589);
            make.height.mas_equalTo(100);
            make.width.mas_equalTo(self.frame.size.width);
        }];
    //    self.numberLabel.font = [UIFont fontWithName:@"Impact" size: 82];
        [self.numberLabel setFont:[UIFont systemFontOfSize:82]];
        self.numberLabel.textColor = [UIColor colorWithRed:65/255.0 green:68/255.0 blue:72/255.0 alpha:1.0];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel.text = @"4.26";
        
        //显示“公里”的label
        self.milesLabel = [[UILabel alloc] init];
        [self addSubview:self.milesLabel];
        [self.milesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.numberLabel.mas_bottom);
            make.centerX.equalTo(self.numberLabel.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(44, 30));
        }];
        self.milesLabel.font = [UIFont fontWithName:@"PingFangSC" size: 22];
        self.milesLabel.textColor = [UIColor colorWithRed:100/255.0 green:104/255.0 blue:111/255.0 alpha:1.0];
        self.milesLabel.text = @"公里";

}

//在button上添加控件
- (void)addViewsOnBtn{
#pragma mark- 暂停按钮
        //图片
    self.pauseImgView = [[UIImageView alloc] init];
    [self.pauseBtn addSubview:self.pauseImgView];
    [self.pauseImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.pauseBtn);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
        //label
    self.pauseLabel = [[UILabel alloc] init];
    [self.pauseBtn addSubview:self.pauseLabel];
    [self.pauseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.pauseImgView);
        make.top.equalTo(self.pauseImgView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    self.pauseLabel.font = [UIFont fontWithName:@"PingFangSC" size: 12];
    self.pauseLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.pauseLabel.textAlignment = NSTextAlignmentCenter;
    self.pauseLabel.text = @"暂停";

#pragma mark- 继续按钮
            //图标
    self.continueImgView = [[UIImageView alloc] init];
    [self.continueBtn  addSubview:self.continueImgView];
    [self.continueImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.continueBtn);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
            //文字
    self.continueLabel = [[UILabel alloc] init];
    [self.continueBtn addSubview:self.continueLabel];
    [self.continueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.continueImgView);
        make.top.equalTo(self.continueImgView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(24, 17));
    }];
    self.continueLabel.font =  self.endLabel.font;
    self.continueLabel.textColor = self.endLabel.textColor;
    self.continueLabel.text = @"继续";
}

@end
