//
//  mgduserdata.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/8/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGDUserData : NSObject

@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *consume;

-(instancetype)initWithDic:(NSDictionary *)dict;
+ (instancetype)DataWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
<<<<<<< HEAD
=======

>>>>>>> 46c8a1a5b52742d11a1a90aebbf27bb03dc178fa
