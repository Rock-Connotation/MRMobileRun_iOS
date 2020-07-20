//
//  MGDUserData.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGDUserData : NSObject

@property (nonatomic, strong) NSString *total_distance;

@property (nonatomic, strong) NSString *total_duration;

@property (nonatomic, strong) NSString *total_consume;

-(instancetype)initWithDic:(NSDictionary *)dict;

+(instancetype)DataWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
