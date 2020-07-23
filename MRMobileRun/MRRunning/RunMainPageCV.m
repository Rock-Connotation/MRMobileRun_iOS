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

@interface RunMainPageCV ()<MAMapViewDelegate,RunmodelDelegate,AMapLocationManagerDelegate>
@property (nonatomic, strong) RunningMainPageView *Mainview;
@property (nonatomic, strong) RunningModel *model;
@property (nonatomic, assign) CGFloat yyy;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property(nonatomic,strong)MAAnnotationView *myAnnotationView;//我的当前位置的大头针
@property(nonatomic,strong)MAPolyline *polyline;//当前绘制的轨迹曲线

@property(nonatomic,strong)NSMutableArray <RunningModel *>*perfectArray;//优化完成的定位数据数组
@property(nonatomic,strong)NSMutableArray <RunningModel *>*drawLineArray;//待绘制定位线数据

@property(nonatomic,assign)int lastDrawIndex;//绘制最后数据的下标次数(perfectArray)
@property(nonatomic,assign)NSInteger locationNumber;//定位次数
@property(nonatomic,assign)BOOL isFirstLocation;//是否是第一次定位

@end

@implementation RunMainPageCV

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Mainview = [[RunningMainPageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.Mainview];
    [self.Mainview mainRunView];
    [self btnFunction];
    self.Mainview.mapView.delegate = self;
    
    //拖拽底部视图的高度
//    UIGestureRecognizer *pan = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(dragAction:)];
//    [self.Mainview.dragLabel addGestureRecognizer:pan];
//    self.Mainview.dragLabel.userInteractionEnabled = YES;
}

-(void)setModel:(RunningModel *)model{
    self.model = model;
    self.model.delegate = self;
    self.Mainview.numberLabel.text = model.distanceStr;
    self.Mainview.speedNumberLbl.text = model.speedStr;
    self.Mainview.energyNumberLbl.text = model.energyStr;
}
 
#pragma mark- 懒加载
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
    self.sportsState = sportsState;
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
            break;
    }
}
#pragma mark-运动时间
-(void)time:(NSString *)timeStr timeNum:(int)time
{
    self.Mainview.timeNumberLbl.text = timeStr;
}


#pragma mark- 定位数据
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    
    
}
#pragma mark- 绘制定位大头针
//绘制开始位置大头针
- (void)drawStartRunPointAction:(RunLocationModel *)runModel{
    if (self.isFirstLocation && self.Mainview.mapView.userLocation.location != nil) {
        MAPointAnnotation *startPointAnnotation = [[MAPointAnnotation alloc] init];
        startPointAnnotation.coordinate = *(runModel.location);
        [self.perfectArray addObject:runModel]; //为消除误差了的数组添加第一个元素
        self.isFirstLocation = NO;
         self.lastDrawIndex = 0;
    }
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
    [self.Mainview.endtBtn addTarget:self action:@selector(endMethod) forControlEvents:UIControlEventTouchUpInside];
}

//点击暂停按钮的方法
- (void)pauseMethod{
    self.Mainview.pauseBtn.hidden = YES;
    self.Mainview.lockBtn.hidden = YES;
    self.Mainview.endtBtn.hidden = NO;
     self.Mainview.continueBtn.hidden = NO;
}

//点击锁屏按钮方法
- (void)lockMethod{
    self.Mainview.pauseBtn.hidden = YES;
    self.Mainview.lockBtn.hidden = YES;
    self.Mainview.unlockBtn.hidden = NO;
}
//长按解锁按钮方法
- (void)unlockMethod{
    //
    self.Mainview.unlockLongPressView.hidden = YES;
    self.Mainview.lockBtn.hidden = NO;
    self.Mainview.pauseBtn.hidden = NO;
}
//点击继续按钮方法
- (void)continueMethod{
    self.Mainview.unlockBtn.hidden = YES;
    self.Mainview.endtBtn.hidden = YES;
    self.Mainview.continueBtn.hidden = YES;
    self.Mainview.pauseBtn.hidden = NO;
    self.Mainview.lockBtn.hidden = NO;
    
}

//长按结束按钮方法
- (void)endMethod{
    //
}


@end
