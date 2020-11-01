//
//  RunningMainPageView.m
//  MRMobileRun
//
//  Created by 石子涵 on 2020/7/10.
//

#import "RunningMainPageView.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <Masonry.h>
#import <SVGKit.h>
#import "SVGKit.h"
#import "SVGKImage.h"
#import "SVGKParser.h"
#import "UIImage+SVGTool.h"
//屏幕的宽和高
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHight [UIScreen mainScreen].bounds.size.height
@interface RunningMainPageView()<UIGestureRecognizerDelegate>
@property CGPoint containerOrigin;
@end

@implementation RunningMainPageView

//初始化View
- (void)mainRunView{
    [self addMapView];
    [self addViewOnMap];
    [self addViewOnBottomView];
    
    //给底部视图添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragAction:)];
       [self.bottomView addGestureRecognizer:pan];
       self.bottomView.userInteractionEnabled = YES;
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
            make.bottom.equalTo(self);
        }];
    //设置地图相关属性
    self.mapView.zoomLevel = 17;
    self.mapView.showsUserLocation = NO; //不显示用户小蓝点
    self.mapView.rotateEnabled = NO; //不旋转
    
    self.mapView.pausesLocationUpdatesAutomatically = NO;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    self.mapView.userInteractionEnabled = YES;
    [self.mapView setAllowsBackgroundLocationUpdates:YES];//打开后台定位
    self.mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
   
    //自定义用户位置小蓝点
    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
    r.showsAccuracyRing = NO;//不显示精度圈
//    r.image = [UIImage imageNamed:@"userAnnotation"];
    [self.mapView updateUserLocationRepresentation:r];
    
    //监听是否是深色模式，并根据模式设置自定义地图样式
    [self changeMapType];
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
    self.topView.alpha = 0.6;
    
    
    //下面的白色View
       self.bottomView = [[UIView alloc] init];
       [self.mapView addSubview:self.bottomView];
       [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.mas_top).offset(kScreenHight * 0.5369);
           make.bottom.equalTo(self.mapView.mas_bottom);
//           make.height.mas_equalTo(kScreenHight * 0.4631);
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
       
    //左上角的GPS图标
      self.GPSImgView = [[UIImageView alloc] init];
      [self.mapView addSubview:self.GPSImgView];
      [self.GPSImgView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.mapView.mas_left).offset(kScreenWidth * 0.04);
          make.top.equalTo(self.mapView.mas_top).offset(kScreenHight * 0.0739);
              make.size.mas_equalTo(CGSizeMake(28, 28));
          }];
      self.GPSImgView.backgroundColor = [UIColor clearColor];
//    self.GPSImgView.backgroundColor = [UIColor redColor];
//      self.GPSImgView.alpha = 0.05;
      self.GPSImgView.image = [UIImage imageNamed:@"GPS"];
    
    //左上角的GPS信号
    self.GPSSignal = [[UIImageView alloc] init];
    [self.mapView addSubview:self.GPSSignal];
    [self.GPSSignal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.GPSImgView.mas_right).offset(screenWidth * 0.0213);
        make.centerY.equalTo(_GPSImgView);
        make.size.mas_equalTo(CGSizeMake(34, 15));
    }];
    self.GPSSignal.backgroundColor = [UIColor clearColor];
    
    //公里的相关lable
    [self aboutMinleLbl];
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
        make.top.equalTo(self.speedImgView.mas_bottom).offset(kScreenHight * 0.0224);
        make.size.mas_equalTo(CGSizeMake(90, 34));
    }];
    self.speedNumberLbl.font = [UIFont fontWithName:@"Impact" size:28];
    
//    [UIFont fontWithName:@"Impact" size: 82];
    if (@available(iOS 11.0, *)) {
        self.speedNumberLbl.textColor = SpeedTextColor;
    } else {
        // Fallback on earlier versions
    }
    self.speedNumberLbl.textAlignment = NSTextAlignmentCenter;
    self.speedNumberLbl.text = @"--'--''";
    
    //显示“配速”的label
    self.speedLbl = [[UILabel alloc] init];
    [self.bottomView addSubview:self.speedLbl];
    [self.speedLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.speedImgView.mas_centerX);
        make.top.equalTo(self.speedNumberLbl.mas_bottom).offset(kScreenHight * 0.0074);
        make.size.mas_equalTo(CGSizeMake(54, 24));
    }];
    self.speedLbl.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 14];
    self.speedLbl.textColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1.0];
    self.speedLbl.textAlignment = NSTextAlignmentCenter;
    self.speedLbl.text = @"配速";
    

#pragma mark- 时间相关
        //时间的图片
    self.timeImgView = [[UIImageView alloc] init];
    [self.bottomView addSubview:self.timeImgView];
    [self.timeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.speedImgView.mas_centerY);
//        make.left.equalTo(self.speedImgView.mas_right).offset(kScreenWidth * 0.256);
        make.centerX.equalTo(self.mas_centerX);
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
    self.timeNumberLbl.text = @"00:00";
    
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
        make.right.equalTo(self.mas_right).offset(-kScreenWidth * 0.1707);
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
    self.energyNumberLbl.text = @"0";
            
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
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    //图片
//    UIImageView *lockImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smallLockImage"]];
    self.lockImageView = [[UIImageView alloc] init];
    [self.lockBtn addSubview:self.lockImageView];
    [self.lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.lockBtn);
    }];

    #pragma mark- 暂停按钮
    self.pauseBtn = [[RunMainBtn alloc] init];
    [self.pauseBtn initRunBtn];
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
//    self.pauseBtn.logoImg.image = [UIImage imageNamed:@"pauseBtnImage"];
    self.pauseBtn.logoImg.image = [UIImage svgImgNamed:@"暂停白.svg" size:CGSizeMake(30, 30)];
    
    self.pauseBtn.descLbl.text = @"暂停";
    if (@available(iOS 11.0, *)) {
        self.pauseBtn.descLbl.textColor = ContinueBtnTextColor;
    } else {
        // Fallback on earlier versions
    }
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
    self.endLongPressView.titleLbl.textColor = [UIColor whiteColor];
    self.endLongPressView.titleLbl.text = @"长按结束";
        //图片框的图片
//    self.endLongPressView.imgView.image = [UIImage imageNamed:@"endBtnImage"];
    self.endLongPressView.imgView.image = [UIImage svgImgNamed:@"结束白.svg" size:CGSizeMake(30, 30)];
//    SVGKImage *endWhite = [SVGKImage imageNamed:@"结束白"];
//    self.endLongPressView.imgview.image = endWhite;
//    self.endLongPressView.imgview.backgroundColor = [UIColor darkGrayColor];
    
    self.endLongPressView.layer.cornerRadius = 51;
    self.endLongPressView.layer.masksToBounds = YES;
    
    self.endLongPressView.hidden = YES;
    
    
     #pragma mark- 继续按钮
    self.continueBtn = [[RunMainBtn alloc] init];
    [self.continueBtn initRunBtn];
    [self.bottomView addSubview:self.continueBtn];
    [self.continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.endLongPressView);
        make.left.equalTo(self.endLongPressView.mas_right).offset(kScreenWidth * 0.08);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
        //图片
//    self.continueBtn.logoImg.image = [UIImage imageNamed:@"continueBtnImage"];
    self.continueBtn.logoImg.image = [UIImage svgImgNamed:@"继续白" size:CGSizeMake(30, 30)];
    self.continueBtn.descLbl.text = @"继续";
    self.continueBtn.descLbl.textColor = [UIColor whiteColor];
    
    self.continueBtn.backgroundColor = [UIColor colorWithRed:85/255.0 green:213/255.0 blue:226/255.0 alpha:1.0];
    self.continueBtn.layer.cornerRadius = 45;
    self.continueBtn.layer.masksToBounds = YES;
    self.continueBtn.hidden = YES;
    
   #pragma mark- 解锁的View（相当于按钮）
    self.unlockLongPressView = [[LongPressView alloc] init];
    [self.unlockLongPressView initLongPressView];
    [self.bottomView addSubview:self.unlockLongPressView];
    [self.unlockLongPressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.pauseBtn);
        make.size.mas_equalTo(CGSizeMake(102, 102));
    }];
        
      self.unlockLongPressView.titleLbl.text = @"长按解锁";
    if (@available(iOS 11.0, *)) {
        self.unlockLongPressView.titleLbl.textColor = ContinueBtnTextColor;
    } else {
        // Fallback on earlier versions
    }
    
    self.unlockLongPressView.bgView.backgroundColor = self.pauseBtn.backgroundColor;
    
    //图片
//    self.unlockLongPressView.imgView.image = [UIImage imageNamed:@"BigLockBtnImage"];
    self.unlockLongPressView.layer.cornerRadius = 51;
    self.unlockLongPressView.layer.masksToBounds = YES;
  
    
    self.unlockLongPressView.hidden = YES;
#pragma mark- 拖动的labl和图片框
    self.dragLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:self.dragLabel];
    [self.dragLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.timeImgView);
        make.top.equalTo(self.bottomView.mas_top);
        make.bottom.equalTo(self.timeImgView.mas_top);
//        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(screenWidth * 0.6666);
    }];
    
    self.dragimageView = [[UIImageView alloc] init];
    self.dragimageView.backgroundColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1.0];
    self.dragimageView.layer.cornerRadius = 3;
    [self.dragLabel addSubview:self.dragimageView];
//    self.dragimageView.image = [UIImage imageNamed:@"初始位置"];
    [self.dragimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.dragLabel);
        make.height.mas_equalTo(7);
        make.width.mas_equalTo(screenWidth * 0.072);
    }];
}

//添加显示公里数的label和显示公里的label
- (void)aboutMinleLbl{
/*
 中间的公里数和公里的label
 */
    //显示公里数的label
    self.mileNumberLabel = [[UILabel alloc] init];
    self.mileNumberLabel.frame = CGRectMake(0, screenHeigth * 0.2696, screenWidth, 100);
    [self addSubview:self.mileNumberLabel];
    self.mileNumberLabel.textAlignment = NSTextAlignmentCenter;
    self.mileNumberLabel.text = @"0.00"; //文本
    self.mileNumberLabel.font = [UIFont fontWithName:@"Impact" size: 82];
    if (@available(iOS 11.0, *)) {
        self.mileNumberLabel.textColor = MilesColor;
    } else {
        // Fallback on earlier versions
    }
    
    //显示“公里”的label
    self.mileTexteLable = [[UILabel alloc] init];
    self.mileTexteLable.frame = CGRectMake(screenWidth * 0.4427, screenHeigth * 0.2696 + 100, 44, 30);
    [self addSubview:self.mileTexteLable];
    self.mileTexteLable.textAlignment = NSTextAlignmentCenter;
    self.mileTexteLable.text = @"公里";
    self.mileTexteLable.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 22];
    if (@available(iOS 11.0, *)) {
        self.mileTexteLable.textColor = MilesTxetColor;
    } else {
        // Fallback on earlier versions
    }
/*
    右上角的公里数和公里的label
 */
    //公里数
    self.mileNumberLabelRight = [[UILabel alloc] init];
    self.mileNumberLabelRight.text = self.mileNumberLabel.text;
    self.mileNumberLabelRight.textAlignment = NSTextAlignmentCenter;
    self.mileNumberLabelRight.font = [UIFont fontWithName:@"Impact" size: 44];
    self.mileNumberLabelRight.frame =  CGRectMake(screenWidth * 0.64,screenHeigth * 0.0497, 84, 53);
    self.mileNumberLabelRight.alpha = 0;
    self.mileNumberLabelRight.textColor = self.mileNumberLabel.textColor;
    [self addSubview:self.mileNumberLabelRight];
//    self.mileNumberLabelRight.backgroundColor = [UIColor whiteColor];
    
    //公里
    self.mileTextLabelRight = [[UILabel alloc] init];
    self.mileTextLabelRight.text = self.mileTexteLable.text;
    self.mileTextLabelRight.textAlignment = NSTextAlignmentCenter;
    self.mileTextLabelRight.textColor = self.mileTextLabelRight.textColor;
    self.mileTextLabelRight.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];
    self.mileTextLabelRight.alpha = 0;
    self.mileTextLabelRight.frame =  CGRectMake(screenWidth * 0.64 + 84, screenHeigth * 0.0497 + 5, 36, 25);
    [self addSubview:self.mileTextLabelRight];
}

//监听是否是深色模式，并根据模式设置自定义地图样式
- (void)changeMapType{
    if (@available(iOS 13.0, *)) {
        UIUserInterfaceStyle mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
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
}

- (void)dragAction:(UIPanGestureRecognizer *)recognizer{
    CGPoint point = [recognizer translationInView:self.bottomView];
        if (recognizer.state == UIGestureRecognizerStateBegan) {
               self.containerOrigin = recognizer.view.frame.origin;
           }
        // 手势移动过程中: 在边界处做判断,其他位置
               if (recognizer.state == UIGestureRecognizerStateChanged) {
                   
                   CGRect frame = recognizer.view.frame;
                   frame.origin.y = self.containerOrigin.y + point.y;
                   if (frame.origin.y < screenHeigth * 0.6) { // 上边界
                       frame.origin.y = screenHeigth * 0.6;
                   }
                   
                   if (frame.origin.y > screenHeigth * 0.8) { // 下边界
                       frame.origin.y = screenHeigth * 0.8;
                   }
                  
                   recognizer.view.frame = frame;
               }
         // 手势结束后:有向上趋势,视图直接滑动至上边界, 向下趋势,视图直接滑动至到下边界
         if (recognizer.state == UIGestureRecognizerStateEnded){
              if ([recognizer velocityInView:self.bottomView].y < 0) {
                  NSLog(@"向上");
                  [UIView animateWithDuration:0.50 animations:^{
                      CGRect frame = recognizer.view.frame;
                      frame.origin.y = screenHeigth * 0.6;
                      recognizer.view.frame = frame;
                      self.mileNumberLabelRight.alpha = 0;
                      self.mileTextLabelRight.alpha = 0;
                      self.topView.alpha = 0.6; //恢复原来的透明度
                  }];
                    //延迟0.5秒，等右上角的全部消失后中间的label再显示出来
                  [UIView animateWithDuration:0.5 delay:0.5 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:nil animations:^{
                      self.mileNumberLabel.alpha = 1;
                      self.mileTexteLable.alpha = 1;
                      
                      
                  } completion:nil];
                  
                 
                  //设置draglabel里面的图片
                  self.dragimageView.backgroundColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1.0];
                  self.dragimageView.image = nil;


              }else {
                  NSLog(@"向下");
                  [UIView animateWithDuration:0.50 animations:^{
                      CGRect frame = recognizer.view.frame;
                      frame.origin.y = screenHeigth * 0.8;
                      recognizer.view.frame = frame;
                      self.mileNumberLabel.alpha = 0;
                      self.mileTexteLable.alpha = 0;
                      self.topView.alpha = 0;
                      
                  }];
                  //延迟0.5秒，等右上角的全部消失后中间的label再显示出来
                  [UIView animateWithDuration:0.5 delay:0.5 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:nil animations:^{
                      self.mileNumberLabelRight.alpha = 1;
                      self.mileTextLabelRight.alpha = 1;
                  } completion:nil];
                  
                  
                  self.dragimageView.backgroundColor = [UIColor clearColor];
                  self.dragimageView.image = [UIImage imageNamed:@"底部位置"];

              }
         }
    }



@end
