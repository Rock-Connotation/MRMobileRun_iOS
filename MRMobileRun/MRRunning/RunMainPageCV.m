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
    [self.Mainview mainRunView];
    self.Mainview.mapView.delegate = self;
}
@end
