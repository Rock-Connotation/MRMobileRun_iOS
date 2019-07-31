//
//  ZYLTimeStamp.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/5/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYLTimeStamp : NSObject

+ (NSString *)getTimeStamp;
+ (NSString *)getCodeTimeStamp;
+ (NSDate *)getDateFromTimeStamp:(NSString *)timeStamp;
@end

NS_ASSUME_NONNULL_END
