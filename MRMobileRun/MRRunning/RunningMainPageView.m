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
@implementation RunningMainPageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)Init{

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
}
@end
