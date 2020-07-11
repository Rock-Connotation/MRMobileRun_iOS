//
//  RunMainPageCV.m
//  MRMobileRun
//
//  Created by 石子涵 on 2020/7/10.
//

#import "RunMainPageCV.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <Masonry.h>

#import "RunningMainPageView.h"
@interface RunMainPageCV ()<MAMapViewDelegate>
@property (nonatomic, strong) RunningMainPageView *Mainview;
@end

@implementation RunMainPageCV

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Mainview = [[RunningMainPageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.Mainview];
    [self.Mainview Init];
    self.Mainview.mapView.delegate = self;
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor redColor];
   
    
//    MAMapView *mapView = [[MAMapView alloc] init];
//    mapView.delegate = self;
//    mapView.mapType = MAMapTypeStandard;  //设置地图类型
//    //定位以后改变地图的图层显示
//    [mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
//    [self.view addSubview:mapView];
//    //设置地图位置：
//    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view);
//        make.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.view).offset(-10);
//    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
