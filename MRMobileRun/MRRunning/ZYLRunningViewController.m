//
//  ZYLRunningViewController.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/5/2.
//

/*
 *定位不是很准
 *后面再改个sdk
 */

#import "ZYLRunningViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <Masonry.h>
#import <MGJRouter.h>
#import "ZYLTimeStamp.h"
#import "ZYLSteps.h"
#import "ZYLUptateRunningData.h"
#import "ZYLRunningTabView.h"
#import "ZYLRunningRecordView.h"
#import "MRAlertView.h"
#import "ZYLBackBtn.h"
#import "ZYLRecordTimeString.h"
//#import "ZYLPolling.h"
#import "ZYLUpdateData.h"

@interface ZYLRunningViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray *locationArray;
@property (strong, nonatomic) NSString *beginTime;
@property (strong, nonatomic) NSString *endTime;
@property (nonatomic, weak) NSTimer *runTime;
@property (strong, nonatomic) ZYLSteps *zylSteps;
@property (strong, nonatomic) ZYLRunningTabView *runTabView;
@property (strong, nonatomic) ZYLRunningRecordView *recordView;
@property (strong, nonatomic) MRAlertView *alertView;
@property (assign, nonatomic) double distance;
@property (copy, nonatomic) NSNumber *steps;
@property (nonatomic) int hour;
@property (nonatomic) int minute;
@property (nonatomic) int second;
@end

@implementation ZYLRunningViewController

- (void)viewWillAppear:(BOOL)animated{
    self.title = @"开始跑步";
    [self.navigationController setNavigationBarHidden:NO];
    
    ZYLBackBtn *backBtn = [[ZYLBackBtn alloc] init];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem =[[UIBarButtonItem alloc] initWithCustomView: backBtn];
    self.navigationItem.leftBarButtonItem = barItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.beginTime = [ZYLTimeStamp getTimeStamp];
//    [ZYLUptateRunningData ZYLPostUninviteRunningDataWithDataString: ];
    self.distance = 0;
    self.locationArray = [NSMutableArray array];
    self.runTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
    self.second = self.minute = self.hour = 0;

    
    [self.view addSubview: self.mapView];
    [self.view addSubview: self.runTabView];
    [self.view addSubview: self.recordView];
    [self loadConstrains];
    
    self.manager = [[CLLocationManager alloc] init];
    [self.manager requestAlwaysAuthorization];
    self.manager.delegate= self;
    self.manager.distanceFilter = 10;
    self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self.manager startUpdatingLocation];
}

//加载约束
- (void)loadConstrains{
    if (kIs_iPhoneX) {
        [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.height.equalTo(self.view.mas_height).mas_offset(-160);
            make.width.equalTo(self.view.mas_width);
        }];
        
        [self.runTabView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mapView.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.height.mas_equalTo(160);
            make.width.equalTo(self.view.mas_width);
        }];
        
        [self.recordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).mas_offset(120);
            make.left.equalTo(self.view.mas_left).mas_offset(20);
            make.height.mas_equalTo(120);
            make.width.equalTo(self.view.mas_width).mas_offset(-40);
        }];
    }else{
        [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.height.equalTo(self.view.mas_height).mas_offset(-130);
            make.width.equalTo(self.view.mas_width);
        }];
        
        [self.runTabView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mapView.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.height.mas_equalTo(130);
            make.width.equalTo(self.view.mas_width);
        }];
        
        [self.recordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).mas_offset(85);
            make.left.equalTo(self.view.mas_left).mas_offset(20);
            make.height.mas_equalTo(100);
            make.width.equalTo(self.view.mas_width).mas_offset(-40);
        }];
    }
}

- (void)startTimer{
    if ([self.runTabView.pauseAndResumeBtu.titleLabel.text isEqualToString:@"暂停" ]) {
        
        self.second ++;
        
        if (self.second == 86400) {
            self.second = 0;
        }
        NSLog(@"%d",self.second);
        
    }
    
    NSString *timeString = [ZYLRecordTimeString getTimeStringWithSecond:self.second];
    //获取跑步时间
    self.recordView.runningTimeLabel.text = timeString;
    [self.recordView.runningDiastanceLabel setFontWithSize:49 andFloatTitle:self.distance/1000.0];
    
}

#pragma mark - MKMapViewDelegate
/**
 更新用户位置，只要用户改变则调用此方法（包括第一次定位到用户位置）
 第一种画轨迹的方法:我们使用在地图上的变化来描绘轨迹,这种方式不用考虑从 CLLocationManager 取出的经纬度在 mapView 上显示有偏差的问题
 */
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    NSString *latitude = [NSString stringWithFormat:@"%3.6f",userLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%3.6f",userLocation.coordinate.longitude];
//    NSLog(@"更新的用户位置:纬度:%@, 经度:%@",latitude,longitude);
    //设置地图显示范围(如果不进行区域设置会自动显示区域范围并指定当前用户位置为地图中心点)
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region  =MKCoordinateRegionMake(userLocation.location.coordinate, span);
    [_mapView setRegion:region animated:true];
    
    if (self.locationArray.count != 0) {
        
        //从位置数组中取出最新的位置数据
        NSDictionary *dic = self.locationArray.lastObject;
        NSString *latitudeStr = dic[@"latitude"];
        NSString *longitudeStr = dic[@"longitude"];
        CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake([latitudeStr doubleValue], [longitudeStr doubleValue]);
        
        //当前确定到的位置数据
        CLLocationCoordinate2D endCoordinate;
        endCoordinate.latitude = userLocation.coordinate.latitude;
        endCoordinate.longitude = userLocation.coordinate.longitude;
        
        //移动距离的计算
        double meters = [self calculateDistanceWithStart:startCoordinate end:endCoordinate];
        self.distance += meters;
        NSLog(@"移动的距离为%f米",meters);
        
        //为了美化移动的轨迹,移动的位置超过10米,方可添加进位置的数组
        if (meters >= 10){
            
//            NSLog(@"添加进位置数组");
            NSDictionary *dic = @{@"latitude": latitude, @"longitude": longitude};
            [self.locationArray addObject: dic];
            
            //开始绘制轨迹
            CLLocationCoordinate2D pointsToUse[2];
            pointsToUse[0] = startCoordinate;
            pointsToUse[1] = endCoordinate;
            //调用 addOverlay 方法后,会进入 rendererForOverlay 方法,完成轨迹的绘制
            MKPolyline *lineOne = [MKPolyline polylineWithCoordinates:pointsToUse count:2];
            [_mapView addOverlay:lineOne];
            
        }else{
            
//            NSLog(@"不添加进位置数组");
        }
    }else{
        NSDictionary *dic = @{@"latitude": latitude, @"longitude": longitude};
        [self.locationArray addObject: dic];
        //存放位置的数组,如果数组包含的对象个数为0,那么说明是第一次进入,将当前的位置添加到位置数组
    }
}


-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    if ([overlay isKindOfClass:[MKPolyline class]]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        MKPolylineView *polyLineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        polyLineView.lineWidth = 10; //折线宽度
        polyLineView.lineJoin = kCGLineJoinBevel;//连接类型
        polyLineView.strokeColor = [UIColor blueColor]; //折线颜色
        return (MKOverlayRenderer *)polyLineView;
#pragma clang diagnostic pop
    }
    return nil;
}


#pragma mark - CLLocationManagerDelegate
/**
 *  当前定位授权状态发生改变时调用
 *
 *  @param manager 位置管理者
 *  @param status  授权的状态
 */
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:{
            NSLog(@"用户还未进行授权");
            break;
        }
        case kCLAuthorizationStatusDenied:{
            // 判断当前设备是否支持定位和定位服务是否开启
            if([CLLocationManager locationServicesEnabled]){
                
                NSLog(@"用户不允许程序访问位置信息或者手动关闭了位置信息的访问，帮助跳转到设置界面");
                
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL: url];
                }
            }else{
                NSLog(@"定位服务关闭,弹出系统的提示框,点击设置可以跳转到定位服务界面进行定位服务的开启");
            }
            break;
        }
        case kCLAuthorizationStatusRestricted:{
            NSLog(@"受限制的");
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:{
            NSLog(@"授权允许在前台和后台均可使用定位服务");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:{
            NSLog(@"授权允许在前台可使用定位服务");
            break;
        }
            
        default:
            break;
    }
}
/**
 我们并没有把从 CLLocationManager 取出来的经纬度放到 mapView 上显示
 原因:
 我们在此方法中取到的经纬度依据的标准是地球坐标,但是国内的地图显示按照的标准是火星坐标
 MKMapView 不用在做任何的处理,是因为 MKMapView 是已经经过处理的
 也就导致此方法中获取的坐标在 mapView 上显示是有偏差的
 解决的办法有很多种,可以上网就行查询,这里就不再多做赘述
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
     //设备的当前位置
    CLLocation *currLocation = [locations lastObject];

    NSString *latitude = [NSString stringWithFormat:@"纬度:%3.5f",currLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"经度:%3.5f",currLocation.coordinate.longitude];
    NSString *altitude = [NSString stringWithFormat:@"高度值:%3.5f",currLocation.altitude];

    NSLog(@"位置发生改变:纬度:%@,经度:%@,高度:%@",latitude,longitude,altitude);
    
    [manager stopUpdatingLocation];
}

//定位失败的回调方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"无法获取当前位置 error : %@",error.localizedDescription);
}


#pragma mark - 距离测算
- (double)calculateDistanceWithStart:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end {
    
    double meter = 0;
    
    double startLongitude = start.longitude;
    double startLatitude = start.latitude;
    double endLongitude = end.longitude;
    double endLatitude = end.latitude;
    
    double radLatitude1 = startLatitude * M_PI / 180.0;
    double radLatitude2 = endLatitude * M_PI / 180.0;
    double a = fabs(radLatitude1 - radLatitude2);
    double b = fabs(startLongitude * M_PI / 180.0 - endLongitude * M_PI / 180.0);
    
    double s = 2 * asin(sqrt(pow(sin(a/2),2) + cos(radLatitude1) * cos(radLatitude2) * pow(sin(b/2),2)));
    s = s * 6378137;
    
    meter = round(s * 10000) / 10000;
    return meter;
}
#pragma mark - button响应事件

//上传数据，返回首页
- (void)back{
    [MGJRouter openURL:kMainVCPageURL
          withUserInfo:@{@"navigationVC" : self.navigationController,
                         }
            completion:nil];
}

- (void)backAndUpdateData{
    [self updateRunningData];
    [self back];
}

- (void)stopRunning:(UIButton *)sender{
    [self.runTabView.pauseAndResumeBtu setTitle:@"暂停" forState:UIControlStateNormal];
    [self.runTabView.pauseAndResumeBtu setBackgroundImage:[UIImage imageNamed:@"暂停按钮"] forState:UIControlStateNormal];
    if ( self.distance <100 ||self.second <  60 ){
        self.alertView = [MRAlertView alertViewWithTitle:@"此次跑步路程过短哦，不能作为跑步记录保存，确定不跑了吗？" action:^{
            NSLog(@"哈哈哈哈哈");
            
        }];
        [self.alertView.okButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.alertView];
        
    }
    else{
        self.alertView = [MRAlertView alertViewWithTitle:@"确定结束此次跑步了吗？" action:^{
            NSLog(@"哈哈哈哈哈");
        }];
        [self.alertView.okButton addTarget:self action:@selector(backAndUpdateData) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.alertView];
    }

}

- (void) updateRunningData{
    self.zylSteps = [[ZYLSteps alloc] init];
    self.endTime = [ZYLTimeStamp getTimeStamp];
    self.steps = [self.zylSteps getStepsFromBeginTime:[ZYLTimeStamp getDateFromTimeStamp:self.beginTime] ToEndTime:[ZYLTimeStamp getDateFromTimeStamp:self.endTime]];
    dispatch_queue_t updateRunningQueue = dispatch_queue_create("com.mr.MRMobileRunDisoatchQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(updateRunningQueue, ^{
        NSString *dataStr = [ZYLUpdateData ZYLGetUpdateDataDictionaryWithBegintime: @([self.beginTime integerValue]) Endtime:@([self.endTime integerValue]) distance:[NSNumber numberWithDouble: self.distance]  lat_lng:self.locationArray andSteps: self.steps];
        
        [ZYLUptateRunningData ZYLPostUninviteRunningDataWithDataString: dataStr];
    });
}

#pragma mark - 懒加载
- (MKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MKMapView alloc] init];
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MKUserTrackingModeFollow;
        _mapView.delegate = self;
    }
    return _mapView;
}

- (ZYLRunningRecordView *)recordView{
    if (!_recordView) {
        _recordView = [[ZYLRunningRecordView alloc] init];
    }
    return _recordView;
}

- (ZYLRunningTabView *)runTabView{
    if (!_runTabView) {
        _runTabView = [[ZYLRunningTabView alloc] init];
        [_runTabView.stopBtu addTarget:self action:@selector(stopRunning:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _runTabView;
}
@end
