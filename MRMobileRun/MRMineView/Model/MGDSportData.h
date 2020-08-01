//
//  MGDSportData.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGDSportData : NSObject

@property (nonatomic, strong) NSString *date;

@property (nonatomic, strong) NSString *distance;

@property (nonatomic, strong) NSString *totalTime;

@property (nonatomic, strong) NSString *cal;

-(instancetype)initWithDic:(NSDictionary *)dict;

+(instancetype)SportDataWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
