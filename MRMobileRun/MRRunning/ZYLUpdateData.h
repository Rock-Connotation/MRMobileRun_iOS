//
//  ZYLUpdateData.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/5/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYLUpdateData : NSObject
+ (NSDictionary *)ZYLGetUpdateDataDictionaryWithBegintime:(NSNumber *)begin Endtime:(NSNumber *)end distance:(NSNumber *)distance lat_lng:(NSArray *)lat_lng andSteps:(NSNumber *)steps;
@end

NS_ASSUME_NONNULL_END
