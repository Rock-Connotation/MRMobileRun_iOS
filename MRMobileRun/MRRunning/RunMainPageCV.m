//
//  RunMainPageCV.m
//  MRMobileRun
//
//  Created by 石子涵 on 2020/7/10.
//


#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MAMapKit/MAMapKit.h>
#import <MAMapKit/MAPointAnnotation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <Masonry.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AFNetworking.h>

#import "ZYLTimeStamp.h" //获取开始、结束的时间
#import "GYYHealthManager.h" //读取健康数据，获取跑步时间段的步数来计算步频
#import "MRTabBarController.h"
#import "MRMainTabBarController.h"
#import "RunMainPageCV.h"
#import "RunningMainPageView.h"
#import "RunLocationModel.h"
#import "MGDDataViewController.h"
#import "SZHAlertView.h" //跑步距离过短时结束的提示弹窗
#import "RecordtimeString.h"
@interface RunMainPageCV ()<MAMapViewDelegate,AMapLocationManagerDelegate,CLLocationManagerDelegate>
{
    CGFloat _yyy;
}
@property (nonatomic, strong) RunningMainPageView *Mainview;

//关于时间
@property (nonatomic, strong) NSTimer *runTimer;
@property (nonatomic, strong) NSString *beginTime;  //开始的时间（系统时间）
@property (nonatomic, strong) NSString *endTime;    //结束时间（系统时间）
@property (nonatomic, strong) NSString *timeString; //跑步的时间（经历过格式转换后的）
@property (nonatomic) int hour;
@property (nonatomic) int minute;
@property (nonatomic) int second;

//数组
@property (nonatomic, strong) NSMutableArray *stepsAry; //每分钟的步数
@property (nonatomic, strong) NSArray *caculateStepsAry; //处理后的步频数组
@property int averageStepFrequency; //平均步频
@property int maxStepFrequency; //最大步频
@property (nonatomic, strong) NSMutableArray *mintesAry; //跑步过程中的分钟数的数组

@property (nonatomic, strong) NSMutableArray *speedAry; //速度的数组
@property double averageSpeed; //平均速度
@property double maxSpeed; //最大速度
@property (nonatomic, strong) NSArray *caculateSpeedAry; //处理后的速度数组

@property double mileage; //总路程
@property double duration; //总时间
@property (nonatomic, strong) NSString *finishDate;//完成的日期

@property double kcal; //燃烧千卡；

//关于模型
//@property (nonatomic, strong) RunningModel *model;
@property (nonatomic, strong) RunLocationModel *locationModel;

/*
 关于定位以及绘制轨迹
 */
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) CLLocationManager *CLlocationManager;
@property (nonatomic, strong)MAAnnotationView *myAnnotationView;//我的当前位置的大头针
@property (nonatomic, strong)MAPolyline *polyline;//当前绘制的轨迹曲线
    
@property (nonatomic, strong)NSMutableArray *drawLineArray;//待绘制定位轨迹线数据
@property (nonatomic, strong)NSMutableArray *locationArray;

@property (nonatomic, assign)NSInteger locationNumber;//定位次数
@property (nonatomic, assign)BOOL isFirstLocation;//是否是第一次定位
@property (nonatomic, assign)BOOL isEndLocation; //是否是最后一次定位

@property (nonatomic, assign) CGFloat signal; //信号强度
//跑步结束时的AlertView
@property (nonatomic, strong) SZHAlertView *shortAlert;
@property (nonatomic, strong) SZHAlertView *normalAlert;
@end

@implementation RunMainPageCV

- (void)viewWillAppear:(BOOL)animated{
    
}
- (void)viewDidAppear:(BOOL)animated{
//    self.sportsState = SportsStateStart;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //关于一些初始化设置
    self.locationArray = [NSMutableArray array];
    self.drawLineArray = [NSMutableArray array];
    self.beginTime = [ZYLTimeStamp getTimeStamp]; //跑步开始的时间
    self.distance = 0;
    self.mintesAry = [NSMutableArray array];
    self.stepsAry = [NSMutableArray array];
    

    
    //跑步首页UI
    self.Mainview = [[RunningMainPageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.Mainview];
    [self.Mainview mainRunView];
    //给拖拽的label添加手势
     UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragAction:)];
    [self.Mainview.dragLabel addGestureRecognizer:pan];
    self.Mainview.dragLabel.userInteractionEnabled = YES;
    
    self.Mainview.mapView.delegate = self; //设置地图代理
    [self initAMapLocation]; //初始化位置管理者
    
    self.Mainview.numberLabel.text = [NSString stringWithFormat:@"%0.2f",self.distance];
    
    [self btnFunction]; //跑步首页关于继续暂停等按钮的方法
    self.Mainview.mapView.delegate = self;
    
    //跑步时间初始化
    self.runTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
     self.second = self.minute = self.hour = 0;
    
}

//    //拖动label来动态改变底部bottomView的高度
- (void)dragAction:(UIPanGestureRecognizer *)pan{
     if ((pan.state == UIGestureRecognizerStateBegan)) {
         if (_yyy == 0) {
             _yyy = CGRectGetMaxY(self.Mainview.dragLabel.frame);
                       }
        }else if (pan.state == UIGestureRecognizerStateChanged){
            //获取手势的偏移量

            CGPoint point = [pan translationInView:self.Mainview.dragLabel];
    //        NSLog(@"%f",point.y);
            
            CGFloat y = _yyy + point.y; //手势偏移量+初始量为改变量
            if (point.y < -screenHeigth * 0.05) {
                self.Mainview.topView.alpha = 0.6;
                self.Mainview.dragimageView.image = [UIImage imageNamed:@"初始位置"];
                [self.Mainview.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.top.equalTo(self.Mainview.mas_top).offset(screenHeigth * 0.5369);
                }];
                //更换numberLabel的位置和显示公里的位置
                //公里数
                [self.Mainview.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.Mainview);
                    make.top.equalTo(self.Mainview.GPSImgView.mas_bottom).offset(screenHeigth * 0.1589);
                    make.height.mas_equalTo(100);
                    make.width.mas_equalTo(self.Mainview.frame.size.width);
                }];
                self.Mainview.numberLabel.font = [UIFont fontWithName:@"Impact" size: 82];
                
            //显示公里的label
                [self.Mainview.milesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.Mainview.numberLabel.mas_bottom);
                    make.centerX.equalTo(self.Mainview.numberLabel.mas_centerX);
                    make.size.mas_equalTo(CGSizeMake(44, 30));
                }];
                self.Mainview.milesLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 22];
                
            }
                if(y > screenHeigth * 0.15) {
                       y = screenHeigth * 0.3;
                self.Mainview.topView.alpha = 0;
                self.Mainview.dragimageView.image = [UIImage imageNamed:@"底部位置"];
                //更新对bottomView的约束，使得它的高度变化
                [self.Mainview.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.equalTo(self.view);
                    make.top.equalTo(self.Mainview.mas_top).offset(screenHeigth * 0.4869 + y);
                }];
                    //更换numberLabel的位置和显示公里的位置
                    //显示公里的lable
                    [self.Mainview.milesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.Mainview.mapView).offset(screenHeigth * 0.0572);
                        make.right.equalTo(self.Mainview.mapView.mas_right).offset(screenWidth * -0.04);
                        make.size.mas_equalTo(CGSizeMake(36, 25));
                    }];
                    self.Mainview.milesLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
                    
                    [self.Mainview.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.Mainview.milesLabel.mas_top).offset(5);
                        make.right.equalTo(self.Mainview.milesLabel.mas_left);
                        make.size.mas_equalTo(CGSizeMake(84, 53));
                    }];
                    self.Mainview.numberLabel.font = [UIFont fontWithName:@"Impact" size:44];
                          }
            
        }
}
                 

#pragma mark- 加载位置管理者
- (void)initAMapLocation{
    _locationManager = [[AMapLocationManager alloc] init];
                _locationManager.delegate = self;
                _locationManager.distanceFilter = 5;//设置移动精度(单位:米)
                _locationManager.locationTimeout = 3;//定位时间
                _locationManager.allowsBackgroundLocationUpdates = YES;//开启后台定位
                [_locationManager startUpdatingLocation];
                [_locationManager setLocatingWithReGeocode:YES];
}
//CLLocationManager
- (void)initlocation{
    //判断是否打开了位置服务
    if ([CLLocationManager locationServicesEnabled]) {
         self.CLlocationManager = [[CLLocationManager alloc] init];
        self.CLlocationManager.delegate = self;
        self.CLlocationManager.distanceFilter = 5; //每隔五米定位一次
        self.CLlocationManager.desiredAccuracy = kCLDistanceFilterNone; //设置定位精度
        [self.CLlocationManager requestAlwaysAuthorization];
        [self.CLlocationManager requestWhenInUseAuthorization];
        [self.CLlocationManager startUpdatingLocation];
        
        }
}
#pragma mark- 定位数据
//疑似无用的
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{

    if(!updatingLocation)
        return ;

    if (userLocation.location.horizontalAccuracy < 0)
    {
        return ;
    }
}
//
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    self.signal = location.horizontalAccuracy;
    //根据信号强度设置信号强度的照片
    if (self.signal < 20 ) {
          //信号强
          self.Mainview.GPSSignal.image = [UIImage imageNamed:@"信号三格"];
      }else if(self.signal < 70){
          //信号中等
          self.Mainview.GPSSignal.image = [UIImage imageNamed:@"信号二格"];
      }else{
          //信号差
          self.Mainview.GPSSignal.image = [UIImage imageNamed:@"信号一格"];
      }
    //GPS信号大于0。小于80的时候进来
     if (self.signal < 80 && self.signal >0){
          if (self.locationArray.count == 0) {
              
            RunLocationModel *StartPointModel = [[RunLocationModel alloc] init];
            StartPointModel.location = location.coordinate;
            StartPointModel.speed = location.speed;
              self.maxSpeed = location.speed;
            StartPointModel.time = location.timestamp;
            [self.locationArray addObject:StartPointModel];//向位置数组里面添加第一个定位点
            [self.drawLineArray addObject:StartPointModel];//向绘制轨迹点的数组里添加第一个定位点
            //展示配速
            int speedMinutes = (int)(1000/StartPointModel.speed)/60;
            int speedSeconds = (int)(1000/StartPointModel.speed)%60;
            if (speedMinutes > 99) {
                self.Mainview.speedNumberLbl.text = @"--'--''";
            }else{
                self.Mainview.speedNumberLbl.text = [NSString stringWithFormat:@"%d'%d''",speedMinutes,speedSeconds];
            }
        }else if (self.locationArray.count != 0) {
                RunLocationModel *LastlocationModel = self.locationArray.lastObject;
            //当前定位的位置信息model
            RunLocationModel *currentModel = [[RunLocationModel alloc] init];
            currentModel.location = location.coordinate;
            currentModel.time = location.timestamp;
            currentModel.speed = location.speed;
            //比较此处定位点的速度是否比最大速度大，是的话将其赋值给最大速度
            if (self.maxSpeed < currentModel.speed) {
                self.maxSpeed = currentModel.speed;
            }
            double meters = [self distanceWithLocation:LastlocationModel andLastButOneModel:currentModel];
            //过滤偏移
            if (currentModel.speed < 13) {
                 self.locationModel = currentModel;
                 [self.locationArray addObject:self.locationModel]; //向位置数组里添加跑步过程中每次定位的定位点
                 double KMeters = meters/1000;
                 self.distance = self.distance + KMeters;
                 self.Mainview.numberLabel.text = [NSString stringWithFormat:@"%.02f",self.distance];
                
                //计算配速
                int speedMinutes = (int)(1000/self.locationModel.speed)/60;
                int speedSeconds = (int)(1000/self.locationModel.speed)%60;
                if (speedMinutes > 99) {
                    self.Mainview.speedNumberLbl.text = @"--'--''";
                }else{
                  self.Mainview.speedNumberLbl.text = [NSString stringWithFormat:@"%d'%d''",speedMinutes,speedSeconds];
                }
                //计算燃烧千卡
                self.kcal = 60 * KMeters * 1.036;
                self.Mainview.energyNumberLbl.text = [NSString stringWithFormat:@"%d",(int)self.kcal];
                       }
            
#pragma mark- 绘制轨迹
            //为了美化移动的轨迹，移动的位置超过10米，才添加进绘制轨迹的的数组
            if (meters >= 5) {
                RunLocationModel *lineLastPointLocation = [self.drawLineArray lastObject];
                //开始绘制轨迹
                CLLocationCoordinate2D linePoints[2];
                linePoints[0] = lineLastPointLocation.location;
                linePoints[1] = self.locationModel.location;
                //调用addOverlay方法后回进入 renderForOverlay 方法，完成对轨迹的绘制
                MAPolyline *lineSection  = [MAPolyline polylineWithCoordinates:linePoints count:2];
                [self.Mainview.mapView addOverlay:lineSection];
                [self.drawLineArray addObject:self.locationModel]; //为绘制轨迹的位置数组添加新的元素
                NSLog(@"绘制轨迹的数组内的元素个数为%lu-----位置数组内的元素个数为%lu",(unsigned long)self.drawLineArray.count,(unsigned long)self.locationArray.count);
            }
        }
    }
}
//疑似无用的
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if (self.locationArray.count == 0) {
        self.locationModel = [[RunLocationModel alloc] init];
        CLLocation *location = [locations firstObject];
        self.locationModel.LOCATION = location;
        self.locationModel.location = location.coordinate;
        [self.locationArray addObject:self.locationModel];
    }else if (self.locationArray.count != 0){
        RunLocationModel *currentModel = [[RunLocationModel alloc] init];
        currentModel.LOCATION = [locations firstObject];
        
        
    }
}
    //计算距离
-(CLLocationDistance )distanceWithLocation:(RunLocationModel *)lastModel andLastButOneModel:(RunLocationModel *)lastButOneModel{
        CLLocationDistance Meters = 0;
    MAMapPoint point1 = MAMapPointForCoordinate(lastModel.location);
       MAMapPoint point2 = MAMapPointForCoordinate(lastButOneModel.location);
       //2.计算距离
       CLLocationDistance newdistance = MAMetersBetweenMapPoints(point1,point2);
        Meters = newdistance;
        return Meters;
}

#pragma mark- 绘制定位大头针
    //自定义大头针
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{

   // 自定义userlocation的大头针
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *userLocationReuseIndetifier = @"userLocation";
        self.myAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationReuseIndetifier];
        if (self.myAnnotationView == nil) {
            self.myAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userLocationReuseIndetifier];
        }
        self.myAnnotationView.image = [UIImage imageNamed:@"userAnnotation"];
        return self.myAnnotationView;
    }
      return nil;
}

#pragma mark- 轨迹线的设置
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay{
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineRenderer *polyLineRender = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        polyLineRender.lineWidth = 8;
        polyLineRender.strokeColor = [UIColor colorWithRed:123/255.0 green:183/255.0 blue:196/255.0 alpha:1.0]; //折线颜色
        return polyLineRender;
  }
    return nil;
}
    
#pragma mark- 关于时间
//跑步时间开始
- (void)startTimer{
    self.second++;
    if (self.second == 86400) {
        self.second = 0;
    }
    NSLog(@"%d",self.second);
    //将秒数转化为HH:MM:SS格式
    NSString *timeString = [RecordtimeString getTimeStringWithSeconds:self.second];
    //获取跑步时间
    self.Mainview.timeNumberLbl.text = timeString;
    self.timeString = timeString;
    
    //如果有一分钟了执行一下操作
    if (self.second%60 == 0) {
        self.endTime = [ZYLTimeStamp getTimeStamp];
        [self caculatePace]; //获取这一分钟内的步数
        self.beginTime = self.endTime;
    }
    
}

#pragma mark- 按钮的方法
//按钮方法
- (void)btnFunction{
    //暂停按钮
    [self.Mainview.pauseBtn addTarget:self action:@selector(pauseMethod) forControlEvents:UIControlEventTouchUpInside];
    
    //锁屏按钮
    [self.Mainview.lockBtn addTarget:self action:@selector(lockMethod) forControlEvents:UIControlEventTouchUpInside];
    
    //解锁按钮
    [self.Mainview.unlockLongPressView addTarget:self select:@selector(unlockMethod)];
    
    
    //继续按钮
    [self.Mainview.continueBtn addTarget:self action:@selector(continueMethod) forControlEvents:UIControlEventTouchUpInside];
    
    //结束按钮
    [self.Mainview.endLongPressView addTarget:self select:@selector(endMethod)];
}

//点击暂停按钮的方法
- (void)pauseMethod{
    //计时器暂停
    [self.runTimer setFireDate:[NSDate distantFuture]];
    //定位暂停
    [self.locationManager stopUpdatingLocation];
    
    //按钮的变化
    self.Mainview.pauseBtn.hidden = YES;
    self.Mainview.lockBtn.hidden = YES;
    self.Mainview.unlockLongPressView.hidden = YES;
    
    self.Mainview.endLongPressView.hidden = NO;
    self.Mainview.continueBtn.hidden = NO;
}

//点击继续按钮方法
- (void)continueMethod{
    //计时器继续
    [self.runTimer setFireDate:[NSDate distantPast]];
    //定位继续
    [self.locationManager startUpdatingHeading];
    
    //按钮的变换
    self.Mainview.unlockLongPressView.hidden = YES;
    self.Mainview.endLongPressView.hidden = YES;
    self.Mainview.continueBtn.hidden = YES;
    
    self.Mainview.pauseBtn.hidden = NO;
    self.Mainview.lockBtn.hidden = NO;
    
}

//点击锁屏按钮方法
- (void)lockMethod{
    self.Mainview.topView.userInteractionEnabled = NO;
#pragma mark- 按钮的变换
    self.Mainview.pauseBtn.hidden = YES;
    self.Mainview.lockBtn.hidden = YES;
    self.Mainview.endLongPressView.hidden = YES;
    self.Mainview.continueBtn.hidden = YES;
    self.Mainview.unlockLongPressView.hidden = NO;
}

//长按解锁按钮方法
- (void)unlockMethod{
    self.Mainview.topView.userInteractionEnabled = YES;
#pragma mark- 按钮的变换
    self.Mainview.unlockLongPressView.hidden = YES;
    self.Mainview.endLongPressView.hidden = YES;
    self.Mainview.continueBtn.hidden = YES;
    self.Mainview.lockBtn.hidden = NO;
    self.Mainview.pauseBtn.hidden = NO;
}

//长按结束按钮方法
- (void)endMethod{
    //计时器停止
//    [self.runTimer setFireDate:[NSDate distantFuture]];
    //处理步频、速度数组
    [self caculateSpeedAndStepsArys];
    self.mileage = self.distance; //总路程
    self.duration = self.second; //总时间
//    //获取当前日期
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.finishDate = [formatter stringFromDate:date];
    
    //弹出提示框
    if (self.second < 60 || self.distance < 0.1) {
        SZHAlertView *shortAlert = [[SZHAlertView alloc] initWithTitle:@"本次跑步距离过短，无法保存记录，确定结束吗？"];
        [self.view addSubview:shortAlert];
        shortAlert.frame = self.view.frame;
        [shortAlert.endBtn addTarget:self action:@selector(shortEndRun) forControlEvents:UIControlEventTouchUpInside];
        [shortAlert.ContinueRunBtn addTarget:self action:@selector(continueRun1) forControlEvents:UIControlEventTouchUpInside];
        self.shortAlert = shortAlert;
    }else{
        SZHAlertView *endAlert = [[SZHAlertView alloc] initWithTitle:@"您确定要结束跑步吗？"];
        [self.view addSubview:endAlert];
        endAlert.frame = self.view.frame;
        [endAlert.endBtn addTarget:self action:@selector(endRun) forControlEvents:UIControlEventTouchUpInside];
        [endAlert.ContinueRunBtn addTarget:self action:@selector(continueRun2) forControlEvents:UIControlEventTouchUpInside];
        self.normalAlert = endAlert;
    }
}

//距离过短时的按钮
    //结束
/**
 此处应当是直接跳转到首页，不会跳转到跑步结束页，也不会上传跑步数据，最后进行处理
 */
- (void)shortEndRun{
//   MRTabBarController *cv = [[MRTabBarController alloc] init];
////    MRMainTabBarController *cv = [[MRMainTabBarController alloc] init];
//   [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabBar" object:nil];
//   [self.navigationController pushViewController:cv animated:YES];
////    [self.navigationController popToRootViewControllerAnimated:YES];
    
    MGDDataViewController *overVC = [[MGDDataViewController alloc] init];
                  //属性传值
                     overVC.distanceStr = self.Mainview.numberLabel.text; //跑步距离
                       overVC.speedStr = self.Mainview.speedNumberLbl.text; //配速
                       overVC.cacultedStepsAry = self.caculateStepsAry; //处理后的步频数组
                       overVC.caculatedSpeedAry = self.caculateSpeedAry; //处理后的速度数组
                       overVC.averageSpeed = self.averageStepFrequency; //平均速度
                       overVC.maxSpeed = self.maxSpeed; //最大速度
                       overVC.averageStepFrequency = self.averageStepFrequency; //平均步频
                       overVC.maxStepFrequency = self.maxStepFrequency; //最大步频
                       overVC.timeStr = self.timeString; //时间
                       overVC.energyStr = self.Mainview.energyNumberLbl.text; //千卡
                       overVC.drawLineAry = self.drawLineArray;
                       overVC.locationAry = self.locationArray;
                 self.hidesBottomBarWhenPushed = YES;
                 [self.navigationController pushViewController:overVC animated:YES];
              [[NSNotificationCenter defaultCenter]postNotificationName:@"hideTabBar" object:nil];
}

- (void)continueRun1{
    
    [self.shortAlert removeFromSuperview];
}

//正常结束
    //结束
- (void)endRun{
    //异步执行网络请求，上传跑步数据
       dispatch_async(dispatch_get_global_queue(0, 0), ^{
           [self handUpData];
       });
       //回到主线程去执行界面跳转以及属性传值
       dispatch_async(dispatch_get_main_queue(), ^{
           //跳转到下一个页面
              MGDDataViewController *overVC = [[MGDDataViewController alloc] init];
               //属性传值
                  overVC.distanceStr = self.Mainview.numberLabel.text; //跑步距离
                    overVC.speedStr = self.Mainview.speedNumberLbl.text; //配速
                    overVC.cacultedStepsAry = self.caculateStepsAry; //处理后的步频数组
                    overVC.caculatedSpeedAry = self.caculateSpeedAry; //处理后的速度数组
                    overVC.averageSpeed = self.averageStepFrequency; //平均速度
                    overVC.maxSpeed = self.maxSpeed; //最大速度
                    overVC.averageStepFrequency = self.averageStepFrequency; //平均步频
                    overVC.maxStepFrequency = self.maxStepFrequency; //最大步频
                    overVC.timeStr = self.timeString; //时间
                    overVC.energyStr = self.Mainview.energyNumberLbl.text; //千卡
                    overVC.drawLineAry = self.drawLineArray;
                    overVC.locationAry = self.locationArray;
              self.hidesBottomBarWhenPushed = YES;
              [self.navigationController pushViewController:overVC animated:YES];
           [[NSNotificationCenter defaultCenter]postNotificationName:@"hideTabBar" object:nil];
       });
}
    //继续跑步
- (void)continueRun2{
    [self.normalAlert removeFromSuperview];
}

#pragma mark-步频和配速
//步频
- (void)caculatePace{
    GYYHealthManager *healthManager = [GYYHealthManager shareInstance];
    [healthManager authorizeHealthKit:^(BOOL success, NSError * _Nonnull error){
        __weak typeof(self) weakSelf = self;   //block里避免循环引用，要用__weak 弱引用self    避免循环引用
        __block NSString *steps;   //不是属性的基本类型，要用__block修饰
        //异步去读取跑步时的步数
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [healthManager getStepCountFromBeginTime:[ZYLTimeStamp getDateFromTimeStamp:self.beginTime] ToEndTime:[ZYLTimeStamp getDateFromTimeStamp:self.endTime] completion:^(double stepValue, NSError * _Nonnull error) {
                //找出最大的步频
                if (weakSelf.stepsAry.count == 0) {
                    self.maxStepFrequency = (int)stepValue;
                }else if(weakSelf.stepsAry.count != 0){
                    if (self.maxStepFrequency < (int)stepValue) {
                        self.maxStepFrequency = (int)stepValue;
                    }
                }
                steps = [[NSNumber numberWithDouble:stepValue] stringValue];
            }];
            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.stepsAry addObject:steps];
            });
        });
    }];
}

//处理步频和速度的数组
- (void)caculateSpeedAndStepsArys{
    //处理步频数组
    if (self.stepsAry != 0) {
         NSMutableArray *stepsMuteAry = [NSMutableArray array];
            double totleSteps = 0;
            for (int i = 0; i < self.stepsAry.count; i += 5) {
                NSString *stepStr = self.stepsAry[i];
                int stepsValue = [stepStr intValue];
        //        int stepsValue = [self.stepsAry[i] intValue];
                totleSteps = totleSteps + stepsValue; //求总步数
                [stepsMuteAry addObject:stepStr];
            }
            self.caculateStepsAry = stepsMuteAry;
            self.averageStepFrequency = totleSteps/self.caculateStepsAry.count; //平均步频
    }
    NSLog(@"----平均步频为%d",self.averageStepFrequency);
    
    //处理速度数组
    if (self.locationArray.count != 0) {
             NSMutableArray *speedMuteAry = [NSMutableArray array];
        double totleSpeeds = 0;
            for (int i = 0; i < self.locationArray.count; i += 160) {
                RunLocationModel *Model = self.locationArray[i];
                double speed = Model.speed;
                totleSpeeds = totleSpeeds + speed;
                NSString *speedStr = [[NSNumber numberWithDouble:speed] stringValue];
                [speedMuteAry addObject:speedStr];
            }
        self.caculateSpeedAry = speedMuteAry;
        self.averageSpeed = totleSpeeds/self.caculateSpeedAry.count;
    }
#warning 如果用下面的排序，程序会崩溃
//    //排序找出最大速度
//    RunLocationModel *Model = self.caculateSpeedAry[0];
//    self.maxSpeed = Model.speed;
//    for (int i = 1; i < self.caculateSpeedAry.count; i++) {
//        RunLocationModel *model = self.caculateSpeedAry[i];
//        double speed = model.speed;
//        if (self.maxSpeed < speed) {
//            self.maxSpeed = speed;
//        }
//    }
}

#pragma mark- 网络请求上传跑步数据
- (void)handUpData{
    
    //创建要穿上去的数据字典
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    [paramDic setObject:self.locationArray forKey:@"path"]; //跑步沿途路径
    NSString *duration = [[NSNumber numberWithDouble:self.duration] stringValue];
    [paramDic setObject:duration forKey:@"duration"]; //跑步总时间
    [paramDic setObject:self.Mainview.numberLabel.text forKey:@"mileage"]; //跑步总距离
    [paramDic setObject:self.Mainview.energyNumberLbl.text forKey:@"kcal"];
    NSString *averageSpeedStr = [[NSNumber numberWithDouble:self.averageSpeed] stringValue];
    [paramDic setObject:averageSpeedStr forKey:@"averageSpeed"]; //平均速度
    NSString *averageStepFrequencyStr = [[NSNumber numberWithInt:self.averageStepFrequency] stringValue];
    [paramDic setObject:averageStepFrequencyStr forKey:@"averageStepFrequency"]; //平均步频
    NSString *maxSpeedStr = [[NSNumber numberWithDouble:self.maxSpeed] stringValue];
    [paramDic setObject:maxSpeedStr forKey:@"maxSpeed"]; //最大速度
    NSString *maxStepFrequencyStr = [[NSNumber numberWithInt:self.maxStepFrequency] stringValue];
    [paramDic setObject:maxStepFrequencyStr forKey:@"maxStepFrequency"]; //最大步频
    [paramDic setObject:self.finishDate forKey:@"finishDate"]; //完成日期
    [paramDic setObject:self.caculateStepsAry forKey:@"stepFrequency"]; //处理后的步频数组
    [paramDic setObject:self.caculateSpeedAry forKey:@"speed"]; //处理后的速度数组

       AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
       NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
       NSString *token = [user objectForKey:@"token"];
       // 请求   TCP/IP   http
       AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
       //添加请求头
       [requestSerializer setValue:token forHTTPHeaderField:@"token"];
       [manager setRequestSerializer:requestSerializer];
       // 响应
       AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
       [responseSerializer setRemovesKeysWithNullValues:YES];  //去除空值
       responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml",nil]]; //设置接收内容的格式
       [manager setResponseSerializer:responseSerializer];
    [manager POST:HandUpRunData parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"-----------上传数据成功，得到的结果为%@",responseObject);
        NSLog(@"---------···上传的数据为%@",paramDic);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"上传跑步数据失败，结果为%@",error);
    }];
    
}

#pragma mark- 关于后台定位需要调用的代理方法
- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager *)locationManager{
    [locationManager requestAlwaysAuthorization];
}
- (void)mapViewRequireLocationAuth:(CLLocationManager *)locationManager{
    [locationManager requestAlwaysAuthorization];
}
@end
