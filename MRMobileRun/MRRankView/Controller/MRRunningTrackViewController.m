//
//  MRRunningTrackViewController.m
//  MobileRun
//
//  Created by 郑沛越 on 2017/3/12.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "MRRunningTrackViewController.h"
#import "MRRunningTrackView.h"
#import "MRMapView.h"
#import "MAsonry.h"
#import "MRTimeReversalModel.h"
#import "AMapLocationKit/AMapLocationKit.h"
@interface MRRunningTrackViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate>

@property (nonatomic,strong) MRTimeReversalModel *timeReversalModel;

@property double oneTimeDistance;
@end

@implementation MRRunningTrackViewController


- (void)viewWillAppear:(BOOL)animated{
      NSLog(@"\n\n\n\n%@\n\n\n\n",self.runningTrackView.dataBaseView.timeLabel.text);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeReversalModel = [[MRTimeReversalModel alloc]init];
    
    self.locationAry = [[NSMutableArray alloc] init];

    
    self.runningTrackView = [[MRRunningTrackView alloc]init];
    
    self.runningTrackView.mapView.mapView.delegate = self;
    
    self.runningTrackView.mapView.locationManager.delegate = self;
    
    
    [self.runningTrackView.backBtu addTarget:self action:@selector(clickBackBtu) forControlEvents:UIControlEventTouchUpInside];
    
    NSLog(@"\n\n\n\n%@\n\n\n\n",self.locationAry);

    
    self.view = self.runningTrackView;
    
    
    
    
//    [self lacation];
    
    // Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated{
    [self location];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)clickBackBtu{
    
    NSLog(@"%@",@"sss");
     [self dismissViewControllerAnimated:YES completion:nil];
    self.view = nil;

}


- (void)location{

    
    if (self.locationAry.count != 0) {
    
    if (![[NSString stringWithFormat:@"%@",self.locationAry] isEqualToString:@"<null>" ]) {
      
    CLLocationCoordinate2D firstLocation ;
    
    
    NSLog(@"\n\n\nzxc%@\n\n\n",self.locationAry);
    

    
    firstLocation.latitude = [[self.locationAry[0] objectForKey:@"latitude"] doubleValue
        ];
    firstLocation.longitude = [[self.locationAry[0] objectForKey:@"longitude"]doubleValue];

    CLLocationCoordinate2D commonPolylineCoords[self.locationAry.count];

        int j = 0;
    for (int i = 0; i < self.locationAry.count  - 1 ; i++) {
     
        
        commonPolylineCoords[j].longitude = [[self.locationAry[i] objectForKey:@"longitude"]doubleValue];
        commonPolylineCoords[j].latitude = [[self.locationAry[i] objectForKey:@"latitude"]doubleValue];
     self.oneTimeDistance = [self getDistanceWithCommonPolylineCoord:commonPolylineCoords];
        if (self.oneTimeDistance <8) {
            MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:2 ];
            [self.runningTrackView.mapView.mapView addOverlay: commonPolyline];
            
        }
        j++;
        if (j == 2) {
            j = 0;
        }
    }
    
    self.runningTrackView.mapView.mapView.centerCoordinate = firstLocation;


    
    //在地图上添加折线对象
    
    

    }

    }
}




- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    
    
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 5.f;
        
        polylineView.lineJoin = kCGLineJoinBevel;//连接类型
        
        polylineView.strokeColor  = [UIColor colorWithRed:235.0/255.0 green:73.0/255.0 blue:114.0/255.0 alpha:1];
        
        return polylineView;
    }
    
    return nil;
}

-  (double)getDistanceWithCommonPolylineCoord:(CLLocationCoordinate2D *)locationCoordinate2D{
    
    MAMapPoint point1 =  MAMapPointForCoordinate(CLLocationCoordinate2DMake(locationCoordinate2D[0].latitude,locationCoordinate2D[0].longitude ));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(locationCoordinate2D[1].latitude,locationCoordinate2D[1].longitude ));
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    
    
    return distance;
    
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
