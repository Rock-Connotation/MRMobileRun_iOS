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

#import "RunMainPageCV.h"
#import "RunningMainPageView.h"
#import "RunningModel.h"
#import "RunLocationModel.h"
#import "MGDDataViewController.h"
#import "SZHAlertView.h" //跑步距离过短时结束的提示弹窗
#import "RecordtimeString.h"
@interface RunMainPageCV ()<MAMapViewDelegate,RunmodelDelegate,AMapLocationManagerDelegate,CLLocationManagerDelegate>
@property (nonatomic, strong) RunningMainPageView *Mainview;

//关于时间
@property (nonatomic, strong) NSTimer *runTimer;
@property (nonatomic, strong) NSString *beginTime;  //开始的时间（系统时间）
@property (nonatomic, strong) NSString *endTime;    //结束时间（系统时间）
@property (nonatomic, strong) NSString *timeString; //跑步的时间（经历过格式转换后的）
@property (nonatomic) int hour;
@property (nonatomic) int minute;
@property (nonatomic) int second;


//关于模型
@property (nonatomic, strong) RunningModel *model;
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


- (void)viewDidAppear:(BOOL)animated{
//    self.sportsState = SportsStateStart;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstLocation = YES;
    self.isEndLocation = NO;
    //跑步首页UI
    self.Mainview = [[RunningMainPageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.Mainview];
    [self.Mainview mainRunView];
    
//    [self initlocation];
    [self initAMapLocation];
    [self btnFunction];
    self.Mainview.mapView.delegate = self;
    
    //跑步时间初始化
    self.runTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
     self.second = self.minute = self.hour = 0;
    

    
}



// #pragma mark- 状态监听
// - (void)setSportsState:(SportsState)sportsState{
//     sportsState = self.sportsState;
//     switch (sportsState) {
//         case SportsStateIdle:{
//             if (self.polyline != nil ) {
////                 [self.locationManager stopUpdatingLocation];
//                 [self.Mainview.mapView removeOverlay:self.polyline];
//             }
//             self.distance = 0;
//             self.locationNumber = 0;
//             self.isFirstLocation = YES;
//             self.drawLineArray = [NSMutableArray arrayWithCapacity:16];
//             break;
//         }
//         case SportsStateStart:{
//             if (self.polyline != nil) {
//                 [self.Mainview.mapView removeOverlay:self.polyline];
//             }
//             self.distance = 0;
//             self.locationNumber = 0;
//             self.isFirstLocation = YES;
//             self.locationModel = [[RunLocationModel alloc] init];
//             self.locationArray = [NSMutableArray array];
//
//             self.drawLineArray = [NSMutableArray arrayWithCapacity:16];
////             [self.locationManager startUpdatingLocation];//开始持续定位
//             
//             /*
//              是否使用陀螺仪（用经纬度计算距离，单纯用陀螺仪的计步来计算步频）
//              */
//             
//         }
//             
//         case SportsStateRunning:
//             
//             return;
//             
//         case SportsStateStop:
////             [self.locationManager stopUpdatingLocation];
//             self.isEndLocation = YES;
//             RunLocationModel *endLocationModel = self.locationArray.lastObject;
//             [self drawEndRunPointAction:endLocationModel];
//              
//             break;
//     }
// }

#pragma mark- 懒加载位置管理者
//- (AMapLocationManager *)locationManager{
//    if (!_locationManager) {
//        _locationManager = [[AMapLocationManager alloc] init];
//            _locationManager.delegate = self;
//            _locationManager.distanceFilter = 5;//设置移动精度(单位:米)
//            _locationManager.locationTimeout = 3;//定位时间
//            _locationManager.allowsBackgroundLocationUpdates = YES;//开启后台定位
//            [_locationManager startUpdatingLocation];
//            [_locationManager setLocatingWithReGeocode:YES];
//        }
//        return _locationManager;
//}
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
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
#pragma mark- 根据信号强度改变左上角的GPS信号图片

    CGFloat signal = userLocation.location.horizontalAccuracy;
    self.signal = signal;


    if(!updatingLocation)
        return ;

    if (userLocation.location.horizontalAccuracy < 0)
    {
        return ;
    }

//    //设置信号强度，小于80，大于0的时候进来
//    if (self.signal < 80 && self.signal >0) {
//#pragma mark- 一下关于位置点距离测算以及画轨迹与locationManager里面设置的方法重复，记得删除一个
//
//        if (self.locationArray.count == 0) {
//            self.isFirstLocation = YES;
//            self.distance = 0;
//            self.Mainview.numberLabel.text = [NSString stringWithFormat:@"%0.2f",self.distance];
//            [self.Mainview.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
//
//                RunLocationModel *StartPointModel = [[RunLocationModel alloc] init];
//                StartPointModel.location = userLocation.location.coordinate;
//                StartPointModel.speed = userLocation.location.speed;
//                StartPointModel.time = userLocation.location.timestamp;
//                [self.locationArray addObject:StartPointModel]; //向位置数组里面添加第一个定位点
//                [self.drawLineArray addObject:StartPointModel];     //向画轨迹的位置数组里添加第一个定位定
//                [self drawStartRunPointAction:StartPointModel];
//                self.isFirstLocation = NO;
//                self.isEndLocation = NO;
//        }
//        if (self.locationArray.count != 0) {
//                RunLocationModel *LastlocationModel = self.locationArray.lastObject;
//
//            //当前定位的位置信息model
//                RunLocationModel *currentModel = [[RunLocationModel alloc] init];
//                currentModel.location = userLocation.location.coordinate;
//                currentModel.time = userLocation.location.timestamp;
//                currentModel.speed = userLocation.location.speed;
//                //计算距离
//                double meters = [self distanceWithLocation:LastlocationModel andLastButOneModel:currentModel];
//                self.locationModel = currentModel;
//                [self.locationArray addObject:self.locationModel]; //向位置数组里添加跑步过程中每次定位的定位点
//                //将距离添加到屏幕上
//                double KMeters = meters/1000;
//                self.distance = self.distance + KMeters;
//                self.Mainview.numberLabel.text = @"0";
//                self.Mainview.numberLabel.text = [NSString stringWithFormat:@"%.02f",self.distance];
//
//            //为了美化移动的轨迹，移动的位置超过10米，才添加进绘制轨迹的的数组
//            if (meters >= 5) {
////                [self.drawLineArray addObject:self.locationModel]; //向位置数组里添加跑步过程中每次定位的定位点
//                RunLocationModel *lineLastPointLocation = [[RunLocationModel alloc] init];
//                //开始绘制轨迹
//                CLLocationCoordinate2D linePoints[2];
//                linePoints[0] = lineLastPointLocation.location;
//                linePoints[1] = self.locationModel.location;
//                //调用addOverlay方法后回进入 renderForOverlay 方法，完成对轨迹的绘制
//                MAPolyline *lineSection  = [MAPolyline polylineWithCoordinates:linePoints count:2];
//                [self.Mainview.mapView addOverlay:lineSection];
//                [self.drawLineArray addObject:self.locationModel]; //为绘制轨迹的位置数组添加新的元素
//            }
//
//        }
//    }
}
//
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    self.signal = location.horizontalAccuracy;
//    if (self.signal < 80 && self.signal >0){
        if (self.locationArray.count == 0) {
            
            self.distance = 0;
            self.Mainview.numberLabel.text = [NSString stringWithFormat:@"%0.2f",self.distance];
            
            RunLocationModel *StartPointModel = [[RunLocationModel alloc] init];
            StartPointModel.location = location.coordinate;
            StartPointModel.speed = location.speed;
            StartPointModel.time = location.timestamp;
            [self.locationArray addObject:StartPointModel];//向位置数组里面添加第一个定位点
            [self.drawLineArray addObject:StartPointModel];//向绘制轨迹点的数组里添加第一个定位点

            [self drawStartRunPointAction:StartPointModel];
            self.isFirstLocation = NO;
            self.isEndLocation = NO;
        }else if (self.locationArray.count != 0) {
                RunLocationModel *LastlocationModel = self.locationArray.lastObject;

            //当前定位的位置信息model
            RunLocationModel *currentModel = [[RunLocationModel alloc] init];
            currentModel.location = location.coordinate;
            currentModel.time = location.timestamp;
            currentModel.speed = location.speed;
            double meters = [self distanceWithLocation:LastlocationModel andLastButOneModel:currentModel];
            self.locationModel = currentModel;
            [self.locationArray addObject:self.locationModel]; //向位置数组里添加跑步过程中每次定位的定位点
            double KMeters = meters/1000;
            self.distance = self.distance + KMeters;
            self.Mainview.numberLabel.text = @"0";
            self.Mainview.numberLabel.text = [NSString stringWithFormat:@"%.02f",self.distance];


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
            }
        }
//    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if (self.locationArray.count == 0) {
        self.locationModel = [[RunLocationModel alloc] init];
        CLLocation *location = [locations firstObject];
        self.locationModel.LOCATION = location;
        self.locationModel.location = location.coordinate;
        [self.locationArray addObject:self.locationModel];
    }else if (self.locationArray.count != 0){
        RunLocationModel *locationModel = self.locationArray.lastObject;
        RunLocationModel *currentModel = [[RunLocationModel alloc] init];
        currentModel.LOCATION = [locations firstObject];
        
        
    }
}
    //计算距离
-(CLLocationDistance )distanceWithLocation:(RunLocationModel *)lastModel andLastButOneModel:(RunLocationModel *)lastButOneModel{
    
//       double startLongitude = start.longitude;
//       double startLatitude = start.latitude;
//       double endLongitude = end.longitude;
//       double endLatitude = end.latitude;
//
//       double radLatitude1 = startLatitude * M_PI / 180.0;
//       double radLatitude2 = endLatitude * M_PI / 180.0;
//       double a = fabs(radLatitude1 - radLatitude2);
//       double b = fabs(startLongitude * M_PI / 180.0 - endLongitude * M_PI / 180.0);
//
//       double s = 2 * asin(sqrt(pow(sin(a/2),2) + cos(radLatitude1) * cos(radLatitude2) * pow(sin(b/2),2)));
//       s = s * 6378137;
//
//       meter = round(s * 10000) / 10000;
    CLLocationDistance Meters = 0;
    MAMapPoint point1 = MAMapPointForCoordinate(lastModel.location);
       MAMapPoint point2 = MAMapPointForCoordinate(lastButOneModel.location);
       //2.计算距离
       CLLocationDistance newdistance = MAMetersBetweenMapPoints(point1,point2);
       
       //估算两者之间的时间差,单位 秒
       NSTimeInterval secondsBetweenDates= [lastModel.time timeIntervalSinceDate:lastButOneModel.time];
         //世界飞人9.97秒百米,当超过这个速度,即为误差值
    if ((float)newdistance/secondsBetweenDates <= 9.97) {
        Meters = newdistance;
    }
        return Meters;
}

#pragma mark- 绘制定位大头针
//绘制开始位置大头针
- (void)drawStartRunPointAction:(RunLocationModel *)startLocationModel{
    if (self.isFirstLocation && self.Mainview.mapView.userLocation.location != nil) {
        MAPointAnnotation *startPointAnnotation = [[MAPointAnnotation alloc] init];
        startPointAnnotation.coordinate = startLocationModel.location;
    }
}

//绘制结束位置大头针
- (void)drawEndRunPointAction:(RunLocationModel *)endLocationModel{
    if (!self.isFirstLocation && self.isEndLocation &&self.Mainview.mapView.userLocation.location != nil) {
        MAPointAnnotation *endPointAnnotation = [[MAPointAnnotation alloc] init];
        endPointAnnotation.coordinate = endLocationModel.location;
    }
}
    //自定义大头针
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{

//    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
//        if (self.isFirstLocation && !self.isEndLocation) {
//            static NSString *startPointAnnotation = @"startPointAnnotation";
//                        MAAnnotationView *startAnnotation = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:startPointAnnotation];
//                        if (startAnnotation == nil) {
//                            startAnnotation = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:startPointAnnotation];
//                        }
//                         startAnnotation.image = [UIImage imageNamed:@"startPointImage"];
//            //            startAnnotation.calloutOffset = CGPointMake(0, -20);
//                        return startAnnotation;
//        }else if (!self.isFirstLocation && self.isEndLocation){
//            static NSString *endPointAnnotation = @"endPointAnnotation";
//            MAAnnotationView *endAnnotation = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:endPointAnnotation];
//            if (endAnnotation == nil) {
//                endAnnotation = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:endPointAnnotation];
//            }
//            endAnnotation.image = [UIImage imageNamed:@"endPointImage"];
//            return endAnnotation;
//        }
//    }
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
//        polyLineRender.strokeImage = [UIImage imageNamed:@"运动轨迹"];
        polyLineRender.strokeColor = [UIColor colorWithRed:123/255.0 green:183/255.0 blue:196/255.0 alpha:1.0]; //折线颜色
        
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
    
    
    //按钮的变化
    self.Mainview.pauseBtn.hidden = YES;
    self.Mainview.lockBtn.hidden = YES;
    self.Mainview.unlockLongPressView.hidden = YES;
    
    self.Mainview.endLongPressView.hidden = NO;
    self.Mainview.continueBtn.hidden = NO;
}

//点击锁屏按钮方法
- (void)lockMethod{
//    self.Mainview.mapView.userInteractionEnabled = NO;

    self.Mainview.topView.userInteractionEnabled = NO;
//    self.Mainview.bottomView.userInteractionEnabled = NO;
//    self.Mainview.unlockLongPressView.userInteractionEnabled = YES;
    
    
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
//点击继续按钮方法
- (void)continueMethod{
    //计时器继续
    [self.runTimer setFireDate:[NSDate distantPast]];
    
    
    //按钮的变换
    self.Mainview.unlockLongPressView.hidden = YES;
    self.Mainview.endLongPressView.hidden = YES;
    self.Mainview.continueBtn.hidden = YES;
    
    self.Mainview.pauseBtn.hidden = NO;
    self.Mainview.lockBtn.hidden = NO;
    
}

//长按结束按钮方法
- (void)endMethod{
    //计时器停止
//    [self.runTimer setFireDate:[NSDate distantFuture]];
    //弹出提示框
    if (self.second < 60 || self.distance < 100) {
        SZHAlertView *shortAlert = [[SZHAlertView alloc] initWithTitle:@"本次跑步距离过短，无法保存记录，确定结束吗？"];
        [self.view addSubview:shortAlert];
        [shortAlert mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(screenHeigth *0.335);
//            make.left.equalTo(self.view.mas_left).offset(screenWidth *0.0907);
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(306, 200));
        }];
        [shortAlert.endBtn addTarget:self action:@selector(shortEndRun) forControlEvents:UIControlEventTouchUpInside];
        [shortAlert.ContinueRunBtn addTarget:self action:@selector(continueRun1) forControlEvents:UIControlEventTouchUpInside];
        self.shortAlert = shortAlert;
    }else{
        SZHAlertView *endAlert = [[SZHAlertView alloc] initWithTitle:@"您确定要结束跑步吗？"];
        [self.view addSubview:endAlert];
        [endAlert mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(screenHeigth *0.335);
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(306, 200));
        }];
        [endAlert.endBtn addTarget:self action:@selector(endRun) forControlEvents:UIControlEventTouchUpInside];
        [endAlert.ContinueRunBtn addTarget:self action:@selector(continueRun2) forControlEvents:UIControlEventTouchUpInside];
        self.normalAlert = endAlert;

    }
    
    
    
   
}

//距离过短时的按钮
    //结束
- (void)shortEndRun{
    //跳转到下一个页面
    self.sportsState = SportsStateStop; //切换运动状态至停止跑步状态
    MGDDataViewController *overVC = [[MGDDataViewController alloc] init];
    //属性传值
    overVC.distanceStr = self.Mainview.numberLabel.text; //跑步距离
    overVC.speedStr = self.Mainview.speedNumberLbl.text; //配速
    /*
      步频还没弄出来，暂时闲置
     */
    overVC.timeStr = self.timeString; //时间
    overVC.energyStr = self.Mainview.energyNumberLbl.text; //千卡
    overVC.drawLineAry = self.drawLineArray;
    overVC.locationAry = self.locationArray;
       self.hidesBottomBarWhenPushed = YES;
       [self.navigationController pushViewController:overVC animated:YES];
}

- (void)continueRun1{
    [self.shortAlert removeFromSuperview];
}

//正常结束
    //结束
- (void)endRun{
    //跳转到下一个页面
    self.sportsState = SportsStateStop; //切换运动状态至停止跑步状态
    MGDDataViewController *overVC = [[MGDDataViewController alloc] init];
    //属性传值
    overVC.distanceStr = self.Mainview.numberLabel.text; //跑步距离
    overVC.speedStr = self.Mainview.speedNumberLbl.text; //配速
    /*
      步频还没弄出来，暂时闲置
     */
    overVC.timeStr = self.timeString; //时间
    overVC.energyStr = self.Mainview.energyNumberLbl.text; //千卡
    overVC.drawLineAry = self.drawLineArray;
    overVC.locationAry = self.locationArray;

       self.hidesBottomBarWhenPushed = YES;
       [self.navigationController pushViewController:overVC animated:YES];
}
    //继续跑步
- (void)continueRun2{
    [self.normalAlert removeFromSuperview];
}
@end
