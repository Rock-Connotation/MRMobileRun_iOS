//
//  RunningMainPageView.h
//  MRMobileRun
//
//  Created by 石子涵 on 2020/7/10.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface RunningMainPageView : UIView
@property (nonatomic, strong) MAMapView *mapView;
- (void)Init;
@end

NS_ASSUME_NONNULL_END
