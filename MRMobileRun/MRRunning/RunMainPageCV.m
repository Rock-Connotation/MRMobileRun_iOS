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
#import <AMapSearchKit/AMapSearchKit.h>  //搜索库，为获取天气


#import "SVGKit.h"
#import "SVGKImage.h"
#import "SVGKParser.h"
#import "UIImage+SVGTool.h"
#import "ZYLMainViewController.h"
#import "MGDTabBarViewController.h"
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
@interface RunMainPageCV ()<MAMapViewDelegate,AMapLocationManagerDelegate,CLLocationManagerDelegate,AMapSearchDelegate,UITraitEnvironment>
{
    CGFloat _yyy;
}
@property (nonatomic, strong) RunningMainPageView *Mainview;

//关于时间
@property (nonatomic, strong) NSTimer *runTimer;
@property (nonatomic, strong) NSDate *beginTime;  //开始的时间（系统时间）
@property (nonatomic, strong) NSDate *endTime;    //结束时间（系统时间）
@property (nonatomic, strong) NSString *timeString; //跑步的时间（经历过格式转换后的）
@property (nonatomic) int hour;
@property (nonatomic) int minute;
@property (nonatomic) int second;

//数组
    //关于步频
@property (nonatomic, strong) NSMutableArray *stepsAry; //每分钟的步数
@property (nonatomic, strong) NSArray *updateStepsAry; //上传的步频数组
@property int averageStepFrequency; //平均步频
@property int maxStepFrequency; //最大步频
@property (nonatomic, strong) NSMutableArray *mintesAry; //跑步过程中的分钟数的数组
//此跑步页经过处理后，要给跑步完成界面绘图的步频数组
@property (nonatomic, strong) NSArray *cacultedStepsAry;

    //关于速度
@property (nonatomic, strong) NSMutableArray *speedAry; //速度的数组
@property (nonatomic, strong) NSArray *updateSpeedAry; //上传的速度数组
@property double averageSpeed; //平均速度
@property double maxSpeed; //最大速度
//此跑步页经过处理后，要给跑步完成界面绘图的速度数组
@property (nonatomic, strong) NSArray *caculatedSpeedAry;


@property double mileage; //总路程
@property double duration; //总时间
@property (nonatomic, strong) NSString *finishDate;//完成的日期

@property double kcal; //燃烧千卡；

//关于模型
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


@property (nonatomic, assign) CGFloat signal; //信号强度

//跑步结束时的AlertView
@property (nonatomic, strong) SZHAlertView *shortAlert; //跑步距离过短时
@property (nonatomic, strong) SZHAlertView *normalAlert;

//关于实时天气
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) NSString *temperature; //温度
@property (nonatomic, strong) NSString *weather;  //天气

//关于上传跑步数据
@property (nonatomic, strong) NSMutableArray *pathMuteAry;

@property double maxSpeedLast; //最大速度
@property double maxStepLast; //最大步频
@end

@implementation RunMainPageCV

- (void)viewDidLoad {
    [super viewDidLoad];
    //关于一些初始化设置
    self.locationArray = [NSMutableArray array];
    self.drawLineArray = [NSMutableArray array];
    self.distance = 0;
    self.kcal = 0;
    self.mintesAry = [NSMutableArray array];
    self.stepsAry = [NSMutableArray array];
    self.speedAry = [NSMutableArray array];
    self.updateSpeedAry = [NSArray array];
    self.updateStepsAry = [NSArray array];
    self.pathMuteAry = [NSMutableArray array];
    self.caculatedSpeedAry = [NSArray array]; //处理后的速度数组
    self.cacultedStepsAry = [NSArray array]; //处理后的步频数组

    
    //跑步首页UI
    self.Mainview = [[RunningMainPageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.Mainview];
    [self.Mainview mainRunView];
    
    //关于地图的设置
    self.Mainview.mapView.delegate = self; //设置地图代理
    
    [self initAMapLocation]; //初始化位置管理者
    
    [self aboutLables]; //添加显示公里数的lable
    //给拖拽的label添加手势
     UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragAction:)];
    [self.Mainview.dragLabel addGestureRecognizer:pan];
    self.Mainview.dragLabel.userInteractionEnabled = YES;
    
    
    
    [self btnFunction]; //跑步首页关于继续暂停等按钮的方法
    
    
    //关于天气
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
   // 跑步时间初始化
        //得到最初的开始时间
    NSDate *date = [NSDate date];
    self.beginTime = date;
    NSLog(@"第一次开始的时间是===%@",date);
    self.runTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
     self.second = self.minute = self.hour = 0;
}

//关于显示公里数的label和显示“公里”的lable
- (void)aboutLables{
    //显示公里数的label
    self.mileNumberLabel = [[UILabel alloc] init];
    self.mileNumberLabel.frame = CGRectMake(0, screenHeigth * 0.2696, screenWidth, 100);
    [self.view addSubview:self.mileNumberLabel];
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
    [self.view addSubview:self.mileTexteLable];
    self.mileTexteLable.textAlignment = NSTextAlignmentCenter;
    self.mileTexteLable.text = @"公里";
    self.mileTexteLable.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 22];
    if (@available(iOS 11.0, *)) {
        self.mileTexteLable.textColor = MilesTxetColor;
    } else {
        // Fallback on earlier versions
    }
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
                self.Mainview.topView.alpha = 0.6; //恢复原来的透明度
                //设置draglabel里面的图片
    self.Mainview.dragimageView.backgroundColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1.0];
        self.Mainview.dragimageView.image = nil;
      //设置底部视图的高度
        [self.Mainview.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.top.equalTo(self.Mainview.mas_top).offset(screenHeigth * 0.5369);
                }];
    //设置显示公里数的label和显示公里的lable
                //显示公里数
            self.mileNumberLabel.font = [UIFont fontWithName:@"Impact" size: 82];
             CGRect frame = CGRectMake(0, screenHeigth * 0.2696, screenWidth, 100);
                [UIView animateWithDuration:0.5 animations:^{
                    self.mileNumberLabel.frame = frame;
                }];
                //显示公里
                self.mileTexteLable.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 22];
                CGRect frame2 = CGRectMake(screenWidth * 0.4427, screenHeigth * 0.2696 + 100, 44, 30);
                [UIView animateWithDuration:0.5 animations:^{
                    self.mileTexteLable.frame = frame2;
                }];
                //设置用户小蓝点和定位轨迹隐藏
//                self.Mainview.mapView.showsUserLocation = NO;
            }
            if(y > screenHeigth * 0.15) {
                    
                       y = screenHeigth * 0.3;
                self.Mainview.topView.alpha = 0;
                    self.Mainview.dragimageView.backgroundColor = [UIColor clearColor];
                self.Mainview.dragimageView.image = [UIImage imageNamed:@"底部位置"];
                                   
                //更新对bottomView的约束，使得它的高度变化
                [self.Mainview.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.equalTo(self.view);
                    make.top.equalTo(self.Mainview.mas_top).offset(screenHeigth * 0.4869 + y);
                }];
                    //更换numberLabel的位置和显示公里的位置
    //显示公里数
    CGRect originNumberFrame = CGRectMake(screenWidth * 0.64, screenHeigth * 0.0495, 84, 53);
    [UIView animateWithDuration:0.5 animations:^{
        self.mileNumberLabel.frame = originNumberFrame;
        }];
self.mileNumberLabel.font = [UIFont fontWithName:@"Impact" size:44];
    //显示公里
                     self.mileTexteLable.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];
                    CGRect originFrame2 = CGRectMake(screenWidth * 0.64 + 84, screenHeigth * 0.0572, 36, 25);
                    [UIView animateWithDuration:0.5 animations:^{
                        self.mileTexteLable.frame = originFrame2;
            }];
                //设置用户位置小蓝点和地图轨迹显示
                self.Mainview.mapView.showsUserLocation = YES;
        }
    }
}
                 

#pragma mark- 加载位置管理者
- (void)initAMapLocation{
    _locationManager = [[AMapLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 10;//设置移动精度(单位:米)
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest]; //设置期望定位精度
    _locationManager.locationTimeout = 2;//定位时间
    _locationManager.allowsBackgroundLocationUpdates = YES;//开启后台定位
     [_locationManager setLocatingWithReGeocode:YES]; //连续定位是否返回逆地理信息
    [_locationManager startUpdatingLocation];
   
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

#pragma mark- ---------------------------------地图的代理方法------------------------------------
    //设置地图的自动转向以及用户小蓝点的自动转向
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
    //设置用户小蓝点的自动转向
    if (!updatingLocation) {
         MAAnnotationView *userLocationView = [mapView viewForAnnotation:mapView.userLocation];
         [UIView animateWithDuration:0.1 animations:^{
            double degree = userLocation.heading.trueHeading - self.Mainview.mapView.rotationDegree;
            userLocationView.imageView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
        }];
    }
}

//定位数据
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
         //设置地图中心为当前的经纬度
        [self.Mainview.mapView setCenterCoordinate:location.coordinate];
         //最开始的一个定位点
          if (self.locationArray.count == 0) {
            RunLocationModel *StartPointModel = [[RunLocationModel alloc] init];
            StartPointModel.location = location.coordinate;
            StartPointModel.speed = location.speed;
            StartPointModel.time = [NSDate date];
            [self.locationArray addObject:StartPointModel];//向位置数组里面添加第一个定位点
            [self.drawLineArray addObject:StartPointModel];//向绘制轨迹点的数组里添加第一个定位点

              //收集速度
              double speed = location.speed;
              NSLog(@"速度为%f",speed);
              //进行速度逻辑判断，速度大于0小于9.97m/s才是正常跑步速度
              if (speed >= 0 && speed < 9.97) {
                  NSString *speedStr = [NSString stringWithFormat:@"%0.2f",speed];
                  [self.speedAry addObject:speedStr];
                  NSLog(@"第一次添加速度%@",self.speedAry);
              }
             
            //展示配速
            int speedMinutes = (int)(1000/StartPointModel.speed)/60;
            int speedSeconds = (int)(1000/StartPointModel.speed)%60;
              if (speedMinutes > /* DISABLES CODE */ (99) && speedMinutes < 0) {
                self.Mainview.speedNumberLbl.text = @"--'--''";
            }else if(speedMinutes > 0){
                self.Mainview.speedNumberLbl.text = [NSString stringWithFormat:@"%d'%d''",speedMinutes,speedSeconds];
            }
              //位置数组不为空，开始后续的定位点
        }else if (self.locationArray.count != 0) {
            RunLocationModel *LastlocationModel = self.locationArray.lastObject;
            //当前定位的位置信息model
            RunLocationModel *currentModel = [[RunLocationModel alloc] init];
            currentModel.location = location.coordinate;
            currentModel.time = [NSDate date];
            currentModel.speed = location.speed;
            
            //收集速度,每半分钟采集一次
            NSLog(@"%d",self.second);
            if (self.second % 30 == 0) {
                double speed = location.speed;
                if (speed >=0 && speed < 9.97) {
                    NSString *speedStr = [NSString stringWithFormat:@"%0.2f",speed];
                    [self.speedAry addObject:speedStr];
                }
            }
//            NSLog(@"速度数组内的数目为%lu",(unsigned long)self.speedAry.count);
            //计算距离
            [self distanceWithLocation:LastlocationModel andLastButOneModel:currentModel];
                //计算配速
                int speedMinutes = (int)(1000/currentModel.speed)/60;
                int speedSeconds = (int)(1000/currentModel.speed)%60;
                if (speedMinutes > /* DISABLES CODE */ (99) && speedMinutes < 0) {
                    self.Mainview.speedNumberLbl.text = @"--'--''";
                }else if(speedMinutes > 0){
                  self.Mainview.speedNumberLbl.text = [NSString stringWithFormat:@"%d'%d''",speedMinutes,speedSeconds];
                
                //计算燃烧千卡
                self.kcal = 60 * self.distance * 1.036;
                self.Mainview.energyNumberLbl.text = [NSString stringWithFormat:@"%0.1f",self.kcal];
                       }

#pragma mark- 绘制轨迹
//            //为了美化移动的轨迹，移动的位置超过10米，才添加进绘制轨迹的的数组
//                RunLocationModel *lineLastPointLocation = [self.drawLineArray lastObject];
//                //开始绘制轨迹
//                CLLocationCoordinate2D linePoints[2];
//                linePoints[0] = lineLastPointLocation.location;
//                linePoints[1] = self.locationModel.location;
//                //调用addOverlay方法后回进入 renderForOverlay 方法，完成对轨迹的绘制
//                MAPolyline *lineSection  = [MAPolyline polylineWithCoordinates:linePoints count:2];
//                [self.Mainview.mapView addOverlay:lineSection];
//                [self.drawLineArray addObject:self.locationModel]; //为绘制轨迹的位置数组添加新的元素
//                NSLog(@"绘制轨迹的数组内的元素个数为%lu-----位置数组内的元素个数为%lu",(unsigned long)self.drawLineArray.count,(unsigned long)self.locationArray.count);
        }
    }

    //获取实时天气
//    NSLog(@"逆地理编码为%@",reGeocode);
//    if (reGeocode != nil) {
//        AMapWeatherSearchRequest *request = [[AMapWeatherSearchRequest alloc] init];
//        request.city = reGeocode.city;
//        request.type = AMapWeatherTypeLive; //天气类型为实时天气
//        [self.search AMapWeatherSearch:request];
//    }
    AMapWeatherSearchRequest *request = [[AMapWeatherSearchRequest alloc] init];
    request.city = @"重庆";
    request.type = AMapWeatherTypeLive; //天气类型为实时天气
    [self.search AMapWeatherSearch:request];

}

//计算距离
-(void)distanceWithLocation:(RunLocationModel *)lastModel andLastButOneModel:(RunLocationModel *)lastButOneModel{
    CLLocationDistance Meters = 0;
    MAMapPoint point1 = MAMapPointForCoordinate(lastModel.location);
    MAMapPoint point2 = MAMapPointForCoordinate(lastButOneModel.location);
       //2.计算距离
       CLLocationDistance newdistance = MAMetersBetweenMapPoints(point1,point2);
    //计算两个定位点的时间差
    NSTimeInterval secondesBetweenPoints = [lastModel.time timeIntervalSinceDate:lastButOneModel.time];
       
    if ((float)newdistance/secondesBetweenPoints < 9.97) {
         Meters = newdistance;
        double KMeters = Meters/1000;
        self.distance = self.distance + KMeters;
        self.mileNumberLabel.text = [NSString stringWithFormat:@"%.02f",self.distance];
        [self.locationArray addObject:lastButOneModel];
        //如果两点间的距离大于10米，就添加至绘制轨迹数组内
        if (Meters > 10) {
            [self.drawLineArray addObject:lastButOneModel];
        }
        //绘制轨迹
        [self drawRunLineAction];
    }
}

#pragma mark- 获取天气的代理回调方法
- (void)onWeatherSearchDone:(AMapWeatherSearchRequest *)request response:(AMapWeatherSearchResponse *)response{
    if (response.lives.count == 0) {
        return;
    }
    AMapLocalWeatherLive *liveWeather = response.lives.firstObject;
    if (liveWeather != nil) {
        self.temperature = liveWeather.temperature;
        self.weather = liveWeather.weather;
        NSLog(@"获得的天气为：温度：%@，天气：%@",self.temperature,self.weather);
    }
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
//绘制轨迹线:全图只绘制一条轨迹线
- (void)drawRunLineAction{
    CLLocationCoordinate2D commonPolylineCoords[self.drawLineArray.count];
    for (int i = 0; i < self.drawLineArray.count; i++) {
        RunLocationModel *model = self.drawLineArray[i];
        commonPolylineCoords[i] = model.location;
    }
    [self.Mainview.mapView removeOverlay:self.polyline]; //移除之前的轨迹线
    //设置出新的从开始到当前点的轨迹线
    self.polyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:self.drawLineArray.count];
    [self.Mainview.mapView addOverlay:self.polyline];
}

//自定义轨迹线
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay{
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineRenderer *polyLineRender = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        polyLineRender.lineWidth = 8;
        polyLineRender.strokeColor = [UIColor colorWithRed:129/255.0 green:233/255.0 blue:255/255.0 alpha:1.0]; //折线颜色
        return polyLineRender;
  }
    return nil;
}

#pragma mark- 关于后台定位需要调用的代理方法
- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager *)locationManager{
    [locationManager requestAlwaysAuthorization];
}
- (void)mapViewRequireLocationAuth:(CLLocationManager *)locationManager{
    [locationManager requestAlwaysAuthorization];
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
    //如果有一分钟了执行一下操作来获取步频
    if (self.second%60 == 0) {
        NSDate *date = [NSDate date];
        self.endTime = date;
        NSLog(@"第一次以及后面很多次结束的时间为%@",self.endTime);
        [self caculatePace]; //获取这一分钟内的步数
        self.beginTime = self.endTime;
        NSLog(@"后续开始时间为%@",self.beginTime);
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
    [self.locationManager startUpdatingLocation];
    
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
    
    self.Mainview.dragLabel.userInteractionEnabled = NO;
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
    
    self.Mainview.dragLabel.userInteractionEnabled = YES;
}

//长按结束按钮方法
- (void)endMethod{
    self.mileage = self.distance; //总路程
    self.duration = self.second; //总时间
    
    //设置上传的速度数组
    NSMutableArray *mueArySpeed2 = [NSMutableArray array];
    for (int i = 0; i < self.speedAry.count; i++) {
       
        double speed = [self.speedAry[i] floatValue];
        NSNumber *n1 = [NSNumber numberWithDouble:speed];
        NSNumber *n2 = [NSNumber numberWithInt:i+1];
//        NSString *string =  [NSString stringWithFormat:@"%0.2f",speed];
//        NSString *string2 = [NSString stringWithFormat:@"%d",i+1];
//        float array1[2];
//        array1[0] = speed;
//        array1[1] = i;
        NSMutableArray *muteArySpeed = [NSMutableArray array];
//        [muteArySpeed addObject:string];
//        [muteArySpeed addObject:string2];
        [muteArySpeed addObject:n1];
        [muteArySpeed addObject:n2];
        NSArray *array = muteArySpeed;
        [mueArySpeed2 addObject:array];
    }
    NSArray *updateSpeedAry = mueArySpeed2;
    self.updateSpeedAry = updateSpeedAry;
    NSLog(@"上传的的速度数组为%@",self.updateSpeedAry);
    
     //设置上传的步频数组
       if (self.stepsAry != nil) {
           NSMutableArray *muteStepsArray = [NSMutableArray array];
           for (int i = 0; i < self.stepsAry.count; i++) {
               int steps = [self.stepsAry[i] intValue];
               NSString *string1 = [[NSNumber numberWithInt:steps] stringValue];
               NSString *string2 = [NSString stringWithFormat:@"%d",i+1];
               NSMutableArray *mutearray = [NSMutableArray array];
               [mutearray addObject:string1];
               [mutearray addObject:string2];
               NSArray *array = mutearray;
               [muteStepsArray addObject:array];
           }
           self.updateStepsAry = muteStepsArray;
       }
    
    [self averageSpeedAndSteps];           //找出平均速度和平均步频
    //为跑步结束页的图表处理步频和速度数组并且找出处理后的最大数组和最大步频
    [self caculateSpeedAndStpesArray];
    
//    //获取当前日期
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
//    self.finishDate = [formatter stringFromDate:date];
    NSString *formaterTime = [formatter stringFromDate:date];
    //将当前日期转化为时间戳
    NSDate *date1 = [formatter dateFromString:formaterTime];
    NSInteger timeSp = [[NSNumber numberWithDouble:[date1 timeIntervalSince1970]] integerValue];
    self.finishDate = [NSString stringWithFormat:@"%ld",(long)timeSp];
    NSLog(@"获取到的时间戳为%@",self.finishDate);
    
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

    [self.navigationController popToRootViewControllerAnimated:YES];
    //停止定时器
    [self.runTimer invalidate];
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
           if (@available(iOS 12.0, *)) {
               MGDDataViewController *overVC = [[MGDDataViewController alloc] init];
               //属性传值
               overVC.distanceStr = self.mileNumberLabel.text; //跑步距离
               
               overVC.speedStr = self.Mainview.speedNumberLbl.text; //配速
               
               overVC.caculatedSpeedAry = self.caculatedSpeedAry;//为绘制速度图处理的数组
               overVC.cacultedStepsAry = self.cacultedStepsAry; //为绘制步频图处理的数组
               
               overVC.averageSpeed = self.averageSpeed; //平均速度
               overVC.maxSpeedLastest = self.maxSpeedLast; //最大速度
               overVC.averageStepFrequency = self.averageStepFrequency; //平均步频
               overVC.maxStepFrequencyLastest = self.maxStepLast; //最大步频
               
               overVC.timeStr = self.timeString; //时间
               overVC.energyStr = self.Mainview.energyNumberLbl.text; //千卡
               overVC.drawLineAry = self.drawLineArray;
               overVC.locationAry = self.locationArray;
               overVC.temperature = self.temperature; //温度
               overVC.weather = self.weather; //天气
               
               self.hidesBottomBarWhenPushed = YES;
               [self.navigationController pushViewController:overVC animated:YES];
           } else {
               // Fallback on earlier versions
           }
        self.tabBarController.tabBar.hidden = YES;
       });
    
    //停止定时器
    [self.runTimer invalidate];
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
            [healthManager getStepCountFromBeginTime:self.beginTime ToEndTime:self.endTime completion:^(double stepValue, NSError * _Nonnull error) {
                
                steps = [[NSNumber numberWithDouble:stepValue] stringValue];
                
            }];
            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                if (steps!= nil) {
                    [weakSelf.stepsAry addObject:steps];
                }
            });
        });
    }];
}

//找出平均步频和平均速度
- (void)averageSpeedAndSteps{
     //平均速度
        self.averageSpeed = 0; //对平均速度进行初始赋值
        self.averageSpeed = (self.distance * 1000)/self.second;
    //    NSLog(@"此次跑步的平均速度为%f",self.averageSpeed);
    
    //平均步频
    self.averageStepFrequency = 0; //对平均步频进行初始赋值
    if (!self.stepsAry) {
        int totleSteps = 0;
        for (int i = 0; i < self.stepsAry.count; i++) {
            NSString *stepsStr = self.stepsAry[i];
            int steps = [stepsStr intValue];
            totleSteps = totleSteps + steps;
        }
        self.averageStepFrequency = totleSteps/self.stepsAry.count;
    }
}

//为跑步完成界面的步频、速度图绘制对原始的采集数组进行处理
- (void)caculateSpeedAndStpesArray{
    //处理步频的数组并找出处理后的最大步频
    self.maxStepLast = 0;
    NSMutableArray *stepsMuteAry = [NSMutableArray array];
    if (self.stepsAry != nil) {
            //五分钟一个点
         for (int i = 0; i < self.stepsAry.count; i += 5) {
             // 0 0 0 0 0 0/ 0 0 0 0 0
               NSString *stepStr = self.stepsAry[i];
               [stepsMuteAry addObject:stepStr];
               //找出最处理后的数组中最大的步频
               double step = [stepStr doubleValue];
               if (self.maxStepLast < step) {
                   self.maxStepLast = step;
               }
           }
           self.cacultedStepsAry = stepsMuteAry;
        if (self.cacultedStepsAry.count != 0) {
        NSLog(@"处理后的步频数组为%@,处理后最大的步频为%f",self.cacultedStepsAry,self.maxStepLast);
        }
    }
    
    
    //处理速度的数组并找出处理后的最大速度
    self.maxSpeedLast = 0;
    if (self.speedAry != nil) {
        NSMutableArray *speedMuteAry = [NSMutableArray array];
            //两分半记录一个点
        for (int i = 0; i < self.speedAry.count; i += 5) {
            RunLocationModel *Model = self.locationArray[i];
            double speed = Model.speed;
            NSString *speedStr = [NSString stringWithFormat:@"%0.2f",speed];
            [speedMuteAry addObject:speedStr];
            //找出处理后的数组里最大的速度
            if (self.maxSpeedLast < speed) {
                self.maxSpeedLast = speed;
                }
            }
            self.caculatedSpeedAry = speedMuteAry;
            NSLog(@"处理后的速度数组为%@,处理后最大的速度为%f",self.caculatedSpeedAry,self.maxSpeedLast);
    }
    
}

#pragma mark- 网络请求上传跑步数据
- (void)handUpData{
    
    //创建要传上去的数据字典
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    
    //获取跑步路径数据
//    NSMutableArray *muteAry = [NSMutableArray array];
//    NSArray *path = [NSArray array];
    for (int i = 0; i < self.locationArray.count; i++ ) {
        RunLocationModel *model = self.locationArray[i];
        CLLocationCoordinate2D coordinate = model.location;
//        double latitude = coordinate.latitude;
//        double lontitude = coordinate.longitude;
        double latitude = coordinate.latitude;
        double lontitude = coordinate.longitude;
//        NSString *location = [NSString stringWithFormat:@"%f,%f",latitude,lontitude];
//        [muteAry addObject:location];
        NSMutableArray *sectionPath = [NSMutableArray array];
        NSNumber *lati = [NSNumber numberWithDouble:latitude];
        NSNumber *lonti = [NSNumber numberWithDouble:lontitude];
        [sectionPath addObject:lati];
        [sectionPath addObject:lonti];
//            path = sectionPath;
        [self.pathMuteAry addObject:sectionPath];
//        [self.pathMuteAry addObject:sectionPath];
//        NSString *lat = [NSString stringWithFormat:@"%f",latitude];
//        NSString *lon = [NSString stringWithFormat:@"%f",lontitude];
//        [muteAry addObject:lat];
//        [muteAry addObject:lon];
    }
//    path = muteAry;
//    [self.pathMuteAry addObject:path];
    [paramDic setValue:self.pathMuteAry forKey:@"path"]; //跑步沿途路径
    
    //跑步时间必须小于23时59分
    if (self.duration < 1440) {
         NSString *duration = [[NSNumber numberWithDouble:self.duration] stringValue];
        [paramDic setValue:duration forKey:@"duration"]; //跑步总时间
    }
    
    NSString *mileage = [NSString stringWithFormat:@"%0.2f",self.distance];
    [paramDic setValue:mileage forKey:@"mileage"]; //跑步总距离
    
    NSString *kcal = [NSString stringWithFormat:@"%0.2f",self.kcal];
    [paramDic setValue:kcal forKey:@"kcal"];//跑步消耗能量
    
    NSString *averageSpeedStr = [[NSNumber numberWithDouble:self.averageSpeed] stringValue];
    [paramDic setValue:averageSpeedStr forKey:@"averageSpeed"]; //平均速度
    
    NSString *averageStepFrequencyStr = [[NSNumber numberWithInt:self.averageStepFrequency] stringValue];
    [paramDic setValue:averageStepFrequencyStr forKey:@"averageStepFrequency"]; //平均步频
    
    NSString *maxSpeedStr = [[NSNumber numberWithDouble:self.maxSpeed] stringValue];
    [paramDic setValue:maxSpeedStr forKey:@"maxSpeed"]; //最大速度
    
    NSString *maxStepFrequencyStr = [[NSNumber numberWithInt:self.maxStepFrequency] stringValue];
    [paramDic setValue:maxStepFrequencyStr forKey:@"maxStepFrequency"]; //最大步频
    
    [paramDic setValue:self.finishDate forKey:@"finishDate"]; //完成日期
    NSLog(@"上传的日期为%@",self.finishDate);
    
    
    if (self.updateStepsAry.count == 0) {
        NSMutableArray *muteAry2 = [NSMutableArray array];
        NSString *string = [NSString stringWithFormat:@"%d",0];
        NSString *string2 = [NSString stringWithFormat:@"%d",1];
        NSMutableArray *muteary = [NSMutableArray array];
        [muteary addObject:string2];
        [muteary addObject:string];
        NSArray *array = muteary;
        [muteAry2 addObject:array];
        
        self.updateStepsAry = muteAry2;
        [paramDic setValue:self.updateStepsAry forKey:@"stepFrequency"]; //上传的步频数组
    }else{
        [paramDic setValue:self.updateStepsAry forKey:@"stepFrequency"]; //上传的步频数组
    }
     
    [paramDic setValue:self.updateSpeedAry forKey:@"speed"];//速度分布数组
    
    //天气
    if ([self.weather isEqualToString:@"雷阵雨"]) {
       [paramDic setValue:@"0" forKey:@"weather"];
    }else if ([self.weather isEqualToString:@"晴"]){
        [paramDic setValue:@"1" forKey:@"weather"];
    }else if ([self.weather isEqualToString:@"雪"]){
        [paramDic setValue:@"2" forKey:@"weather"];
    }else if ([self.weather isEqualToString:@"阴"] || [self.weather isEqualToString:@"多云"]){
       [paramDic setValue:@"3" forKey:@"weather"];
    }else if([self.weather isEqualToString:@"雨"]){
        [paramDic setValue:@"4" forKey:@"weather"];
    }
    
    [paramDic setValue:self.temperature forKey:@"temperature"]; //温度
    
    NSLog(@"未上传数据时的数据字典为%@",paramDic);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    // 响应
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    [responseSerializer setRemovesKeysWithNullValues:YES];  //去除空值
    responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",nil]]; //设置接收内容的格式
    [manager setResponseSerializer:responseSerializer];
    //将token添加进请求头
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",token] forHTTPHeaderField:@"token"];

    [manager POST:HandUpRunData parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"-----------上传数据成功，得到的结果为%@",responseObject);
        NSLog(@"---------···上传的数据为%@",paramDic);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"上传数据失败，上传的参数为");
        NSLog(@"%@",error);
    }];
}

//监听系统的颜色模式来配置地图的白天、深色模式下的自定义样式
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [super traitCollectionDidChange: previousTraitCollection];
    if (@available(iOS 13.0, *)) {
        if([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]){
            if (@available(iOS 13.0, *)) {
              UIUserInterfaceStyle  mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
                if (mode == UIUserInterfaceStyleDark) {
                    NSLog(@"深色模式");
                    //设置深色模式下的自定义地图样式
                    NSString *path =   [[NSBundle mainBundle] pathForResource:@"style" ofType:@"data"];
                          NSData *data = [NSData dataWithContentsOfFile:path];
                           MAMapCustomStyleOptions *options = [[MAMapCustomStyleOptions alloc] init];
                           options.styleData = data;
                    [self.Mainview.mapView setCustomMapStyleOptions:options];
                    [self.Mainview.mapView setCustomMapStyleEnabled:YES];
                    //设置深色模式下的svg格式的图片
                        //暂停按钮
                    self.Mainview.pauseBtn.logoImg.image = [UIImage svgImgNamed:@"暂停黑.svg" size:CGSizeMake(30, 30)];
                        //解锁按钮
                    self.Mainview.unlockLongPressView.imgView.image = [UIImage svgImgNamed:@"锁定黑.svg" size:CGSizeMake(30, 30)];
                        //锁屏按钮
                    self.Mainview.lockImageView.image = [UIImage svgImgNamed:@"锁定灰.svg" size:CGSizeMake(25, 25)];
                    
                } else if (mode == UIUserInterfaceStyleLight) {
                    NSLog(@"浅色模式");
                    //设置浅色模式下的自定义地图样式
                    NSString *path =   [[NSBundle mainBundle] pathForResource:@"style2" ofType:@"data"];
                       NSData *data = [NSData dataWithContentsOfFile:path];
                        MAMapCustomStyleOptions *options = [[MAMapCustomStyleOptions alloc] init];
                        options.styleData = data;
                    [self.Mainview.mapView setCustomMapStyleOptions:options];
                    [self.Mainview.mapView setCustomMapStyleEnabled:YES];
                    
                    //设置浅色模式下的svg格式的图片
                        //暂停按钮
                    self.Mainview.pauseBtn.logoImg.image = [UIImage svgImgNamed:@"暂停白.svg" size:CGSizeMake(30, 30)];
                        //解锁按钮
                    self.Mainview.unlockLongPressView.imgView.image = [UIImage svgImgNamed:@"锁定白.svg" size:CGSizeMake(30, 30)];
                        //锁屏按钮
                    self.Mainview.lockImageView.image = [UIImage svgImgNamed:@"锁定黑.svg" size:CGSizeMake(25, 25)];
                } else {
                    NSLog(@"未知模式");
                }
            }
        }
    } else {
        // Fallback on earlier versions
    }
}
- (void)dealloc{
    NSLog(@"跑步首页控制器已经被销毁了！");
}
@end
