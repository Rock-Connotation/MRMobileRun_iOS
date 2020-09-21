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
#import <AMapSearchKit/AMapSearchKit.h>  //搜索库，为获取天气

#import "ZYLMainViewController.h" //首页
#import "ZYLRunningViewController.h"
#import "MRTabBarController.h"
#import "MGDDataViewController.h"
#import "RunLocationModel.h"
#import "MASmoothPathTool.h"
#import "UIImageView+WebCache.h"
#import "SZHChart.h"//速度图表的View
#import "SZHWaveChart.h"//步频的波浪图
#import "MGDTabBarViewController.h"

@interface MGDDataViewController () <UIGestureRecognizerDelegate,MAMapViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate,UITraitEnvironment>
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
     self.tabBarController.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];//隐藏导航栏
    
    [self fit];
    self.overView.mapView.delegate = self;
    self.overView.mapView.showsUserLocation = NO;
    self.overView.mapView.userInteractionEnabled = YES;
    [self initLocationManager];
/*
绘制轨迹
    */
    //初始化原始数据数组和处理后的数组
    self.origTracePoints = [NSArray array];
    [self loadTrancePoints];
    [self initSmoothedTrace];
   
   //绘制始终位置大头针
    [self initBeginAndEndAnnotations];
    
    // 给分享界面添加手势
    UITapGestureRecognizer *backGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backevent:)];
    backGesture.delegate = self;
    [self.shareView.backView addGestureRecognizer:backGesture];
    
    //设置地图中心点
    RunLocationModel *model3 = self.locationAry.lastObject;
    CLLocationCoordinate2D centerCoordinate = model3.location;
    [self.overView.mapView setCenterCoordinate:centerCoordinate ];
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
           
           _dataView = [[MGDDataView alloc] initWithFrame:CGRectMake(0, screenHeigth - 100 + 10, screenWidth, 710 + 35)];
       }else {
           _backScrollView.frame = CGRectMake(0, 0, screenWidth, screenHeigth - 66);
           
            _twoBtnView = [[MGDButtonsView alloc] initWithFrame:CGRectMake(0, screenHeigth - 66, screenWidth, 66)];
           
           _dataView = [[MGDDataView alloc] initWithFrame:CGRectMake(0, screenHeigth - 66 + 50, screenWidth, 710 + 35)];

       }
       
       //两个butto的View
       [_twoBtnView.overBtn addTarget:self action:@selector(backRootCV) forControlEvents:UIControlEventTouchUpInside];
       [_twoBtnView.shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
       [self.view addSubview:_twoBtnView];
       if (kIs_iPhoneX) {
           _backScrollView.contentSize = CGSizeMake(screenWidth, 1432 + 100);
       }else {
           _backScrollView.contentSize = CGSizeMake(screenWidth, screenHeigth + 667);
       }
       [self.view addSubview:_backScrollView];
       
       //地图下，统计图上的View，配速、时间、燃烧千卡等label的数据
    if (@available(iOS 12.0, *)) {
        _overView = [[MGDOverView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeigth)];
    } else {
        // Fallback on earlier versions
    }
       [self.backScrollView addSubview:_overView];
       self.overView.mapView.delegate = self;
       /*
        步频、速度两个图表
        */
        [self addTwoCharts];
        
        //绘制统计图的View
       [self.backScrollView addSubview:_dataView];
    
    
    
    //赋值
        //温度赋值
    if (self.temperature != nil) {
        self.overView.degree.text = [NSString stringWithFormat:@"%@°C",self.temperature];
    }
    self.overView.kmLab.text = self.distanceStr; //跑步距离赋值
    self.overView.speedLab.text = self.speedStr; //配速赋值
    if (self.averageStepFrequency >0 && self.averageStepFrequency < 300) {
        self.overView.paceLab.text = [NSString stringWithFormat:@"%d",self.averageStepFrequency]; //平均步频赋值
        
    }
        //天气框图片
    if ([self.weather isEqualToString:@"雷阵雨"]) {
        self.overView.weatherImagview.image = [UIImage imageNamed:@"雷阵雨白"];
    }else if ([self.weather isEqualToString:@"晴"]){
        self.overView.weatherImagview.image = [UIImage imageNamed:@"晴白"];
    }else if ([self.weather isEqualToString:@"雪"]){
        self.overView.weatherImagview.image = [UIImage imageNamed:@"雪白"];
    }else if ([self.weather isEqualToString:@"阴"] || [self.weather isEqualToString:@"多云"]){
        self.overView.weatherImagview.image = [UIImage imageNamed:@"阴天白"];
    }else if([self.weather isEqualToString:@"雨"]){
        self.overView.weatherImagview.image = [UIImage imageNamed:@"雨白"];
    }
    _overView.timeLab.text = self.timeStr;   //跑步时间赋值
    self.overView.calLab.text = self.energyStr; //燃烧千卡赋值
    self.dataView.paceLab.text = [NSString stringWithFormat:@"%d",self.maxStepFrequencyLastest];   //最大步频
    self.dataView.speedLab.text = [NSString stringWithFormat:@"%.02f",self.maxSpeedLastest]; //最大速度
    
}

//添加两个图表
- (void)addTwoCharts{
    //画步频的波浪图
    if (self.cacultedStepsAry.count != 0) {
        //步频的波浪图
//        NSArray *paceArray = @[@130,@140,@152,@180,@200,@148,@132,@98];
        SZHWaveChart *paceWaveChart = [[SZHWaveChart alloc] init];
        [paceWaveChart initWithViewsWithBooTomCount:self.cacultedStepsAry.count AndLineDataAry:self.cacultedStepsAry AndYMaxNumber:250];
//        [paceWaveChart initWithViewsWithBooTomCount:paceArray.count AndLineDataAry:paceArray AndYMaxNumber:250];
        
        [self.dataView.paceBackView addSubview:paceWaveChart];
        [paceWaveChart mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.dataView.paceBackView);
            make.height.mas_equalTo(245);
        }];
        paceWaveChart.topYlabel.text = @"步/分";
        paceWaveChart.bottomXLabel.text = @"分钟";
        for (int i = 0; i < paceWaveChart.leftLblAry.count; i++) {
            UILabel *label = paceWaveChart.leftLblAry[i];
            label.text = [NSString stringWithFormat:@"%d",(i+1) * 50];
        }
    }
    
    //处理画速度的折线图
  
    NSLog(@"在跑步结束页绘制的速度数组为%@",self.caculatedSpeedAry);
//    NSArray *array = @[@5,@3,@4.3,@3.2,@3.8,@5.2];
    if (self.caculatedSpeedAry.count != 0) {
        //速度的折线图
        SZHChart *speedChart = [[SZHChart alloc] init];
        [speedChart initWithViewsWithBooTomCount:(int)self.caculatedSpeedAry.count AndLineDataAry:self.caculatedSpeedAry AndYMaxNumber:6];
//    [speedChart initWithViewsWithBooTomCount:array.count AndLineDataAry:array AndYMaxNumber:6];
        [self.dataView.speedBackView addSubview:speedChart];
        [speedChart mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.dataView.speedBackView);
            make.height.mas_equalTo(245);
        }];
        speedChart.topYlabel.text = @"米/秒";
        speedChart.bottomXLabel.text = @"分钟";
        for (int i = 0; i < speedChart.leftLblAry.count; i++) {
            UILabel *label = speedChart.leftLblAry[i];
            label.text = [NSString stringWithFormat:@"%d", i + 2];
        }
    }
}

//跳转到首页界面
- (void)backRootCV {
    MGDTabBarViewController *cv = [[MGDTabBarViewController alloc] init];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController pushViewController:cv animated:YES];
}

- (void)share {
    _shareView = [[MGDShareView alloc] initWithShotImage:@"" logoImage:@"" QRcodeImage:@""];
    [self.view addSubview:_shareView];
    [_shareView.cancelBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    //分享界面下五个按钮的方法
    [self shareAction];
    
   // 分享界面的地图截图
//    CGRect inRect = self.overView.mapView.frame;

    CGRect inRect = self.shareView.popView.frame;
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
    // 延迟执行取消定位操作
     __weak typeof(self) weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf.ALocationManager stopUpdatingLocation];
    });
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
            [muteableAry addObject:point];
        }
        self.origTracePoints = muteableAry;
    NSLog(@"原始轨迹数据测绘点个数为%lu",(unsigned long)self.origTracePoints.count);
}

//处理、绘制轨迹线
- (void)initSmoothedTrace{
    MASmoothPathTool *tool = [[MASmoothPathTool alloc] init];
    tool.intensity = 3;
    tool.threshHold = 0.3;
    tool.noiseThreshhold = 10;
    self.smoothedTracePoints = [tool pathOptimize:self.origTracePoints];
    NSLog(@"处理后的轨迹绘制数据点%lu",(unsigned long)self.smoothedTracePoints.count);
    CLLocationCoordinate2D *pCoords = malloc(sizeof(CLLocationCoordinate2D) * self.smoothedTracePoints.count);
    if(!pCoords) {
        return;
    }

    for(int i = 0; i < self.smoothedTracePoints.count; ++i) {
        MALonLatPoint *p = [self.smoothedTracePoints objectAtIndex:i];
        CLLocationCoordinate2D *pCur = pCoords + i;
//        CLLocationCoordinate2D *pCur = &pCoords[i];
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
       return polyLineRender;
      }
        return nil;
}

#pragma mark- 大头针相关
//设置开始，结束位置的大头针
- (void)initBeginAndEndAnnotations{
        //开始地点
        MAPointAnnotation *beginAnnotation = [[MAPointAnnotation alloc] init];
    //    RunLocationModel *beginLocation = self.locationAry.firstObject;
        MALonLatPoint *beginLocation = self.smoothedTracePoints.firstObject;
        beginAnnotation.coordinate = CLLocationCoordinate2DMake(beginLocation.lat, beginLocation.lon);
        self.beginAnnotataion = beginAnnotation;
        [self.overView.mapView addAnnotation:self.beginAnnotataion];
        
        //结束地点
        MAPointAnnotation *endAnnotation = [[MAPointAnnotation alloc] init];
    //    RunLocationModel *endLocation = self.locationAry.lastObject;
        MALonLatPoint *endLocation = self.smoothedTracePoints.lastObject;
        endAnnotation.coordinate = CLLocationCoordinate2DMake(endLocation.lat, endLocation.lon);
        self.endAnnotataion = endAnnotation;
        [self.overView.mapView addAnnotation:self.endAnnotataion];
}

//自定义大头针样式
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
   if ([annotation isKindOfClass:[MAPointAnnotation class]]){
       if (annotation == self.beginAnnotataion) {
           static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
           MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
           if (annotationView == nil){
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
           }
           annotationView.image = [UIImage imageNamed:@"startPointImage"];
           annotationView.animatesDrop = NO;         //设置标注动画显示，默认为NO
           annotationView.canShowCallout= NO;       //设置气泡可以弹出，默认为NO
           annotationView.draggable = NO;            //设置不可被拖动
           return annotationView;
       }else if (annotation == self.endAnnotataion){
         static NSString *end = @"end";
           MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:end];
           if (annotationView == nil){
                annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:end];
                }
           annotationView.image = [UIImage imageNamed:@"endPointImage"];
           annotationView.animatesDrop = NO;         //设置标注动画显示，默认为NO
           annotationView.canShowCallout= NO;       //设置气泡可以弹出，默认为NO
           annotationView.draggable = NO;            //设置不可被拖动
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

//持续定位
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
     CGFloat signal = location.horizontalAccuracy;
    if (signal < 0)
    {
        return ;
    }

    NSLog(@"逆地理编码为%@",reGeocode.citycode);
    [self.overView.mapView setCenterCoordinate:location.coordinate];
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
- (void)savePhotoAtLocalAlbum{
    CGRect inRect = self.overView.mapView.frame;
    [self.overView.mapView takeSnapshotInRect:inRect withCompletionBlock:^(UIImage *resultImage, NSInteger state) {
        state = 1;
        
    }];
}


#pragma mark-关于两个位置管理者的定位代理方法:实现后台定位

- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager *)locationManager{
    [locationManager requestAlwaysAuthorization];
}
- (void)mapViewRequireLocationAuth:(CLLocationManager *)locationManager{
    [locationManager requestAlwaysAuthorization];
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
                        NSString *path =   [[NSBundle mainBundle] pathForResource:@"style" ofType:@"data"];
                              NSData *data = [NSData dataWithContentsOfFile:path];
                               MAMapCustomStyleOptions *options = [[MAMapCustomStyleOptions alloc] init];
                               options.styleData = data;
                        [self.overView.mapView setCustomMapStyleOptions:options];
                        [self.overView.mapView setCustomMapStyleEnabled:YES];
                    } else if (mode == UIUserInterfaceStyleLight) {
                        NSLog(@"浅色模式");
                        NSString *path =   [[NSBundle mainBundle] pathForResource:@"style2" ofType:@"data"];
                           NSData *data = [NSData dataWithContentsOfFile:path];
                            MAMapCustomStyleOptions *options = [[MAMapCustomStyleOptions alloc] init];
                            options.styleData = data;
                        [self.overView.mapView setCustomMapStyleOptions:options];
                        [self.overView.mapView setCustomMapStyleEnabled:YES];
                    } else {
                        NSLog(@"未知模式");
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
@end
