//
//  MGDCellDataViewController.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/8/13.
//

#import "MGDCellDataViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MAMapKit/MAMapKit.h>
#import <MAMapKit/MAPointAnnotation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <Masonry.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <Photos/Photos.h>
#import "UIImageView+WebCache.h"

#import "RunLocationModel.h"
#import "SZHWaveChart.h" //步频折线图
#import "SZHChart.h"//速度折线图
#import "MASmoothPathTool.h" //用来处理轨迹的工具类
#import "MGDDataViewController.h"
#import "RunLocationModel.h"
#import "MASmoothPathTool.h"
#import "UIImageView+WebCache.h"
#import "ZYLMainViewController.h"
#import "MRTabBarController.h"

@interface MGDCellDataViewController () <UIGestureRecognizerDelegate,MAMapViewDelegate,AMapLocationManagerDelegate,UITraitEnvironment>
@property (nonatomic, strong) AMapLocationManager *ALocationManager;
@property (nonatomic, strong) NSArray *origTracePoints;     //原始轨迹测绘坐标点
@property (nonatomic, strong) NSArray<MALonLatPoint*> *smoothedTracePoints; //平滑处理用的轨迹数组点
@property (nonatomic, strong) MAPolyline *smoothedTrace;

//大头针
@property (nonatomic, strong) MAPointAnnotation *beginAnnotataion;
@property (nonatomic, strong) MAPointAnnotation *endAnnotataion;

@property (nonatomic, strong) NSArray *originalSpeedAry; //原始的速度数组
@property (nonatomic, strong) NSArray *originalStepsAry; //原始的步频数组
@property (nonatomic, strong) NSArray *caculateSpeedAry; //处理后的速度数组
@property (nonatomic, strong) NSArray *caculateStepsAry; //处理后的步频数组
@property (nonatomic, strong) NSArray *originalLocationAry; //原始的位置数组

@property double maxSpeedLatest;
@property __block UIImage *shareImage;
@end

@implementation MGDCellDataViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];    //隐藏导航栏
    [self fit];
    [self initLocationManager];
    
    //关于一些初始化
    self.originalSpeedAry = [NSArray array];
    self.originalStepsAry = [NSArray array];
    self.caculateSpeedAry = [NSArray array];
    self.caculateStepsAry = [NSArray array];
    self.originalLocationAry = [NSArray array];
    self.maxSpeedLatest = 0;
    
    self.overView.kmLab.text = self.distanceStr; //跑步距离赋值
    self.overView.speedLab.text = self.speedStr; //配速赋值
    self.overView.timeLab.text = self.timeStr;   //跑步时间赋值
    self.overView.calLab.text = self.energyStr; //燃烧千卡赋值
    self.overView.paceLab.text = self.stepFrequencyStr; //步频
    self.overView.date.text = self.date; //日期
    self.overView.currentTime.text = self.time; //时间
    self.overView.degree.text = self.degree; //温度
    self.dataView.speedLab.text = self.MaxSpeed; //最大速度
    self.dataView.paceLab.text = self.MaxStepFrequency; //最大步频
    
    self.overView.mapView.delegate = self; //设置地图代理
    
    /**
     处理速度、步频、位置数组
     */
    [self separateString];
    
    /*
    步频、速度两个图表
    */
    [self addTwoCharts];
    
/*
绘制轨迹
    */
    //初始化原始数据数组和处理后的数组
    self.origTracePoints = [NSArray array];
//    self.smoothedTracePoints = [NSArray array];
    [self loadTrancePoints];
//    [self initSmoothedTrace];
    
    //绘制始终位置大头针
    [self initBeginAndEndAnnotations];
    
    // 给分享界面添加手势
    UITapGestureRecognizer *backGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backevent:)];
    backGesture.delegate = self;
    [self.shareView.backView addGestureRecognizer:backGesture];
    
    //设置地图中心
    RunLocationModel *model3 = self.originalLocationAry.lastObject;
    CLLocationCoordinate2D centerCL = model3.location;
    [self.overView.mapView setCenterCoordinate:centerCL];
    self.overView.mapView.zoomLevel = 15;
    self.overView.mapView.userInteractionEnabled = YES;
    
    //设置右滑返回的手势
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    panGesture.delegate = self; //设置手势代理，拦截手势触发
    [self.view addGestureRecognizer:panGesture];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO; //禁止系统自带的滑动手势
       
}

- (void)handleNavigationTransition:(UIPanGestureRecognizer *)pan {
    NSLog(@"右滑返回"); //自定义滑动手势
}

- (void)backevent:(UITapGestureRecognizer *)tap {
    NSLog(@"返回");
}



- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 当当前控制器是根控制器时，不可以侧滑返回，所以不能使其触发手势
    if(self.navigationController.childViewControllers.count == 1) {
        return NO;
    }
    return YES;
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
       [_twoBtnView.overBtn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
       [_twoBtnView.shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
       [self.view addSubview:_twoBtnView];
        
    if (kIs_iPhoneX) {
        _backScrollView.contentSize = CGSizeMake(screenWidth, screenHeigth + 610);
    }else {
        _backScrollView.contentSize = CGSizeMake(screenWidth, screenHeigth + 699);
    }
       [self.view addSubview:_backScrollView];
       
       //地图下，统计图上的View，配速、时间、燃烧千卡等label的数据
       _overView = [[MGDOverView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeigth)];
       [self.backScrollView addSubview:_overView];
       self.overView.mapView.delegate = self;
       
        //绘制统计图的View
       [self.backScrollView addSubview:_dataView];
    
    //更改地图的样式
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

//添加两个图表
- (void)addTwoCharts{
    //处理步频的数组
    NSMutableArray *stepsMuteAry = [NSMutableArray array];
    for (int i = 0; i < self.originalStepsAry.count; i += 4) {
        NSString *stepStr = self.originalStepsAry[i];
        [stepsMuteAry addObject:stepStr];
    }
    self.caculateStepsAry = stepsMuteAry;
    NSLog(@"处理后的步频数组为%@",self.caculateStepsAry);
    
    //画步频的波浪图
    if (self.caculateStepsAry.count != 0) {
        //步频的波浪图
        NSArray *paceArray = @[@130,@140,@152,@180,@200,@148,@132,@98];
        SZHWaveChart *paceWaveChart = [[SZHWaveChart alloc] init];
        [paceWaveChart initWithViewsWithBooTomCount:self.caculateStepsAry.count AndLineDataAry:self.caculateStepsAry AndYMaxNumber:250];
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
    NSMutableArray *speedMuteAry = [NSMutableArray array];
    for (int i = 0; i < self.originalSpeedAry.count; i += 64) {
        NSString *speedStr = self.originalSpeedAry[i];
        double speed = [speedStr doubleValue];
        if (self.maxSpeedLatest < speed) {
            self.maxSpeedLatest = speed;
        }
        [speedMuteAry addObject:speedStr];
    }
    self.caculateSpeedAry = speedMuteAry;
    NSLog(@"处理后的速度数组中最大的数值为%f",self.maxSpeedLatest);
    NSLog(@"处理后的速度数组为%@",self.caculateSpeedAry);
    
    if (self.caculateSpeedAry.count != 0) {
        //速度的折线图
        NSArray *array = @[@3,@4.8,@4,@3.8,@4,@4.3,@4.5,@3.7];
        SZHChart *speedChart = [[SZHChart alloc] init];
        [speedChart initWithViewsWithBooTomCount:self.caculateSpeedAry.count/5 AndLineDataAry:self.caculateSpeedAry AndYMaxNumber:6];
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

- (void)Back{
    [self.navigationController popViewControllerAnimated:YES];
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
    self->_shareDataView = [[MGDShareDataView alloc] init];
    [self.shareDataView.userIcon sd_setImageWithURL:[NSURL URLWithString:self.userIconStr] placeholderImage:[UIImage imageNamed:@"logo头像"]];
    self.shareDataView.userName.text = self.userNmaeStr;
    self.shareDataView.kmLab.text = self.distanceStr; //跑步距离赋值
    self.shareDataView.speedLab.text = self.speedStr; //配速赋值
    self.shareDataView.timeLab.text = self.timeStr;   //跑步时间赋值
    self.shareDataView.calLab.text = self.energyStr; //燃烧千卡赋值
    self.shareDataView.paceLab.text = self.stepFrequencyStr; //步频
    self.shareDataView.date.text = self.date; //日期
    self.shareDataView.currentTime.text = self.time; //时间
    self.shareDataView.speedLab.text = self.MaxSpeed; //最大速度
    self.shareDataView.paceLab.text = self.MaxStepFrequency; //最大步频
    [self.shareView.dataView addSubview:_shareDataView];
    UILongPressGestureRecognizer *QrCodeTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(qrCodeLongPress:)];
    self.shareView.QRImage.userInteractionEnabled = YES;
    [self.shareView.QRImage addGestureRecognizer:QrCodeTap];
}

//暂时未放二维码
- (void)qrCodeLongPress:(UILongPressGestureRecognizer *)longPress {
    //创建上下文context
    CIContext *context = [[CIContext alloc] init];
    //创建探测器
    CIDetector *QRCodeDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    //识别图片，获取特征
    CIImage *imgCI = [[CIImage alloc] initWithImage:self.shareView.QRImage.image];
    NSArray *features = [QRCodeDetector featuresInImage:imgCI];
    
    //判断是否识别到二维码
    if (features.count > 0) {
     
        //有二维码
        CIQRCodeFeature *qrcodeFeature = (CIQRCodeFeature *)features[0];
        
        __weak typeof(self) weakSelf = self;
        UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"" message:@"识别内容" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *dicern = [UIAlertAction actionWithTitle:@"识别图中二维码" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            UIViewController *resultVC = [[UIViewController alloc] init];
            [weakSelf.navigationController pushViewController:resultVC animated:YES];
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [sheet addAction:dicern];
        [sheet addAction:cancel];
        [self presentViewController:sheet animated:YES completion:nil];
        
    }else{
     
        //没有二维码，这只是一张普通的图片
        NSLog(@"|没有二维码，这只是一张普通的图片|");
    }

}

//- (void)backevent:(UIGestureRecognizer *)sender {
//    NSLog(@"手势");
//}


- (void)back {
    [UIView animateWithDuration:0.3 animations:^{
        [self.shareView removeFromSuperview];
    }];
}

//处理从毛国栋传过来的位置、步频、速度数组
- (void)separateString{
    //速度数组
       NSMutableArray *muteSpeedAry = [NSMutableArray array];
       for (int i = 0; i < self.speedArray.count; i++) {
           NSString *string = self.speedArray[i];
           NSArray *array = [string componentsSeparatedByString:@","];//根据逗号分割字符串
           NSString *string2 = array[1];
           [muteSpeedAry addObject:string2];
       }
       self.originalSpeedAry = muteSpeedAry;
    NSLog(@"原始的速度数组为%@",self.originalSpeedAry);
    
    //步频数组
    NSMutableArray *muteStepsAry = [NSMutableArray array];
    for (int i = 0; i < self.stepFrequencyArray.count; i++) {
        NSString *string = self.stepFrequencyArray[i];
        NSArray *array = [string componentsSeparatedByString:@","];//根据逗号分割字符串
        NSString *string2 = array[1];
        [muteStepsAry addObject:string2];
    }
    self.originalStepsAry = muteStepsAry;
    NSLog(@"原始的步频数组为%@",self.originalStepsAry);
    
//    //位置数组
    NSMutableArray *muteLocationAry = [NSMutableArray array];
    for (int i = 0; i < self.locationAry.count; i++) {
        NSString *string = self.locationAry[i];
        NSArray *array = [string componentsSeparatedByString:@","];//根据逗号分割字符串
        double lat = [array[0] doubleValue];
        double lon = [array[1] doubleValue];
        RunLocationModel *model = [[RunLocationModel alloc] init];
        model.location = CLLocationCoordinate2DMake(lat, lon);
        [muteLocationAry addObject:model];
    }
    self.originalLocationAry = muteLocationAry;
    
    NSLog(@"未处理的位置数组为%@",self.locationAry);
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
    CLLocationCoordinate2D lineCoordinates[self.originalLocationAry.count];
    for (int i = 0; i < self.originalLocationAry.count; i++) {
        RunLocationModel *model = self.originalLocationAry[i];
        lineCoordinates[i] = model.location;
    }
    self.smoothedTrace = [MAPolyline polylineWithCoordinates:lineCoordinates count:self.originalLocationAry.count];
    [self.overView.mapView addOverlay:self.smoothedTrace];
}

//自定义轨迹线
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    if ([overlay isKindOfClass:[MAPolyline class]]) {
              MAPolylineRenderer *polyLineRender = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
              polyLineRender.lineWidth = 8;
        polyLineRender.strokeColor = [UIColor colorWithRed:129/255.0 green:233/255.0 blue:255/255.0 alpha:1]; //折线颜色
         return polyLineRender;
        }
          return nil;
}

#pragma mark- 大头针
 //设置开始，结束位置的大头针
- (void)initBeginAndEndAnnotations{
        //开始地点
        MAPointAnnotation *beginAnnotation = [[MAPointAnnotation alloc] init];
    RunLocationModel *beginModel = self.originalLocationAry.firstObject;
    beginAnnotation.coordinate = beginModel.location;
    self.beginAnnotataion = beginAnnotation;
    [self.overView.mapView addAnnotation:self.beginAnnotataion];
        
        //结束地点
    MAPointAnnotation *endAnnotation = [[MAPointAnnotation alloc] init];
    RunLocationModel *endModel = self.originalLocationAry.lastObject;
    endAnnotation.coordinate = endModel.location;
    self.endAnnotataion = endAnnotation;
    [self.overView.mapView addAnnotation:self.endAnnotataion];
}
    //设置开始、结束位置大头针的样式
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
      }else if(annotation == self.endAnnotataion){
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
                    [self.overView.mapView setCustomMapStyleOptions:options];
                    [self.overView.mapView setCustomMapStyleEnabled:YES];
                    
                } else if (mode == UIUserInterfaceStyleLight) {
                    NSLog(@"浅色模式");
                    //设置浅色模式下的自定义地图样式
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


- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        NSLog(@"保存成功");
    }
}
@end

