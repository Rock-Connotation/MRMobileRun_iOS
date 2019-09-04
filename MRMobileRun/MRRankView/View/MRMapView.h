//
//  MRMapView.h
//  MobileRun
//
//  Created by 郑沛越 on 2017/2/25.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>//
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface MRMapView : UIView
- (instancetype)init;

@property (nonatomic,strong) MAMapView *mapView;
@property (nonatomic,strong) AMapLocationManager *locationManager;
@property (nonatomic,strong) MAUserLocationRepresentation *userLocation;


@end
