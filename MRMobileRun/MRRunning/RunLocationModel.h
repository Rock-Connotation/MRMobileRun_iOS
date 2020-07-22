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
@property (nonatomic, assign) CLLocationCoordinate2D *location;
@property (nonatomic, readonly) CLLocationSpeed *speed;

@end

NS_ASSUME_NONNULL_END
