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
@interface RunMainPageCV ()<MAMapViewDelegate,RunmodelDelegate,AMapLocationManagerDelegate>
@property (nonatomic, strong) RunningMainPageView *Mainview;
@property (nonatomic, strong) RunningModel *model;
@property (nonatomic, strong) RunLocationModel *locationModel;


@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, strong)MAAnnotationView *myAnnotationView;//我的当前位置的大头针
@property (nonatomic, strong)MAPolyline *polyline;//当前绘制的轨迹曲线

@property (nonatomic, strong)NSMutableArray <RunLocationModel *>*perfectArray;//优化完成的定位数据数组
@property (nonatomic, strong)NSMutableArray <RunLocationModel *>*drawLineArray;//待绘制定位线数据
@property (nonatomic, strong)NSMutableArray *locationArray;

@property (nonatomic, assign)int lastDrawIndex;//绘制最后数据的下标次数(perfectArray)
@property (nonatomic, assign)NSInteger locationNumber;//定位次数
@property (nonatomic, assign)BOOL isFirstLocation;//是否是第一次定位
@property (nonatomic, assign)BOOL isEndLocation; //是否是最后一次定位

@property (nonatomic, assign) CGFloat signal;
@end

@implementation RunMainPageCV


- (void)viewDidAppear:(BOOL)animated{
    self.sportsState = SportsStateStart;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.Mainview = [[RunningMainPageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.Mainview];
    [self.Mainview mainRunView];
    
    [self btnFunction];
    self.Mainview.mapView.delegate = self;
    
}

-(void)setModel:(RunningModel *)model{
    self.model = model;
    self.model.delegate = self;
    self.Mainview.numberLabel.text = model.distanceStr;
    self.Mainview.speedNumberLbl.text = model.speedStr;
    self.Mainview.energyNumberLbl.text = model.energyStr;
}
 
#pragma mark- 懒加载位置管理者
- (AMapLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
            _locationManager.delegate = self;
            _locationManager.distanceFilter = 10;//设置移动精度(单位:米)
            _locationManager.locationTimeout = 2;//定位时间
            _locationManager.allowsBackgroundLocationUpdates = YES;//开启后台定位
            [_locationManager setLocatingWithReGeocode:YES];
        }
        return _locationManager;
}

#pragma mark- 状态监听
- (void)setSportsState:(SportsState)sportsState{
    sportsState = self.sportsState;
    switch (sportsState) {
        case SportsStateIdle:{
            if (self.polyline != nil ) {
                [self.locationManager stopUpdatingLocation];
                [self.Mainview.mapView removeOverlay:self.polyline];
            }
            self.distance = 0;
            self.locationNumber = 0;
            self.isFirstLocation = YES;
            self.perfectArray = [NSMutableArray arrayWithCapacity:16];
            self.drawLineArray = [NSMutableArray arrayWithCapacity:16];
            break;
        }
        case SportsStateStart:{
            if (self.polyline != nil) {
                [self.Mainview.mapView removeOverlay:self.polyline];
            }
            self.distance = 0;
            self.locationNumber = 0;
            self.isFirstLocation = YES;
            self.locationModel = [[RunLocationModel alloc] init];
            self.locationArray = [NSMutableArray array];
            
            self.perfectArray = [NSMutableArray arrayWithCapacity:16];
            self.drawLineArray = [NSMutableArray arrayWithCapacity:16];
            [self.locationManager startUpdatingLocation];//开始持续定位
            
            /*
             是否使用陀螺仪（用经纬度计算距离，单纯用陀螺仪的计步来计算步频）
             */
            
        }
            
        case SportsStateRunning:
            
            return;
            
        case SportsStateStop:
            [self.locationManager stopUpdatingLocation];
            self.isEndLocation = YES;
            RunLocationModel *endLocationModel = self.locationArray.lastObject;
            [self drawEndRunPointAction:endLocationModel];
             
            break;
    }
}

#pragma mark-运动时间
-(void)time:(NSString *)timeStr timeNum:(int)time
{
    self.Mainview.timeNumberLbl.text = timeStr;
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
    //设置信号强度，小于80，大于0的时候进来
    if (self.signal < 80 && self.signal >0) {
#pragma mark- 一下关于位置点距离测算以及画轨迹与locationManager里面设置的方法重复，记得删除一个
        
        if (self.locationArray.count == 0) {
            self.isFirstLocation = YES;
            
            [self.Mainview.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
//            aMapPOIAroundSearchRequest.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
//            [_aMapSearchAPI AMapPOIAroundSearch:aMapPOIAroundSearchRequest];
//
                RunLocationModel *StartPointModel = [[RunLocationModel alloc] init];
                StartPointModel.location = userLocation.location.coordinate;
                StartPointModel.speed = userLocation.location.speed;
                StartPointModel.time = userLocation.location.timestamp;
                [self.locationArray addObject:StartPointModel]; //向位置数组里面添加第一个定位点
                [self.drawLineArray addObject:StartPointModel];     //向画轨迹的位置数组里添加第一个定位定
                [self drawStartRunPointAction:StartPointModel];
                self.isFirstLocation = NO;
                self.isEndLocation = NO;
        }if (self.locationArray.count != 0) {
                RunLocationModel *LastlocationModel = self.locationArray.lastObject;

            //当前定位的位置信息model
                RunLocationModel *currentModel = [[RunLocationModel alloc] init];
                currentModel.location = userLocation.location.coordinate;
                currentModel.time = userLocation.location.timestamp;
                currentModel.speed = userLocation.location.speed;
                double meters = [self distanceWithLocation:LastlocationModel andLastButOneModel:currentModel];
                self.locationModel = currentModel;
                [self.locationArray addObject:self.locationModel]; //向位置数组里添加跑步过程中每次定位的定位点
            
            //为了美化移动的轨迹，移动的位置超过10米，才添加进绘制轨迹的的数组
            if (meters > 10) {
                [self.drawLineArray addObject:self.locationModel]; //向位置数组里添加跑步过程中每次定位的定位点
            }
                double KMeters = meters/1000;
                self.distance = self.distance + KMeters;
            
            self.Mainview.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)self.distance];
        }
    }
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    if (self.signal < 80 && self.signal >0){
        if (self.locationArray.count == 0) {
            RunLocationModel *StartPointModel = [[RunLocationModel alloc] init];
            StartPointModel.location = location.coordinate;
            StartPointModel.speed = location.speed;
            StartPointModel.time = location.timestamp;
            [self.locationArray addObject:StartPointModel];         //向位置数组里面添加第一个定位点
            [self.drawLineArray addObject:StartPointModel];         //向绘制轨迹点的数组里添加第一个定位点
            
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
#pragma mark- 绘制轨迹
            //为了美化移动的轨迹，移动的位置超过10米，才添加进绘制轨迹的的数组
            if (meters > 10) {
                RunLocationModel *lineLastPointLocation = [[RunLocationModel alloc] init];
                //开始绘制轨迹
                CLLocationCoordinate2D linePoints[2];
                linePoints[0] = lineLastPointLocation.location;
                linePoints[1] = self.locationModel.location;
                //调用addOverlay方法后回进入 renderForOverlay 方法，完成对轨迹的绘制
                MAPolyline *lineSection  = [MAPolyline polylineWithCoordinates:linePoints count:2];
                [self.Mainview.mapView addOverlay:lineSection];
                [self.drawLineArray addObject:self.locationModel];
            }
                
        }
        
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
        
//        [self.perfectArray addObject:startLocationModel]; //为消除误差了的数组添加第一个元素
//         self.lastDrawIndex = 0;
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

    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        if (self.isFirstLocation && !self.isEndLocation) {
            static NSString *startPointAnnotation = @"startPointAnnotation";
                        MAAnnotationView *startAnnotation = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:startPointAnnotation];
                        if (startAnnotation == nil) {
                            startAnnotation = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:startPointAnnotation];
                        }
                         startAnnotation.image = [UIImage imageNamed:@"startPointImage"];
            //            startAnnotation.calloutOffset = CGPointMake(0, -20);
                        return startAnnotation;
        }else if (!self.isFirstLocation && self.isEndLocation){
            static NSString *endPointAnnotation = @"endPointAnnotation";
            MAAnnotationView *endAnnotation = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:endPointAnnotation];
            if (endAnnotation == nil) {
                endAnnotation = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:endPointAnnotation];
            }
            endAnnotation.image = [UIImage imageNamed:@"endPointImage"];
            return endAnnotation;
        }
    }
    //自定义userlocation的大头针
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
    
    
    
    self.Mainview.unlockLongPressView.hidden = YES;
    self.Mainview.endLongPressView.hidden = YES;
    self.Mainview.continueBtn.hidden = YES;
    
    self.Mainview.pauseBtn.hidden = NO;
    self.Mainview.lockBtn.hidden = NO;
    
}

//长按结束按钮方法
- (void)endMethod{
    self.sportsState = SportsStateStop; //切换运动状态至停止跑步状态
    MGDDataViewController *overVC = [[MGDDataViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:overVC animated:YES];
}


@end
