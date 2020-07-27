//
//  RunLocationModel.h
//  MRMobileRun
//
//  Created by 石子涵 on 2020/7/22.
//

#import <Foundation/Foundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RunLocationModel : NSObject
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, assign) CLLocationSpeed speed;
@property (nonatomic, strong) NSDate *time; //记录每个定位点的时间

@end

NS_ASSUME_NONNULL_END
