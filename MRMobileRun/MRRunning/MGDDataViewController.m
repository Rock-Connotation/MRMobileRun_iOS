//
//  MGDDataViewController.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/27.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MAMapKit/MAMapKit.h>
#import <MAMapKit/MAPointAnnotation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <Masonry.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <Photos/Photos.h>

#import "MGDDataViewController.h"
#import "RunLocationModel.h"
#import "MASmoothPathTool.h"
#import "UIImageView+WebCache.h"
@interface MGDDataViewController () <UIGestureRecognizerDelegate,MAMapViewDelegate,AMapLocationManagerDelegate>
@property (nonatomic, strong) AMapLocationManager *ALocationManager;
@property (nonatomic, strong) NSArray<MALonLatPoint*> *origTracePoints;     //原始轨迹测绘坐标点
@property (nonatomic, strong) NSArray<MALonLatPoint*> *smoothedTracePoints; //平滑处理用的轨迹数组点
@property (nonatomic, strong) MAPolyline *smoothedTrace;

//大头针
@property (nonatomic, strong) MAPointAnnotation *beginAnnotataion;
@property (nonatomic, strong) MAPointAnnotation *endAnnotataion;

@property __block UIImage *shareImage;
@end

@implementation MGDDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];    //隐藏导航栏
    [self fit];
    [self initLocationManager];
    
    self.overView.kmLab.text = self.distanceStr; //跑步距离赋值
    self.overView.speedLab.text = self.speedStr; //配速赋值
    /*
     步频未弄出来，暂时先空缺着
     */
       _overView.timeLab.text = self.timeStr;   //跑步时间赋值
    self.overView.calLab.text = self.energyStr; //燃烧千卡赋值
    self.overView.mapView.delegate = self;
    
/*
绘制轨迹
    */
    [self loadTrancePoints];
    [self initSmoothedTrace];
   
    /*
     自定义始终位置的大头针
     */
    //开始地点
    MAPointAnnotation *beginAnnotation = [[MAPointAnnotation alloc] init];
    RunLocationModel *beginLocation = self.locationAry.firstObject;
    beginAnnotation.coordinate = beginLocation.location;
    self.beginAnnotataion = beginAnnotation;
    [self.overView.mapView addAnnotation:self.beginAnnotataion];
    //结束地点
    MAPointAnnotation *endAnnotation = [[MAPointAnnotation alloc] init];
    RunLocationModel *endLocation = self.locationAry.lastObject;
    endAnnotation.coordinate = endLocation.location;
    self.endAnnotataion = endAnnotation;
    [self.overView.mapView addAnnotation:self.endAnnotataion];
    
    // 给分享界面添加手势
    UITapGestureRecognizer *backGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backevent:)];
    backGesture.delegate = self;
    [self.shareView.backView addGestureRecognizer:backGesture];
    
   
    
    
}
    //适配各个View的深色模式以及页面布局
- (void)fit{
    //适配深色模式
       _backScrollView = [[UIScrollView alloc] init];
       if (@available(iOS 11.0, *)) {
           self.view.backgroundColor = bottomColor;
           _backScrollView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
       } else {
           // Fallback on earlier versions
       }
       
       //根据机型进行控件布局
       if (kIs_iPhoneX) {
           _backScrollView.frame = CGRectMake(0, 0, screenWidth, screenHeigth - 100);
           _twoBtnView = [[MGDButtonsView alloc] initWithFrame:CGRectMake(0,  screenHeigth - 100, screenWidth, 100)];
           _dataView = [[MGDDataView alloc] initWithFrame:CGRectMake(0, screenHeigth - 100 + 10, screenWidth, 710)];
       }else {
           _backScrollView.frame = CGRectMake(0, 0, screenWidth, screenHeigth - 66);
            _twoBtnView = [[MGDButtonsView alloc] initWithFrame:CGRectMake(0, screenHeigth - 66, screenWidth, 66)];
           _dataView = [[MGDDataView alloc] initWithFrame:CGRectMake(0, screenHeigth - 66 + 10, screenWidth, 710)];

       }
       
       //两个butto的View
       [_twoBtnView.overBtn addTarget:self action:@selector(showData) forControlEvents:UIControlEventTouchUpInside];
       [_twoBtnView.shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
       [self.view addSubview:_twoBtnView];
       _backScrollView.contentSize = CGSizeMake(screenWidth, 1432);
       [self.view addSubview:_backScrollView];
       
       //地图下，统计图上的View，配速、时间、燃烧千卡等label的数据
       _overView = [[MGDOverView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeigth)];
       [self.backScrollView addSubview:_overView];
    
        //绘制统计图的View
       [self.backScrollView addSubview:_dataView];
}

- (void)showData {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)share {
    _shareView = [[MGDShareView alloc] initWithShotImage:@"" logoImage:@"" QRcodeImage:@""];
    [self.view addSubview:_shareView];
    [_shareView.cancelBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self shareAction];
   // 分享界面的地图截图
    CGRect inRect = self.overView.mapView.frame;
   [self.overView.mapView takeSnapshotInRect:inRect withCompletionBlock:^(UIImage *resultImage, NSInteger state) {
       state = 1;
       self.shareImage = resultImage;
    self.shareView.shotImage.image = self.shareImage;
    }];
}

- (void)backevent:(UIGestureRecognizer *)sender {
    NSLog(@"1111");
}


- (void)back {
    [UIView animateWithDuration:0.3 animations:^{
        [self.shareView removeFromSuperview];
    }];
}

#pragma mark- 位置管理者
- (void)initLocationManager{
    self.ALocationManager = [[AMapLocationManager alloc] init];
    self.ALocationManager.delegate = self;
    self.ALocationManager.allowsBackgroundLocationUpdates = YES; //开启后台定位
    self.ALocationManager.distanceFilter = 5; //设置移动精度
    self.ALocationManager.locationTimeout = 2; //定位超时时间
    [self.ALocationManager setLocatingWithReGeocode:YES];
    [self.ALocationManager startUpdatingLocation];
}

#pragma mark- 轨迹相关
 //因为CLLocationCoordinate2D为只读属性，无法用可变数组直接addobject储存，所以需要以下转化
- (void)loadTrancePoints{
    NSMutableArray *muteableAry = [NSMutableArray array];
    //    CLLocationCoordinate2D linePoints[self.drawLineAry.count];
        for (int i = 0; i < self.drawLineAry.count; i++) {
            RunLocationModel *lineLocationModel = self.drawLineAry[i];
    //        linePoints[i] = lineLocationModel.location;
            MALonLatPoint *point = [[MALonLatPoint alloc] init];
            point.lat = lineLocationModel.location.latitude;
            point.lon = lineLocationModel.location.longitude;
        }
        self.origTracePoints = muteableAry;
}

//处理、绘制轨迹线
- (void)initSmoothedTrace{
    MASmoothPathTool *tool = [[MASmoothPathTool alloc] init];
    tool.intensity = 3;
    tool.threshHold = 0.3;
    tool.noiseThreshhold = 10;
    self.smoothedTracePoints = [tool pathOptimize:self.origTracePoints];

    CLLocationCoordinate2D *pCoords = malloc(sizeof(CLLocationCoordinate2D) * self.smoothedTracePoints.count);
    if(!pCoords) {
        return;
    }

    for(int i = 0; i < self.smoothedTracePoints.count; ++i) {
        MALonLatPoint *p = [self.smoothedTracePoints objectAtIndex:i];
        CLLocationCoordinate2D *pCur = pCoords + i;
        pCur->latitude = p.lat;
        pCur->longitude = p.lon;
    }

    self.smoothedTrace = [MAPolyline polylineWithCoordinates:pCoords count:self.smoothedTracePoints.count];
    [self.overView.mapView addOverlay:self.smoothedTrace];
    if(pCoords) {
        free(pCoords);
    }
     
}

//自定义轨迹线
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
   if ([overlay isKindOfClass:[MAPolyline class]]) {
            MAPolylineRenderer *polyLineRender = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
            polyLineRender.lineWidth = 8;
            polyLineRender.strokeColor = [UIColor colorWithRed:123/255.0 green:183/255.0 blue:196/255.0 alpha:1.0]; //折线颜色
      }
        return nil;
}

#pragma mark- 自定义大头针
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
   if ([annotation isKindOfClass:[MAPointAnnotation class]]){
       if (annotation == self.beginAnnotataion) {
           MAPinAnnotationView *annotationView = [[MAPinAnnotationView alloc] init];
           annotationView.image = [UIImage imageNamed:@"startPointImage"];
           annotationView.animatesDrop = NO;
           return annotationView;
       }else if (annotation == self.endAnnotataion){
           MAPinAnnotationView *annotationView = [[MAPinAnnotationView alloc] init];
           annotationView.image = [UIImage imageNamed:@"endPointImage"];
           annotationView.animatesDrop = NO;
           return annotationView;
       }
    }
         return nil;
}

#pragma mark- 定位回调方法
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
     CGFloat signal = userLocation.location.horizontalAccuracy;
    
       if(!updatingLocation)
           return ;

       if (signal < 0)
       {
           return ;
       }
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
     CGFloat signal = location.horizontalAccuracy;
    if (signal < 0)
    {
        return ;
    }
}

#pragma mark- 分享的五个按钮的方法
- (void)shareAction{
    for (int i = 0; i < self.shareView.bootomBtns.count; i++) {
        UIButton *btn = [self.shareView.bootomBtns objectAtIndex:i];
        switch (btn.tag) {
            case 1:
                [btn addTarget:self action:@selector(savePhotoAtLocalAlbum) forControlEvents:UIControlEventTouchUpInside];
                break;
                
            default:
                break;
        }
    }
}

//保存截图到本地
//- (void)savePhotoAtLocalAlbum{
//    CGRect inRect = self.overView.mapView.frame;
//    [self.overView.mapView takeSnapshotInRect:inRect withCompletionBlock:^(UIImage *resultImage, NSInteger state) {
//        state = 1;
//        UIImageWriteToSavedPhotosAlbum(resultImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
//    }];
//}
//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
//    NSLog(@"保存成功");
//}

#pragma mark-关于两个位置管理者的定位代理方法:实现后台定位

- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager *)locationManager{
    [locationManager requestAlwaysAuthorization];
}
- (void)mapViewRequireLocationAuth:(CLLocationManager *)locationManager{
    [locationManager requestAlwaysAuthorization];
}
@end
