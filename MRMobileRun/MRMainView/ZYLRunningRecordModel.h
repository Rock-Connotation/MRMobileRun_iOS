//
//  ZYLRunningRecordModel.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/5/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYLRunningRecordModel : NSObject
@property (copy, nonatomic) NSString *begin_time;
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *distance;
@property (copy, nonatomic) NSString *end_time;
@property (copy, nonatomic) NSString *position;
@property (copy, nonatomic) NSString *student_id;

- (instancetype)initWithDic:(NSDictionary*)dic;
+ (instancetype)ModelWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
