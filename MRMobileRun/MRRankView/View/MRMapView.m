
//
//  MRMapView.m
//  MobileRun
//
//  Created by 郑沛越 on 2017/2/25.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "MRMapView.h"
#import "MAsonry.h"
@implementation MRMapView

- (instancetype)init{
    if (self = [super init]) {
        [self initMap];
        return self;
    }
    return self;
}

- (void)initMap{
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
    
    [AMapServices sharedServices].apiKey = @"7a2ab70eed477524c3e390081556a3fd";
    
    
    
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeigth)];
    
    
    

    self.mapView.userTrackingMode = MAUserTrackingModeFollow;

    self.mapView.showsUserLocation = YES;
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    
    [self.locationManager startUpdatingLocation];
    
    self.locationManager.distanceFilter = 4;
    
    [self.mapView setZoomLevel:17.58 animated:NO];
    //设置缩放级别
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
    
    //    _mapView.pausesLocationUpdatesAutomatically = NO;
    
    //    _mapView.allowsBackgroundLocationUpdates = YES;
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];//iOS9(含)以上系统需设置
    
    //开始持续定位
    [self.locationManager startUpdatingLocation];
    
    self.userLocation = [[MAUserLocationRepresentation alloc] init];
    
    self.userLocation.showsAccuracyRing = NO;
    //不显示精度圈
    self.userLocation.image = [UIImage imageNamed: @"结束按钮"];
    //设置定位点图标
    [self.mapView updateUserLocationRepresentation:self.userLocation];

    

    
//    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(0/1334.0*screenHeigth, 0/750.0*screenWidth, 0/1334.0*screenHeigth, 0/750.0*screenWidth));
//        
//    }];
}


@end
