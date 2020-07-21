//
//  MapPolylineModel.h
//  MRMobileRun
//
//  Created by 石子涵 on 2020/7/21.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKOverlay.h>
#import <MAMapKit/MAOverlay.h>
NS_ASSUME_NONNULL_BEGIN

@interface MapPolylineModel : NSObject
@property (nonatomic, strong) NSMutableArray *pointArray;

- (instancetype)initWithPoints:(NSArray *)nsvaluePoints;
- (MAMapRect)showRect;
- (MAMapPoint)mapPointForPointAt:(NSUInteger)index;
- (void)updatePoints:(NSArray *)points;
- (void)appendPoint:(MAMapPoint)point;
- (void)appendPoints:(CLLocationCoordinate2D *)points count:(NSInteger)count;
@end

NS_ASSUME_NONNULL_END
